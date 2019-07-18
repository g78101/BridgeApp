package com.talka.fancybridge.Views;

import android.app.AlertDialog;
import android.content.Context;
import android.support.constraint.ConstraintLayout;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.talka.fancybridge.Manager.PokerManager;
import com.talka.fancybridge.Manager.StateManager;
import com.talka.fancybridge.R;

import java.util.ArrayList;
import java.util.List;

public class PlayView extends ConstraintLayout implements StateManager.StateManagerPlayListener {

    static String TrumpText = "%d%s!!!";
    static String TeamInfoText = "  Our Team\n\t\t\t\t\t\t\t%d / %d\n  Enemy Team\n\t\t\t\t\t\t\t%d / %d";
    static String[] TunrArray = {"↓","←","↑","→"};

    private CardsView cardsView;
    private CardsView rightCardsView;
    private CardsView leftCardsView;
    private CardsView topCardsView;
    private TextView turnView;
    private List<ImageView> tablePokers = new ArrayList<ImageView>();
    private TextView teamInfo;
    private TextView trump;
    private Button history;
    private Button again;

    private PokerManager pokerManager;
    private StateManager stateManager;

    public PlayView(Context context) {
        super(context);
        init(context);
    }

    public PlayView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }

    public PlayView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init(context);
    }

    private void init(Context context) {
        LayoutInflater inflate = (LayoutInflater) this.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View view = inflate.inflate(R.layout.play_view, this, true);

        cardsView = (CardsView) findViewById(R.id.playcards);
        rightCardsView = (CardsView) findViewById(R.id.rightCards);
        leftCardsView = (CardsView) findViewById(R.id.leftCards);
        topCardsView = (CardsView) findViewById(R.id.topCards);
        trump = (TextView) findViewById(R.id.trumpText);
        history = (Button) findViewById(R.id.historyBtn);
        teamInfo = (TextView) findViewById(R.id.teamInfo);
        turnView = (TextView) findViewById(R.id.turn);
        tablePokers.add((ImageView) findViewById(R.id.tablePokers0));
        tablePokers.add((ImageView) findViewById(R.id.tablePokers1));
        tablePokers.add((ImageView) findViewById(R.id.tablePokers2));
        tablePokers.add((ImageView) findViewById(R.id.tablePokers3));
        again = (Button) findViewById(R.id.againBtn);

        history.setOnClickListener( new OnClickListener() {
            @Override
            public void onClick(View view) {
                InfoView infoView = new InfoView(getContext());
                addView(infoView,getWidth(),getHeight());
            }
        });

        again.setOnClickListener( new OnClickListener() {
            @Override
            public void onClick(View view) {
                again.setVisibility(INVISIBLE);
                pokerManager.reset();
                stateManager.reset();
                stateManager.connectServer();
            }
        });


        pokerManager = PokerManager.getInstance();
        stateManager = StateManager.getInstance();
        stateManager.playListener = this;
        cardsView.setEnable(false);
        rightCardsView.otherPlayer();
        leftCardsView.otherPlayer();
        topCardsView.otherPlayer();
    }

    @Override
    public void setVisibility(int visibility) {
        super.setVisibility(visibility);

        if (visibility == View.VISIBLE) {

            cardsView.setHandCards(pokerManager.cards);

            if(stateManager.playInfo.turnIndex == pokerManager.turnIndex) {
                cardsView.setEnable(true);
            }
            cardsView.resetCard();
            leftCardsView.resetCard();
            topCardsView.resetCard();
            rightCardsView.resetCard();

            updateTitleView();
            updateScoreView();
            updateTurnView(-1);
        }
    }

    void updateTitleView() {
        String str = String.format(PlayView.TrumpText,pokerManager.trump/7+1,PokerManager.flowers[pokerManager.trump%7]);
        trump.setText(str);
    }

    void updateScoreView() {
        String str = String.format(PlayView.TeamInfoText,pokerManager.ourScroe,pokerManager.winNumber,pokerManager.enemyScroe,PokerManager.totalSum-pokerManager.winNumber);
        teamInfo.setText(str);
    }

    void updateTurnView(int type) {

        if(type == -1 || type == 0/* StateManager.PlayState.Normal == 0 */) {
            int k = stateManager.playInfo.turnIndex;
            for(int i=0;i<4;++i) {
                if(k==pokerManager.turnIndex) {
                    turnView.setText(PlayView.TunrArray[i]);
                    break;
                }
                k=(k+1)%4;
            }
        }
        else {
            turnView.setText("⊕");
        }
    }

    @Override
    public void updatePlayingUI(int poker, int type, int lastUser) {

        int myTurnIndex = stateManager.playInfo.turnIndex;
        cardsView.setEnable(myTurnIndex == pokerManager.turnIndex);

        int k = myTurnIndex;
        for(int i=0;i<4;++i) {
            if(poker == 0) {
                tablePokers.get(i).setImageDrawable(null);
            }
            else if(k==lastUser) {
                String fileName = String.format("card%d",poker);
                int resID = getResources().getIdentifier(fileName, "mipmap", getContext().getPackageName());
                tablePokers.get(i).setImageResource(resID);
                break;
            }
            k=(k+1)%4;
        }

        if(lastUser != myTurnIndex && poker != 0) {
            if((myTurnIndex+1)%4 == lastUser) {
                leftCardsView.playingCard();
            }
            else if((myTurnIndex+2)%4 == lastUser) {
                topCardsView.playingCard();
            }
            else {
                rightCardsView.playingCard();
            }
        }

        updateTurnView(type);

        if(poker == 0) {

            if (lastUser==myTurnIndex||lastUser==(myTurnIndex+2)%4) {
                pokerManager.enemyScroe += 1;
            }
            else {
                pokerManager.ourScroe += 1;
            }

            updateScoreView();

            if (stateManager.isGameOver) {
                stateManager.interruptConnect();
                again.setVisibility(View.VISIBLE);

                String message = "You Win ~~~";
                if(pokerManager.ourScroe < pokerManager.winNumber) {
                    message = " You Lose ...";
                }

                AlertDialog.Builder alert = new AlertDialog.Builder(getContext());
                alert.setTitle("Game Finish");
                alert.setMessage(message);
                alert.setNegativeButton("OK", null);
                alert.show();
            }
        }
    }
}