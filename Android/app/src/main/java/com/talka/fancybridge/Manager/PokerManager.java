package com.talka.fancybridge.Manager;

import android.graphics.Color;

import java.util.ArrayList;
import java.util.List;

public class PokerManager {

    static PokerManager instance = null;

    public static String[] Flowers = {"card_diamand","card_clubs","card_heart","card_spade"};
    public static String[] Numbers = {"A","2","3","4","5","6","7","8","9","10","J","Q","K"};
    public static int[] Colors = {Color.parseColor("#F34D46"),Color.parseColor("#330000")};

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
    public String[] otherCards = {"0","0","0","0","0","0","0","0","0","0","0","0","0"};

//    public String[] callsRecord = {"","","",""};
    public List<List<Integer>> callsRecord = new ArrayList<List<Integer>>();
    public List<List<Integer>> playsRecord = new ArrayList<List<Integer>>();
    public List<Integer> boutsWinRecord = new ArrayList<Integer>();
    public int[] flowerCountRecord = {0,0,0,0};
    public int currentFlower = -1;

    public Boolean threeMode = false;
    public int comIndex = -1;

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
        reset();
    }

    public void reset() {
        cards = new String[]{"0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"};
        otherCards = new String[]{"0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"};
        callsRecord.clear();
        playsRecord.clear();
        for(int i=0;i<4;++i) {
            callsRecord.add(new ArrayList<Integer>());
            playsRecord.add(new ArrayList<Integer>());
        }
        boutsWinRecord.clear();
        flowerCountRecord = new int[]{0,0,0,0};
        turnIndex = -1;
        trump = -1;
        currentFlower = -1;
        winNumber = -1;
        ourScroe = 0;
        enemyScroe = 0;
        threeMode = false;
        comIndex = -1;
    }

    public void setCards(String[] cardArray) {

        cards = cardArray;
        if(listener != null) {
            listener.setCardsForUI(cards);
        }
    }

    public void setOtherCards(String[] cardArray) {

        otherCards = cardArray;
    }

    public void callTrump(int index) {
        streamManager.sendMessage(String.format("C%d,%d",stateManager.playInfo.turnIndex,index));
    }

    public void playPoker(int poker) {
        streamManager.sendMessage(String.format("P%d,%d",turnIndex,poker));
    }

    public Boolean twoCardsPlay() {
        int myTurnIndex = stateManager.playInfo.turnIndex;
        return (myTurnIndex+2)%4 == comIndex;
    }

    public boolean canPlayCard() {
        int myTurnIndex = stateManager.playInfo.turnIndex;
        return myTurnIndex == turnIndex;
    }

    public boolean canPlayOtherCard() {
        int otherTurnIndex = (stateManager.playInfo.turnIndex+2)%4;
        return otherTurnIndex == turnIndex;
    }

    public int findMaxCallCount() {
        int max = 0;
        for(int i=0;i<4;++i) {
            int count = callsRecord.get(i).size();
            if(count > max){
                max = count;
            }
        }
        return max;
    }

    public int findMaxPlayCount() {
        int max = 0;
        for(int i=0;i<4;++i) {
            int count = playsRecord.get(i).size();
            if(count > max) {
                max = count;
            }
        }
        return max;
    }
}
