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

    private List<CardsView> playerCardsView = new ArrayList<CardsView>();
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

        playerCardsView.add((CardsView) findViewById(R.id.playerCardsView0));
        playerCardsView.add((CardsView) findViewById(R.id.playerCardsView1));
        playerCardsView.add((CardsView) findViewById(R.id.playerCardsView2));
        playerCardsView.add((CardsView) findViewById(R.id.playerCardsView3));
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

        playerCardsView.get(1).otherPlayer();
        playerCardsView.get(3).otherPlayer();
        for(int i=1;i<4;++i) {
            playerCardsView.get(i).setSmallFont();
            playerCardsView.get(i).setEnable(false);
        }
        playerCardsView.get(0).setEnable(false);

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
            for(int i=0;i<4;++i) {
                playerCardsView.get(i).resetCard();
                playerCardsView.get(i).setTag((stateManager.playInfo.turnIndex+i)%4);
            }

            if(pokerManager.threeMode) {
                if(pokerManager.twoCardsPlay()) {
                    playerCardsView.get(2).setHandCards(pokerManager.otherCards);
                    playerCardsView.get(2).setScaleX(0.8f);
                    playerCardsView.get(2).setScaleY(0.8f);
                    playerCardsView.get(2).setRotation(0.f);
                    playerCardsView.get(2).checkCardsPlay();
                }
                else {
                    int findUIindex = findUIIndexFunc(pokerManager.comIndex);
                    playerCardsView.get(findUIindex).setHandCards(pokerManager.otherCards);
                    playerCardsView.get(2).otherPlayer();
                    playerCardsView.get(2).setScaleX(0.5f);
                    playerCardsView.get(2).setScaleY(0.5f);
                    playerCardsView.get(2).setRotation(180.f);
                }
            }
            else {
                for(int i=1;i<4;++i) {
                    playerCardsView.get(i).otherPlayer();
                    if(i==2) {
                        playerCardsView.get(2).setScaleX(0.5f);
                        playerCardsView.get(2).setScaleY(0.5f);
                        playerCardsView.get(2).setRotation(180.f);
                    }
                }
            }

            playerCardsView.get(0).setHandCards(pokerManager.cards);
            playerCardsView.get(0).checkCardsPlay();

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

    int findUIIndexFunc(int playIndex) {
        int myTurnIndex = stateManager.playInfo.turnIndex;
        int findUIindex = 0;
        for(int i=1;i<4;++i) {
            if((myTurnIndex+i)%4 == playIndex) {
                findUIindex = i;
                break;
            }
        }
        return findUIindex;
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
        playerCardsView.get(0).checkCardsPlay();

        if(pokerManager.twoCardsPlay()) {
            playerCardsView.get(2).checkCardsPlay();
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
            int findUIindex = findUIIndexFunc(lastUser);

            if(playerCardsView.get(findUIindex).otherPlayerFlag){
                playerCardsView.get(findUIindex).playingCard();
            }
            else {
                playerCardsView.get(findUIindex).setCardHidden(poker);
            }
        }

        updateTurnView(type);

        if (poker == 0) {
            playerCardsView.get(0).checkCardsPlay();
            playerCardsView.get(2).checkCardsPlay();

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

    @Override
    public void recoverPlayingUI() {
        int myTurnIndex = stateManager.playInfo.turnIndex;

        if(pokerManager.boutsWinRecord.size() != 0) {
            for(int i=0;i<pokerManager.boutsWinRecord.size();++i) {
                for(int j=0;j<4;++j) {
                    int index = (myTurnIndex+j)%4;
                    if(index != myTurnIndex) {
                        int findUIindex = findUIIndexFunc(index);
                        if(playerCardsView.get(findUIindex).otherPlayerFlag) {
                            playerCardsView.get(findUIindex).playingCard();
                        }
                    }
                }
            }
        }

        for(int i=0;i<4;++i) {
            int index =(myTurnIndex+i)%4;
            int poker = -1;
            if(pokerManager.playsRecord.get(index).size() == (pokerManager.boutsWinRecord.size()+1)) {
                poker = pokerManager.playsRecord.get(index).get(pokerManager.boutsWinRecord.size());

                int findUIindex = findUIIndexFunc(index);
                if(playerCardsView.get(findUIindex).otherPlayerFlag) {
                    playerCardsView.get(findUIindex).playingCard();
                }
            }
            tablePokers.get(i).setCard(poker);

            playerCardsView.get(i).recoverCard();
            if(i%2==0) {
                playerCardsView.get(i).checkCardsPlay();
            }
        }
    }
}