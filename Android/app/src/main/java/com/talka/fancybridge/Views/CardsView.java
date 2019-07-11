package com.talka.fancybridge.Views;

import android.content.Context;
import android.support.constraint.ConstraintLayout;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;

import com.talka.fancybridge.Manager.PokerManager;
import com.talka.fancybridge.Manager.StateManager;
import com.talka.fancybridge.R;

import java.util.ArrayList;
import java.util.List;

public class CardsView extends ConstraintLayout implements CardView.CardViewListener {

    public List<CardView> cards = new ArrayList<CardView>();

    public CardsView(Context context) {
        super(context);
        init(context);
    }

    public CardsView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }

    public CardsView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init(context);
    }

    private void init(Context context) {
        LayoutInflater inflate = (LayoutInflater) this.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View view = inflate.inflate(R.layout.cards_view, this, true);
        CardView test = (CardView) findViewById(R.id.cardview0);
        cards.add((CardView) findViewById(R.id.cardview0));
        cards.add((CardView) findViewById(R.id.cardview1));
        cards.add((CardView) findViewById(R.id.cardview2));
        cards.add((CardView) findViewById(R.id.cardview3));
        cards.add((CardView) findViewById(R.id.cardview4));
        cards.add((CardView) findViewById(R.id.cardview5));
        cards.add((CardView) findViewById(R.id.cardview6));
        cards.add((CardView) findViewById(R.id.cardview7));
        cards.add((CardView) findViewById(R.id.cardview8));
        cards.add((CardView) findViewById(R.id.cardview9));
        cards.add((CardView) findViewById(R.id.cardview10));
        cards.add((CardView) findViewById(R.id.cardview11));
        cards.add((CardView) findViewById(R.id.cardview12));

        for(CardView cardView : cards) {
            cardView.listener = this;
        }
    }

    public void setHandCards(String[] cardsText) {
        for(int i=0;i< PokerManager.HandCardsCount;++i) {
            cards.get(i).setTag(i);
            cards.get(i).setCard(Integer.parseInt(cardsText[i]));
        }
    }

    public void setEnable(Boolean isEnable) {
        for(CardView card : cards) {
            card.setEnabled(isEnable);
        }
    }

    public void resetCard() {
        for(CardView card : cards) {
            card.setVisibility(View.VISIBLE);
            card.resetPosition();
        }
    }

    public void playingCard() {
        for(int i=PokerManager.HandCardsCount-1;i>=0 ;--i) {
            if (cards.get(i).getVisibility() == VISIBLE) {
                cards.get(i).setVisibility(INVISIBLE);
                break;
            }
        }
    }

    public void otherPlayer() {
        String [] otherCards = {"0","0","0","0","0","0","0","0","0","0","0","0","0"};
        setHandCards(otherCards);
        setEnable(false);
    }

    @Override
    public void confirmPoker(int index) {
        if(PokerManager.getInstance().turnIndex == StateManager.getInstance().playInfo.turnIndex) {
            PokerManager.getInstance().playPoker(index);
            cards.get(index).setVisibility(View.INVISIBLE);
            setEnable(false);
        }
    }
}