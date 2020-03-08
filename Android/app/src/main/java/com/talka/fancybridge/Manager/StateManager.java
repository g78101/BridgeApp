package com.talka.fancybridge.Manager;

import android.content.Context;

import com.talka.fancybridge.Views.AlertView;
import com.talka.fancybridge.Views.Components.CardView;

import static java.lang.Thread.sleep;

public class StateManager implements StreamManager.StreamManagerListener {

    static StateManager instance = null;

    public enum GameState {
        Wait,
        Call,
        Play
    }

    enum ConnectState {
        S("GameState"),
        M("Message"),
        W("Wait"),
        T("ThreeMode"),
        N("Names"),
        H("Hand"),
        C("Call"),
        P("Play");

        private final String context;

        ConnectState(final String context) {
            this.context = context;
        }

        /* (non-Javadoc)
         * @see java.lang.Enum#toString()
         */
        @Override
        public String toString() {
            return context;
        }
    }

    public enum PlayState {
        Normal,
        LastCard,
        GameOver
    }

    public class PlayerInfo {
        public String name;
        public int turnIndex;

        public PlayerInfo(String setName, int setTurnIndex) {
            name = setName;
            turnIndex = setTurnIndex;
        }
    }

    public interface StateManagerListener {
        void updateWaitingUI(int normalCount,int threeModeCount);

        void changeStateUI(GameState state);
    }

    public interface StateManagerCallListener {
        void updateCallingUI(int index);

        void showThreeModeUI(int index);
    }

    public interface StateManagerPlayListener {
        void updatePlayingUI(int poker, int type, int lastUser);
    }

    public StateManagerListener listener;
    public StateManagerCallListener callListener;
    public StateManagerPlayListener playListener;
    StreamManager streamManager;
    public PlayerInfo playInfo = new PlayerInfo("", -1);
    public String[] players;
    public String[] threeModePlayers;
    GameState gameState = GameState.Wait;
    public Boolean isGameOver = false;

    public static synchronized StateManager getInstance() {
        if (instance == null) {
            instance = new StateManager();
        }
        return instance;
    }

    private StateManager() {
        streamManager = StreamManager.getInstance();
        streamManager.listener = this;
    }

    public void setContext(Context context) {
        streamManager.setContext(context);
    }

    //MARK: - Functions
    public void reset() {
        players = null;
        gameState = GameState.Wait;
        isGameOver = false;
        if (listener != null) {
            listener.changeStateUI(gameState);
        }
    }

    public void connectServer() {
        streamManager.connect();
    }

    public void joinThreeMode() {
        streamManager.sendMessage("W");
    }

    public void choosedPartner(int choosedIndex) {
        streamManager.sendMessage(String.format("T%d", choosedIndex));
    }

    public void interruptConnect() {
        try {
            streamManager.disconnect();
        } catch (Throwable throwable) {
            throwable.printStackTrace();
        }
    }

    public void test(String text) {
        streamManager.sendMessage(text);
    }

    @Override
    public void getData(String data) {
        PokerManager pokerManager = PokerManager.getInstance();
        ConnectState connectState = ConnectState.valueOf(data.substring(0, 1));

        String info = data.substring(1);

        switch (connectState) {
            case S: {
                String[] splitArray = info.split(",");

                if (splitArray[0].equals("0")) {

                    playInfo.turnIndex = Integer.parseInt(splitArray[1]);
                    streamManager.sendMessage("N" + playInfo.name);
                    gameState = GameState.Wait;
                } else if (splitArray[0].equals("1")) {
                    int threeModeInt = Integer.parseInt(splitArray[2]);
                    pokerManager.turnIndex = Integer.parseInt(splitArray[1]);
                    pokerManager.threeMode = (threeModeInt == 1 ? true : false);
                    gameState = GameState.Call;
                } else if (splitArray[0].equals("2")) {

                    int lastUser = Integer.parseInt(splitArray[3]);
                    pokerManager.trump = Integer.parseInt(splitArray[1]);
                    pokerManager.turnIndex = Integer.parseInt(splitArray[2]);
                    pokerManager.callsRecord.get(lastUser).add(-1);

                    if (pokerManager.threeMode) {
                        lastUser = 1;
                    }

                    if (lastUser == playInfo.turnIndex || lastUser == (playInfo.turnIndex + 2) % 4) {
                        pokerManager.winNumber = PokerManager.totalSum - (pokerManager.trump / 7 + 7);
                    } else {
                        pokerManager.winNumber = (pokerManager.trump / 7 + 7);
                    }
                    gameState = GameState.Play;
                }

                if (listener != null) {
                    listener.changeStateUI(gameState);
                }

                break;
            }
            case M: {
//                if (listener != null) {
//                    listener.updateWaitingUI(info);
//                }
                break;
            }
            case W: {
                String[] splitArray = info.split(",");
                int normalCount = Integer.parseInt(splitArray[0]);
                int threeModeCount = Integer.parseInt(splitArray[1]);

                if (listener != null) {
                    listener.updateWaitingUI(normalCount, threeModeCount);
                }
                break;
            }
            case T: {
                int calledIndex = Integer.parseInt(info);
                if (callListener != null) {
                    callListener.showThreeModeUI(calledIndex);
                }
                break;
            }
            case N: {
                if( !pokerManager.threeMode ) {
                    players = info.split(",");
                }
                else {
                    threeModePlayers = info.split(",");

                    for(int i=0;i<4;++i) {
                        if( threeModePlayers[i].equals(playInfo.name) ) {
                            playInfo.turnIndex = i;
                            AlertView.showViewSetText(streamManager.context,String.format("You are player %d",i+1));
                        }

                        if ( threeModePlayers[i].equals("-")) {
                            pokerManager.comIndex = i;
                        }
                    }
                }
                break;
            }
            case H: {
                if( !pokerManager.threeMode ) {
                    pokerManager.setCards(info.split(","));
                }
                else {
                    pokerManager.setOtherCards(info.split(","));
                }
                break;
            }
            case C: {
                String[] splitArray = info.split(",");
                int nowTurn = Integer.parseInt(splitArray[1]);
                int trump = Integer.parseInt(splitArray[2]);
                int lastTurn = Integer.parseInt(splitArray[0]);

                pokerManager.turnIndex = nowTurn;
                if( playInfo.turnIndex == nowTurn) {
                    AlertView.showViewSetText(streamManager.context,"Your Turn");
                }
                pokerManager.callsRecord.get(lastTurn).add(trump);

                if (callListener != null) {
                    callListener.updateCallingUI(trump);
                }

                break;
            }
            case P: {
                String[] splitArray = info.split(",");
                int nextTurn = Integer.parseInt(splitArray[2]);
                int lastTurn = (nextTurn + 4 - 1) % 4;
                int poker = Integer.parseInt(splitArray[0]);
                pokerManager.turnIndex = nextTurn;

                PlayState playState = PlayState.Normal;
                if (splitArray[1].equals("0")) {
                    playState = PlayState.Normal;
                } else if (splitArray[1].equals("1")) {
                    playState = PlayState.LastCard;
                } else if (splitArray[1].equals("2")) {
                    playState = PlayState.GameOver;
                }

                switch (playState) {
                    case Normal:
                        if (poker != 0) {
                            if (pokerManager.currentFlower == -1) {
                                pokerManager.currentFlower = (poker - 1) / 13;
                            }

                            int flower = (poker - 1) / 13;
                            pokerManager.playsRecord.get(lastTurn).add(poker);
                            pokerManager.flowerCountRecord[flower] += 1;
                        }
                        else {
                            pokerManager.boutsWinRecord.add(nextTurn);
                        }
                        break;
                    case LastCard:
                        int flower = (poker - 1) / 13;
                        pokerManager.playsRecord.get(lastTurn).add(poker);
                        pokerManager.flowerCountRecord[flower] += 1;

                        if (playInfo.turnIndex == 0) {
                            new Thread(new Runnable() {
                                @Override
                                public void run() {
                                    try {
                                        sleep(2000);
                                        streamManager.sendMessage("P-1,0");
                                    } catch (InterruptedException e) {
//                                        Log.d("error");
                                    }
                                }
                            }).start();
                        }

                        pokerManager.currentFlower = -1;
                        pokerManager.turnIndex = -1;

                        break;
                    case GameOver:
                        pokerManager.boutsWinRecord.add(nextTurn);
                        isGameOver = true;
                        break;
                }

                if (playListener != null) {
                    playListener.updatePlayingUI(poker, Integer.parseInt(splitArray[1]), lastTurn);
                }

                break;
            }
        }
    }

}
