package com.talka.fancybridge.Views.Components;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
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
import com.talka.fancybridge.Views.PlayCardView;

public class CardView extends ConstraintLayout implements PlayCardView.PlayCardViewListener {

    public static String[] Flowers = {"♦(D)","♣(C)","♥(H)","♠(S)"};
    public static String[] Numbers = {"A","2","3","4","5","6","7","8","9","10","J","Q","K"};

    private Button bgButton;
    private TextView numberText;
    private ImageView flowerImage;
    private ImageView bgImageView;
    private PlayCardView playCardView;

    private  int value = 0;

    public static String showPokerStr(int poker) {
        return String.format("%s-%s\n",Numbers[(poker-1)%13],Flowers[(poker-1)/13]);
    }

    public interface CardViewListener {
        void confirmPoker(int index);
    }

    PokerManager pokerManager;
    CardViewListener listener;

    public CardView(Context context) {
        super(context);
        init();
    }

    public CardView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public CardView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init();
    }

    public void init() {
        LayoutInflater inflate = (LayoutInflater) this.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View view = inflate.inflate(R.layout.card_view, this, true);
        pokerManager = PokerManager.getInstance();
        bgButton = (Button) findViewById(R.id.cardBgButton);
        numberText = (TextView) findViewById(R.id.cardNumberText);
        flowerImage = (ImageView) findViewById(R.id.cardFlowerNumer);
        bgImageView = (ImageView) findViewById(R.id.cardBgImageView);
        playCardView = new PlayCardView(getContext());
        playCardView.listener = this;

        bgButton.setOnClickListener( new OnClickListener() {
            @Override
            public void onClick(View view) {

                Boolean myTurn = pokerManager.turnIndex == StateManager.getInstance().playInfo.turnIndex;
                int poker = Integer.parseInt( myTurn ? pokerManager.cards[(int)getTag()] : pokerManager.otherCards[(int)getTag()] );

                playCardView.setCard(poker);
                playCardView.addToSuperview();
            }
        });
    }

    public void setCard(int card) {
        int resID;
        value = card;
        if (card == -1) {
            bgImageView.setImageResource(0);
            numberText.setText("");
            flowerImage.setImageResource(0);
        }
        else if(card==0) {
            resID = getResources().getIdentifier("card_back", "mipmap", getContext().getPackageName());
            bgImageView.setImageResource(resID);
            numberText.setText("");
            flowerImage.setImageResource(0);
        }
        else {
            int numberIndex = (card-1)%13;
            int flowerIndex = (card-1)/13;

            resID = getResources().getIdentifier("card_bg", "mipmap", getContext().getPackageName());
            bgImageView.setImageResource(resID);
            numberText.setText(PokerManager.Numbers[numberIndex]);
            numberText.setTextColor(PokerManager.Colors[flowerIndex%2]);
            resID = getResources().getIdentifier(PokerManager.Flowers[flowerIndex], "mipmap", getContext().getPackageName());
            flowerImage.setImageResource(resID);
        }
    }

    public void setEnable(Boolean flag) {
        if(flag) {
            bgButton.setVisibility(VISIBLE);
        }
        else {
            bgButton.setVisibility(INVISIBLE);
        }
    }

    public void setCanPlayShow(Boolean flag) {

        float alpha = flag ? 1.0f : 0.5f;

        numberText.setAlpha(alpha);
        flowerImage.setAlpha(alpha);

        setEnable(flag);
    }

    public void checkCardCanPlay(Boolean haveFlower,int cardsIndex) {

        if(haveFlower && (value-1)/13 != pokerManager.currentFlower) {
            setCanPlayShow(false);
        }
        else {
            setCanPlayShow(true);
        }
    }

    public void setSmallFont() {
        numberText.setTextSize(26);
    }


    @Override
    public void confirmPoker(int index) {
        value = 0;
        if(listener != null) {
            listener.confirmPoker((int)getTag());
        }
    }
}