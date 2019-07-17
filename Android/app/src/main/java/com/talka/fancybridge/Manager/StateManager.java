package com.talka.fancybridge.Manager;

import android.content.Context;

import com.talka.fancybridge.Views.CardView;

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

        public PlayerInfo(String setName,int setTurnIndex) {
            name = setName;
            turnIndex = setTurnIndex;
        }
    }

    public interface  StateManagerListener {
        void updateWaitingUI(String text);
        void changeStateUI(GameState state);
    }

    public interface  StateManagerCallListener {
        void updateCallingUI(int index);
    }

    public interface  StateManagerPlayListener {
        void updatePlayingUI(int poker,int type,int lastUser);
    }

    public StateManagerListener listener;
    public StateManagerCallListener callListener;
    public StateManagerPlayListener playListener;
    StreamManager streamManager;
    public PlayerInfo playInfo = new PlayerInfo("",-1);
    public String[] players;
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

    public void interruptConnect() {
        try {
            streamManager.finalize();
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
        ConnectState connectState = ConnectState.valueOf(data.substring(0,1));

        String info = data.substring(1);

        switch (connectState) {
            case S: {
                String[] splitArray = info.split(",");

                if(splitArray[0].equals("0")) {

                    playInfo.turnIndex = Integer.parseInt(splitArray[1]);
                    streamManager.sendMessage("N"+playInfo.name);
                    gameState = GameState.Wait;
                }
                else if(splitArray[0].equals("1")) {

                    pokerManager.turnIndex = Integer.parseInt(splitArray[1]);
                    gameState = GameState.Call;
                }
                else if(splitArray[0].equals("2")) {

                    int lastUser = Integer.parseInt(splitArray[3]);
                    pokerManager.trump = Integer.parseInt(splitArray[1]);
                    pokerManager.turnIndex = Integer.parseInt(splitArray[2]);

                    if (lastUser==playInfo.turnIndex||lastUser==(playInfo.turnIndex+2)%4) {
                        pokerManager.winNumber = PokerManager.totalSum-(pokerManager.trump/7+7);
                    }
                    else {
                        pokerManager.winNumber = (pokerManager.trump/7+7);
                    }
                    gameState = GameState.Play;
                }

                if (listener != null) {
                    listener.changeStateUI(gameState);
                }

                break;}
            case M: {
                if (listener != null) {
                    listener.updateWaitingUI(info);
                }
                break;}
            case N: {
                players = info.split(",");
                break; }
            case H: {
                pokerManager.setCards(info.split(","));
                break; }
            case C: {
                String[] splitArray = info.split(",");
                int nowTurn = Integer.parseInt(splitArray[1]);
                int trump = Integer.parseInt(splitArray[2]);
                int lastTurn = Integer.parseInt(splitArray[0]);
                String tempStr;

                pokerManager.turnIndex = nowTurn;

                String updateRecord = pokerManager.callsRecord[lastTurn];
                if(trump != -1) {
                    tempStr = String.format("%d %s\n",(trump/7)+1,PokerManager.flowers[trump%7]);
                }
                else {
                    tempStr = "Pass\n";
                }
                pokerManager.callsRecord[lastTurn] = updateRecord + tempStr;

                if(callListener != null) {
                    callListener.updateCallingUI(trump);
                }

                break; }
            case P: {
                String[] splitArray = info.split(",");
                int nextTurn = Integer.parseInt(splitArray[2]);
                int lastTurn = (nextTurn+4-1)%4;
                int poker = Integer.parseInt(splitArray[0]);
                pokerManager.turnIndex = nextTurn;
                String tempStr;
                PlayState playState = PlayState.Normal;
                if(splitArray[1].equals("0")) {
                    playState = PlayState.Normal;
                }
                else if(splitArray[1].equals("1")) {
                    playState = PlayState.LastCard;
                }
                else if(splitArray[1].equals("2")) {
                    playState = PlayState.GameOver;
                }

                switch (playState) {
                    case Normal:
                        if(poker != 0) {
                        if(pokerManager.currentFlower == -1) {
                            pokerManager.currentFlower=(poker-1)/13;
                        }

                        String updateRecord = pokerManager.playsRecord[lastTurn];
                        int flower = (poker-1)/13;
                        tempStr = String.format("%s",CardView.showPokerStr(poker));

                        pokerManager.playsRecord[lastTurn] = updateRecord + tempStr;
                        pokerManager.flowerCountRecord[flower] += 1;
                    }
                        break;
                    case LastCard:
                        String updateRecord = pokerManager.playsRecord[lastTurn];
                        int flower = (poker-1)/13;
                        tempStr = String.format("%s",CardView.showPokerStr(poker));

                        pokerManager.playsRecord[lastTurn] = updateRecord + tempStr;
                        pokerManager.flowerCountRecord[flower] += 1;

                        if(playInfo.turnIndex == 3) {
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
                        isGameOver = true;
                        break;
                }

                if(playListener != null) {
                    playListener.updatePlayingUI(poker, Integer.parseInt(splitArray[1]), lastTurn);
                }

                break; }
        }
    }

}
