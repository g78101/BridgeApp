package com.talka.fancybridge.Manager;

import android.app.AlertDialog;
import android.app.Service;
import android.content.Context;
import android.content.DialogInterface;
import android.provider.Settings;
import android.telephony.TelephonyManager;

import com.talka.fancybridge.Views.AlertView;
import com.talka.fancybridge.Views.Components.CardView;
import com.talka.fancybridge.Views.LoadingView;

import static java.lang.System.exit;
import static java.lang.Thread.sleep;

public class StateManager implements StreamManager.StreamManagerListener {

    static StateManager instance = null;

    public enum GameState {
        Connected,
        Wait,
        Call,
        CallChoosePartner,
        Play;

        public static GameState fromInteger(int x) {
            switch(x) {
                case -1:
                    return Connected;
                case 0:
                    return Wait;
                case 1:
                    return Call;
                case 2:
                    return CallChoosePartner;
                case 3:
                    return Play;
            }
            return null;
        }
    }

    enum ConnectState {
        S("GameState"),
        M("Message"),
        W("Wait"),
        T("ThreeMode"),
        N("Names"),
        H("Hand"),
        C("Call"),
        P("Play"),
        D("Disconnect"),
        R("Recover");

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

    enum RecoverState {
        cards,
        names,
        callRecord,
        playRecord,
        boutsWin,
        done;

        public static RecoverState fromInteger(int x) {
            switch(x) {
                case 1:
                    return cards;
                case 2:
                    return names;
                case 3:
                    return callRecord;
                case 4:
                    return playRecord;
                case 5:
                    return boutsWin;
                case 6:
                    return done;
            }
            return null;
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
        void recoverPlayingUI();
    }

    public Context context;
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
        this.context=context;
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
                GameState tempState = GameState.fromInteger(Integer.parseInt(splitArray[0]));
                gameState = tempState;

                switch (gameState) {
                    case Connected: {
//                        TelephonyManager tm = (TelephonyManager) context.getSystemService(Service.TELEPHONY_SERVICE);
                        String deviceId = Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);
                        streamManager.sendMessage(String.format("N%s,A-%s",playInfo.name,deviceId));
                        break;
                    }
                    case Wait: {
                        playInfo.turnIndex = Integer.parseInt(splitArray[1]);
                        break;
                    }
                    case Call: {
                        int threeModeInt = Integer.parseInt(splitArray[2]);
                        pokerManager.turnIndex = Integer.parseInt(splitArray[1]);
                        pokerManager.threeMode = (threeModeInt == 1 ? true : false);
                        break;
                    }
                    case CallChoosePartner:
                        break;
                    case Play: {
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
                        break;
                    }
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
                gameState = GameState.CallChoosePartner;
                pokerManager.turnIndex = calledIndex;
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
                            AlertView.showViewSetText(context,String.format("You are player %d",i+1));
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
                    AlertView.showViewSetText(context,"Your Turn");
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
            case D: {
                if(StateManager.getInstance().isGameOver) {
                    return;
                }

                if(info.equals("0")) {
                    AlertDialog.Builder alert = new AlertDialog.Builder(context);
                    alert.setTitle("Server Message");
                    alert.setMessage("Someone Disconnect");
                    alert.setPositiveButton("OK", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialogInterface, int i) {
                        }
                    });
                    alert.show();
                    LoadingView.start(context);
                }
                else if(info.equals("1")) {
                    if((gameState == GameState.CallChoosePartner && pokerManager.turnIndex == playInfo.turnIndex)
                            || gameState != GameState.CallChoosePartner) {
                        LoadingView.stop(context);
                    }
                }
                else {
                    closeConnectAlert("close connect");
                }

                break;
            }
            case R: {
                String stateStr = info.substring(0, 1);
                RecoverState recoverState = RecoverState.fromInteger(Integer.parseInt(stateStr));
                String recoverInfo = info.substring(2);

                switch (recoverState) {
                    case cards: {
                        String[] splitArray = recoverInfo.split("\\^");
                        String cardsStr = splitArray[0];
                        pokerManager.setCards(cardsStr.split(","));
                        if(splitArray.length > 1) {
                            String otherCardsStr = splitArray[1];
                            pokerManager.setOtherCards(otherCardsStr.split(","));
                            pokerManager.threeMode = true;
                        }
                        break;
                    }
                    case names: {
                        String[] splitArray = recoverInfo.split("\\^");
                        int turnIndex = Integer.parseInt(splitArray[0]);
                        String namesStr = splitArray[1];

                        players = namesStr.split(",");
                        playInfo.name = players[turnIndex];
                        playInfo.turnIndex = turnIndex;
                        if(splitArray.length > 2) {
                            String threeNamesStr = splitArray[2];
                            threeModePlayers = threeNamesStr.split(",");

                            for(int i=0;i<4;++i) {
                                if(threeModePlayers[i].equals(playInfo.name)) {
                                    playInfo.turnIndex = i;
                                    AlertView.showViewSetText(context,String.format("You are player %d",i+1));
                                }

                                if ( threeModePlayers[i].equals("-")) {
                                    pokerManager.comIndex = i;
                                }
                            }
                        }
                        break;
                    }
                    case callRecord: {
                        String[] splitArray = recoverInfo.split("\\|");

                        for(int i=0;i<splitArray.length;++i) {
                            String player = splitArray[i];
                            if(player.equals("")) {
                                continue;
                            }
                            String[] records = player.split("\\^");
                            for(String card : records) {
                                if(!card.equals("")) {
                                    pokerManager.callsRecord.get(i).add(Integer.parseInt(card));
                                }
                            }
                        }
                        break;
                    }
                    case playRecord: {
                        String[] splitArray = recoverInfo.split("\\|");

                        for(int i=0;i<splitArray.length;++i) {
                            String player = splitArray[i];
                            if(player.equals("")) {
                                continue;
                            }
                            String[] records = player.split("\\^");
                            for(String card : records) {
                                if(!card.equals("")) {
                                    int poker = Integer.parseInt(card);
                                    int flower = (poker-1)/13;
                                    pokerManager.playsRecord.get(i).add(poker);
                                    pokerManager.flowerCountRecord[flower]+=1;
                                 }
                            }
                        }
                        break;
                    }
                    case boutsWin: {
                        String[] splitArray = recoverInfo.split("\\|");
                        int lastWinIndex = -1;
                        for (String bounts : splitArray) {
                            if (!bounts.equals("")) {
                                int winIndex = Integer.parseInt(bounts);
                                lastWinIndex = winIndex;
                                pokerManager.boutsWinRecord.add(winIndex);
                                if (winIndex == playInfo.turnIndex ||
                                        winIndex == (playInfo.turnIndex + 2) % 4) {
                                    pokerManager.ourScroe += 1;
                                } else {
                                    pokerManager.enemyScroe += 1;
                                }
                            }
                        }
                        if (lastWinIndex != -1 && pokerManager.boutsWinRecord.size() < pokerManager.playsRecord.get(lastWinIndex).size()) {
                            int playRecordWinSize = pokerManager.playsRecord.get(lastWinIndex).size();
                            pokerManager.currentFlower = ((pokerManager.playsRecord.get(lastWinIndex).get(playRecordWinSize - 1)));
                        }
                        break;
                    }
                    case done: {
                        String[] splitArray = recoverInfo.split("\\^");
                        GameState tempState = GameState.fromInteger(Integer.parseInt(splitArray[0]));
                        gameState = tempState;
                        pokerManager.turnIndex = Integer.parseInt(splitArray[1]);
                        pokerManager.trump = Integer.parseInt(splitArray[2]);
                        int callLast = Integer.parseInt(splitArray[3]);

                        if(pokerManager.turnIndex == -1 && playInfo.turnIndex == 0) {
                            new Thread(new Runnable() {
                                @Override
                                public void run() {
                                    try {
                                        sleep(1000);
                                        streamManager.sendMessage("P-1,0");
                                    } catch (InterruptedException e) {
//                                        Log.d("error");
                                    }
                                }
                            }).start();
                        }

                        if (!pokerManager.threeMode) {
                            if (callLast == playInfo.turnIndex || callLast == (playInfo.turnIndex + 2) % 4) {
                                pokerManager.winNumber = PokerManager.totalSum - (pokerManager.trump / 7 + 7);
                            } else {
                                pokerManager.winNumber = (pokerManager.trump / 7 + 7);
                            }
                        }
                        else {
                            if ( playInfo.turnIndex==0 || playInfo.turnIndex==2) {
                                pokerManager.winNumber = (pokerManager.trump / 7 + 7);
                            }
                            else {
                                pokerManager.winNumber = PokerManager.totalSum - (pokerManager.trump / 7 + 7);
                            }
                        }

                        if (listener != null) {
                            listener.changeStateUI(gameState);
                        }

                        if(gameState == GameState.Call) {
                            if(callListener != null) {
                                callListener.updateCallingUI(pokerManager.trump);
                            }
                        }
                        else if (gameState == GameState.CallChoosePartner) {
                            if(callListener != null) {
                                callListener.showThreeModeUI(pokerManager.turnIndex);
                            }
                        }
                        else if (gameState == GameState.Play) {
                            if(playListener != null) {
                                playListener.recoverPlayingUI();
                            }
                        }

                        break;
                    }
                }
                break;
            }
        }
    }

    @Override
    public void connectInterrupt() {
        if(StateManager.getInstance().isGameOver) {
            return;
        }

        if(gameState == GameState.Connected || gameState == GameState.Wait) {
            closeConnectAlert("Someone Leave");
        }
        else {
            AlertDialog.Builder alert = new AlertDialog.Builder(context);
            alert.setTitle("Server Message");
            alert.setMessage("Someone Disconnect");
            alert.setPositiveButton("OK", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialogInterface, int i) {
                    exit(1); }});
            alert.show();
        }
    }

    public void closeConnectAlert(String message) {
        AlertDialog.Builder alert = new AlertDialog.Builder(context);
        alert.setTitle("Server Message");
        alert.setMessage(message);
        alert.setPositiveButton("OK", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialogInterface, int i) {
                exit(1);
            }
        });
        alert.show();
    }

}
