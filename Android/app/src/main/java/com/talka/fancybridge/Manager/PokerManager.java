package com.talka.fancybridge.Manager;

public class PokerManager {

    static PokerManager instance = null;
    public static String[] flowers = {" SA"," MD"," C"," D"," H"," S"," NT"};

    public interface PokerManagerListener {
        void setCardsForUI(String[] cardArray);
    }

    public static int HandCardsCount=13;
    public static int totalSum = 14;

    public int turnIndex = -1;
    public int trump = -1;
    public int winNumber = -1;
    public int ourScroe = 0;
    public int enemyScroe = 0;
    public String[] cards = {"0","0","0","0","0","0","0","0","0","0","0","0","0"};

    public String[] callsRecord = {"","","",""};
    public String[] playsRecord = {"","","",""};
    public int currentFlower = -1;

    public StreamManager streamManager;
    public StateManager stateManager;
    public PokerManagerListener listener;

    public static synchronized PokerManager getInstance() {
        if (instance == null) {
            instance = new PokerManager();
        }
        return instance;
    }

    private PokerManager() {
        streamManager = StreamManager.getInstance();
        stateManager = StateManager.getInstance();
    }

    public void reset() {
        cards = new String[]{"0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"};
        callsRecord = new String[]{"", "", "", ""};
        playsRecord = new String[]{"", "", "", ""};
        turnIndex = -1;
        trump = -1;
        currentFlower = -1;
        winNumber = -1;
        ourScroe = 0;
        enemyScroe = 0;
    }

    public void setCards(String[] cardArray) {

        cards = cardArray;
        if(listener != null) {
            listener.setCardsForUI(cards);
        }
    }

    public void callTrump(int index) {
        streamManager.sendMessage(String.format("C%d,%d",stateManager.playInfo.turnIndex,index));
    }

    public void playPoker(int index) {
        streamManager.sendMessage(String.format("P%d,%d",stateManager.playInfo.turnIndex,Integer.parseInt(cards[index])));
        cards[index] = "0";
    }
}
