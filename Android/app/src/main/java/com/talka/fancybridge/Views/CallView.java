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
import android.widget.TextView;

import com.talka.fancybridge.Manager.PokerManager;
import com.talka.fancybridge.Manager.StateManager;
import com.talka.fancybridge.R;

import java.util.ArrayList;
import java.util.List;

public class CallView extends ConstraintLayout implements PokerManager.PokerManagerListener, StateManager.StateManagerCallListener {

    private CardsView cardsView;
    public List<TextView> nameLabels = new ArrayList<TextView>();
    public List<TextView> callLabels = new ArrayList<TextView>();
    public List<ImageButton> callbuttons = new ArrayList<ImageButton>();
    public Button passBtn;

    public StateManager stateManager;
    public PokerManager pokerManager;

    public View.OnClickListener callBtnClickListener = new OnClickListener() {
        @Override
        public void onClick(View view) {
            if(pokerManager.turnIndex == stateManager.playInfo.turnIndex) {
                final int tag = (int)view.getTag();
                if(tag == -1) {
                    pokerManager.callTrump(tag);
                }
                else {
                    String message = String.format("You will call %d%s\n",tag/7+1,PokerManager.flowers[tag%7]);

                    AlertDialog.Builder alert = new AlertDialog.Builder(getContext());
                    alert.setTitle("");
                    alert.setMessage(message);
                    alert.setNegativeButton("Cancel", null);
                    alert.setPositiveButton("Confirm", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialogInterface, int i) {
                            pokerManager.callTrump(tag);
                        }
                    });
                    alert.show();
                }
            }
        }
    };

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
        passBtn = (Button)findViewById(R.id.passbutton);
        nameLabels.add((TextView)findViewById(R.id.nameLabel0));
        nameLabels.add((TextView)findViewById(R.id.nameLabel1));
        nameLabels.add((TextView)findViewById(R.id.nameLabel2));
        nameLabels.add((TextView)findViewById(R.id.nameLabel3));
        callLabels.add((TextView)findViewById(R.id.callLabel0));
        callLabels.add((TextView)findViewById(R.id.callLabel1));
        callLabels.add((TextView)findViewById(R.id.callLabel2));
        callLabels.add((TextView)findViewById(R.id.callLabel3));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton0));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton1));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton2));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton3));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton4));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton5));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton6));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton7));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton8));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton9));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton10));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton11));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton12));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton13));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton14));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton15));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton16));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton17));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton18));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton19));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton20));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton21));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton22));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton23));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton24));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton25));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton26));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton27));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton28));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton29));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton30));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton31));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton32));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton33));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton34));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton35));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton36));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton37));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton38));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton39));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton40));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton41));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton42));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton43));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton44));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton45));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton46));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton47));
        callbuttons.add((ImageButton)findViewById(R.id.callbutton48));

        for(int i=0;i< callbuttons.size();++i) {
            callbuttons.get(i).setTag(i);
            callbuttons.get(i).setOnClickListener(callBtnClickListener);
        }

        passBtn.setTag(-1);
        passBtn.setOnClickListener(callBtnClickListener);

        stateManager = StateManager.getInstance();
        pokerManager = PokerManager.getInstance();

        cardsView.setEnable(false);
        pokerManager.listener = this;
        stateManager.callListener = this;

        for(int i=0;i<2+1;++i) {
            setBtnEnable(callbuttons.get(i),false);
        }
    }

    @Override
    public void setVisibility(int visibility) {
        super.setVisibility(visibility);

        if (visibility == View.VISIBLE) {

            for(int i=0;i<4;++i) {
                nameLabels.get(i).setText(stateManager.players[i]);
                callLabels.get(i).setText("");
            }

            for(ImageButton imageButton : callbuttons) {
                setBtnEnable(imageButton,true);
            }

            pokerManager.listener = this;

            if(stateManager.playInfo.turnIndex == pokerManager.turnIndex) {
                AlertDialog.Builder alert = new AlertDialog.Builder(getContext());
                alert.setTitle("");
                alert.setMessage("You call first");
                alert.setNegativeButton("OK", null);
                alert.show();
            }
        }
    }

    public void setBtnEnable(ImageButton btn,boolean isEnable) {
        if (isEnable) {
//            btn.setImageAlpha(255);
//            btn.setEnabled(true);
            btn.setVisibility(VISIBLE);
        }
        else {
//            btn.setImageAlpha(50);
//            btn.setEnabled(false);
            btn.setVisibility(INVISIBLE);
        }
    }

    @Override
    public void setCardsForUI(String[] cardArray) {
        cardsView.setHandCards(cardArray);
    }

    @Override
    public void updateCallingUI(int index) {

        for(int i=0;i<index+1;++i) {
            setBtnEnable(callbuttons.get(i),false);
        }

        for(int i=0;i<4;++i) {
            callLabels.get(i).setText(pokerManager.callsRecord[i]);
        }

        if(stateManager.playInfo.turnIndex == pokerManager.turnIndex) {

            AlertDialog.Builder alert = new AlertDialog.Builder(getContext());
            alert.setTitle("");
            alert.setMessage("Your Turn");
            alert.setNegativeButton("OK", null);
            alert.show();
        }
    }
}