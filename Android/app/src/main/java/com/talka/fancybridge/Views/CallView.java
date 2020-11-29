package com.talka.fancybridge.Views;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.support.constraint.ConstraintLayout;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.TextView;

import com.talka.fancybridge.Adapter.InfoCallView;
import com.talka.fancybridge.Manager.PokerManager;
import com.talka.fancybridge.Manager.StateManager;
import com.talka.fancybridge.R;
import com.talka.fancybridge.Views.Components.CardsView;
import com.talka.fancybridge.Views.Components.NamesText;
import com.talka.fancybridge.Views.Components.CallButtonsView;
import com.talka.fancybridge.Views.Components.SelectPartnerView;

import java.util.ArrayList;
import java.util.List;

public class CallView extends ConstraintLayout implements PokerManager.PokerManagerListener, StateManager.StateManagerCallListener, CallButtonsView.CallButtonsListener {

    private CardsView cardsView;
    public NamesText nameLabels;
    public ListView calllist;
    public CallButtonsView callButtonsView;
    public SelectPartnerView selectPartnerView;

    private InfoCallView callListAdapter;

    public StateManager stateManager;
    public PokerManager pokerManager;
    public boolean isClicked = false;

    public CallView(Context context) {
        super(context);
        init(context);
    }

    public CallView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }

    public CallView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init(context);
    }

    private void init(Context context) {
        LayoutInflater inflate = (LayoutInflater) this.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View view = inflate.inflate(R.layout.call_view, this, true);

        cardsView = (CardsView)findViewById(R.id.cards);
        nameLabels = (NamesText) findViewById(R.id.namesLabel);
        calllist = (ListView) findViewById(R.id.callList);
        callButtonsView = (CallButtonsView) findViewById(R.id.callButtons);
        selectPartnerView = (SelectPartnerView) findViewById(R.id.selectPartner);

        nameLabels.setBackgroundResource(R.color.colorBGAlpha);

        callListAdapter = new InfoCallView(context);
        calllist.setAdapter(callListAdapter);

        callButtonsView.listener = this;

        stateManager = StateManager.getInstance();
        pokerManager = PokerManager.getInstance();

        cardsView.setEnable(false);
        pokerManager.listener = this;
        stateManager.callListener = this;

    }

    @Override
    public void setVisibility(int visibility) {
        super.setVisibility(visibility);
        selectPartnerView.setVisibility(INVISIBLE);
        callButtonsView.setVisibility(VISIBLE);

        if (visibility == View.VISIBLE) {

            nameLabels.setPlayersName(stateManager.players);
            callListAdapter.notifyDataSetChanged();
            isClicked = false;

            callButtonsView.reset();

            pokerManager.listener = this;

            if(pokerManager.turnIndex == stateManager.playInfo.turnIndex) {
                callButtonsView.setAlpha(1.0f);
            }
            else {
                callButtonsView.setAlpha(0.5f);
            }

            if(stateManager.playInfo.turnIndex == pokerManager.turnIndex) {
                AlertView.showViewSetText(getContext(),"You call first");
            }
        }
    }

    @Override
    public void buttonsClicker(int index) {

        if(pokerManager.turnIndex == stateManager.playInfo.turnIndex) {
            final int tag = index;
            if(index == -1) {
                pokerManager.callTrump(tag);
            }
            else {
                AlertView.showView(getContext(),tag);
            }
        }
    }

    @Override
    public void setCardsForUI(String[] cardArray) {
        cardsView.setHandCards(cardArray);
    }

    @Override
    public void updateCallingUI(int index) {

        callButtonsView.disableFrom(index+1);
        isClicked = false;
        callListAdapter.notifyDataSetChanged();

        if(stateManager.playInfo.turnIndex == pokerManager.turnIndex) {
            callButtonsView.setAlpha(1.0f);
        }
        else {
            callButtonsView.setAlpha(0.5f);
        }
    }
    @Override
    public void showThreeModeUI(int index) {
        if(index == stateManager.playInfo.turnIndex) {
            selectPartnerView.setVisibility(VISIBLE);
            callButtonsView.setVisibility(INVISIBLE);
        }
        else {
            callButtonsView.setAlpha(0.5f);
            LoadingView.start(getContext());
        }
    }
}