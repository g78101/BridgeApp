package com.talka.fancybridge.Views;

import android.app.AlertDialog;
import android.content.Context;
import android.graphics.Color;
import android.os.Looper;
import android.support.constraint.ConstraintLayout;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;
import android.os.Handler;

import com.talka.fancybridge.Manager.PokerManager;
import com.talka.fancybridge.Manager.StateManager;
import com.talka.fancybridge.R;
import com.talka.fancybridge.Views.Components.CardsView;
import com.talka.fancybridge.Views.Components.CardView;
import com.talka.fancybridge.Views.Components.FinishView;

import java.util.ArrayList;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

public class PlayView extends ConstraintLayout implements StateManager.StateManagerPlayListener {

    static String[] TrumpType = {"border_small","border_middle","border_clubs","border_diamand","border_heart","border_spade","border_notrump"};
    static String TeamInfoText = "  Our Team %d/%d\nEnemy Team %d/%d";
    static Float[] TunrArray = {0.0f, 90.0f, 180.0f, 270.0f};

    private CardsView cardsView;
    private CardsView rightCardsView;
    private CardsView leftCardsView;
    private CardsView topCardsView;
    private ImageView turnView;
    private List<CardView> tablePokers = new ArrayList<CardView>();
    private List<TextView> tableIndex = new ArrayList<TextView>();
    private TextView trumpText;
    private ImageView trumpType;
    private TextView teamInfo;
    private ImageButton history;
    private FinishView finishView;

    private Timer judgeTimer;
    private int animationIndex = -1;

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
        history = (ImageButton) findViewById(R.id.historyBtn);
        trumpText = (TextView) findViewById(R.id.trumpText);
        trumpType = (ImageView) findViewById(R.id.trumpType);
        teamInfo = (TextView) findViewById(R.id.teamInfo);
        turnView = (ImageView) findViewById(R.id.turn);
        finishView = (FinishView) findViewById(R.id.finishView);
        tablePokers.add((CardView) findViewById(R.id.tablePokers0));
        tablePokers.add((CardView) findViewById(R.id.tablePokers1));
        tablePokers.add((CardView) findViewById(R.id.tablePokers2));
        tablePokers.add((CardView) findViewById(R.id.tablePokers3));
        tableIndex.add((TextView) findViewById(R.id.tableIndex0));
        tableIndex.add((TextView) findViewById(R.id.tableIndex1));
        tableIndex.add((TextView) findViewById(R.id.tableIndex2));
        tableIndex.add((TextView) findViewById(R.id.tableIndex3));

        history.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View view) {
                InfoView infoView = new InfoView(getContext());
                addView(infoView,getWidth(),getHeight());

            }
        });

        pokerManager = PokerManager.getInstance();
        stateManager = StateManager.getInstance();
        stateManager.playListener = this;
        cardsView.setEnable(false);
        rightCardsView.otherPlayer();
        rightCardsView.setEnable(false);
        leftCardsView.otherPlayer();
        leftCardsView.setEnable(false);
        topCardsView.otherPlayer();
        topCardsView.setEnable(false);

        leftCardsView.setSmallFont();
        topCardsView.setSmallFont();
        rightCardsView.setSmallFont();

        finishView.setInfo(false);

        for(CardView cardView : tablePokers) {
            cardView.setEnable(false);
        }
    }

    @Override
    public void setVisibility(int visibility) {
        super.setVisibility(visibility);
        LoadingView.stop(getContext());

        if (visibility == View.VISIBLE) {
            cardsView.setHandCards(pokerManager.cards);
            cardsView.setTag(stateManager.playInfo.turnIndex);
            leftCardsView.setTag((stateManager.playInfo.turnIndex+1)%4);
            topCardsView.setTag((stateManager.playInfo.turnIndex+2)%4);
            rightCardsView.setTag((stateManager.playInfo.turnIndex+3)%4);

            cardsView.resetCard();
            leftCardsView.resetCard();
            topCardsView.resetCard();
            rightCardsView.resetCard();

            // Three Mode
            if(pokerManager.threeMode && pokerManager.twoCardsPlay()) {
                topCardsView.setHandCards(pokerManager.otherCards);
                topCardsView.setScaleX(0.8f);
                topCardsView.setScaleY(0.8f);
                topCardsView.setRotation(0.f);
            }
            else {
                topCardsView.otherPlayer();
                topCardsView.setScaleX(0.5f);
                topCardsView.setScaleY(0.5f);
                topCardsView.setRotation(180.f);
            }

            cardsView.checkCardsPlay();
            topCardsView.checkCardsPlay();

            if(pokerManager.comIndex == (int)leftCardsView.getTag()) {
                leftCardsView.setHandCards(pokerManager.otherCards);
            } else {
                leftCardsView.otherPlayer();
            }
            if (pokerManager.comIndex == (int)rightCardsView.getTag()) {
                rightCardsView.setHandCards(pokerManager.otherCards);
            } else {
                rightCardsView.otherPlayer();
            }

            updateTitleView();
            updateScoreView();
            updateTurnView(-1);

            int k = stateManager.playInfo.turnIndex;
            for(int i=0;i<4;++i) {
                tableIndex.get(i).setText(String.format("%d",k+1));
                k=(k+1)%4;
            }
        }
    }

    void updateTitleView() {
        trumpText.setText(String.format("%d",pokerManager.trump/7+1));
        int resID = getResources().getIdentifier(PlayView.TrumpType[pokerManager.trump%7], "mipmap", getContext().getPackageName());
        trumpType.setImageResource(resID);
    }

    void updateScoreView() {
        String str = String.format(PlayView.TeamInfoText,pokerManager.ourScroe,pokerManager.winNumber,pokerManager.enemyScroe,PokerManager.totalSum-pokerManager.winNumber);
        teamInfo.setText(str);
    }

    void updateTurnView(int type) {

        if (judgeTimer != null) {
            judgeTimer.cancel();
            judgeTimer = null;
        }

        for(TextView textView: tableIndex) {
            textView.setTextColor(Color.WHITE);
        }

        if (type == -1 || type == 0/* StateManager.PlayState.Normal == 0 */) {
            int k = stateManager.playInfo.turnIndex;
            for (int i = 0; i < 4; ++i) {
                if (k == pokerManager.turnIndex) {
                    turnView.setRotation(PlayView.TunrArray[i]);
                    tableIndex.get(i).setTextColor(Color.parseColor("#000000"));
                    break;
                }
                k = (k + 1) % 4;
            }
            animationIndex = (pokerManager.turnIndex+1)%4;
        } else {

            judgeTimer = new Timer(true);
            judgeTimer.schedule(new TimerTask() {
                @Override
                public void run() {
                    new Handler(Looper.getMainLooper()).post(new Runnable() {
                        @Override
                        public void run() {

                            turnView.setRotation(PlayView.TunrArray[animationIndex]);
                            for (int i = 0; i < 4; ++i) {
                                tableIndex.get(i).setTextColor(Color.WHITE);
                            }
                            tableIndex.get(animationIndex).setTextColor(Color.parseColor("#000000"));
                            animationIndex = (animationIndex + 1) % 4;
                        }
                    });
                }
            }, 0, 200);
        }
    }

    @Override
    public void updatePlayingUI(int poker, int type, int lastUser) {

        int myTurnIndex = stateManager.playInfo.turnIndex;
        cardsView.checkCardsPlay();

        if(pokerManager.twoCardsPlay()) {
            topCardsView.checkCardsPlay();
        }

        int k = myTurnIndex;
        for (int i = 0; i < 4; ++i) {
            if (poker == 0) {
                tablePokers.get(i).setCard(-1);
            } else if (k == lastUser) {
                tablePokers.get(i).setCard(poker);
                break;
            }
            k = (k + 1) % 4;
        }

        if (lastUser != myTurnIndex && poker != 0) {
            if ((myTurnIndex + 1) % 4 == lastUser) {
                if(pokerManager.comIndex == (int)leftCardsView.getTag()) {
                    leftCardsView.setCardHidden(poker);
                }
                else {
                    leftCardsView.playingCard();
                }
            } else if ((myTurnIndex + 2) % 4 == lastUser) {
                if(!pokerManager.twoCardsPlay()) {
                    topCardsView.playingCard();
                }
            } else {
                if(pokerManager.comIndex == (int)rightCardsView.getTag()) {
                    rightCardsView.setCardHidden(poker);
                }
                else {
                    rightCardsView.playingCard();
                }
            }
        }

        updateTurnView(type);

        if (poker == 0) {
            cardsView.checkCardsPlay();
            topCardsView.checkCardsPlay();

            if (lastUser == myTurnIndex || lastUser == (myTurnIndex + 2) % 4) {
                pokerManager.enemyScroe += 1;
            } else {
                pokerManager.ourScroe += 1;
            }

            updateScoreView();

            if (stateManager.isGameOver) {
                stateManager.interruptConnect();
                finishView.setVisibility(VISIBLE);
                finishView.setInfo(pokerManager.ourScroe < pokerManager.winNumber);
            }
        }
    }
}