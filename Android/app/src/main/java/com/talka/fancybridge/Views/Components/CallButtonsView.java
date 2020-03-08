package com.talka.fancybridge.Views.Components;

import android.content.Context;
import android.support.constraint.ConstraintLayout;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;

import com.talka.fancybridge.R;

import java.util.ArrayList;
import java.util.List;

public class CallButtonsView extends ConstraintLayout implements CallButton.CallButtonListener {

    private List<CallButton> callButtons = new ArrayList<CallButton>();
    private Button passButton;

    public interface CallButtonsListener {
        void buttonsClicker(int index);
    }

    public CallButtonsListener listener;

    public CallButtonsView(Context context) {
        super(context);
        init();
    }

    public CallButtonsView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public CallButtonsView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init();
    }

    public void init() {
        LayoutInflater inflate = (LayoutInflater) this.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View view = inflate.inflate(R.layout.call_buttons_view, this, true);

        callButtons.add((CallButton) findViewById(R.id.callbutton0));
        callButtons.add((CallButton) findViewById(R.id.callbutton1));
        callButtons.add((CallButton) findViewById(R.id.callbutton2));
        callButtons.add((CallButton) findViewById(R.id.callbutton3));
        callButtons.add((CallButton) findViewById(R.id.callbutton4));
        callButtons.add((CallButton) findViewById(R.id.callbutton5));
        callButtons.add((CallButton) findViewById(R.id.callbutton6));
        callButtons.add((CallButton) findViewById(R.id.callbutton7));
        callButtons.add((CallButton) findViewById(R.id.callbutton8));
        callButtons.add((CallButton) findViewById(R.id.callbutton9));
        callButtons.add((CallButton) findViewById(R.id.callbutton10));
        callButtons.add((CallButton) findViewById(R.id.callbutton11));
        callButtons.add((CallButton) findViewById(R.id.callbutton12));
        callButtons.add((CallButton) findViewById(R.id.callbutton13));
        callButtons.add((CallButton) findViewById(R.id.callbutton14));
        callButtons.add((CallButton) findViewById(R.id.callbutton15));
        callButtons.add((CallButton) findViewById(R.id.callbutton16));
        callButtons.add((CallButton) findViewById(R.id.callbutton17));
        callButtons.add((CallButton) findViewById(R.id.callbutton18));
        callButtons.add((CallButton) findViewById(R.id.callbutton19));
        callButtons.add((CallButton) findViewById(R.id.callbutton20));
        callButtons.add((CallButton) findViewById(R.id.callbutton21));
        callButtons.add((CallButton) findViewById(R.id.callbutton22));
        callButtons.add((CallButton) findViewById(R.id.callbutton23));
        callButtons.add((CallButton) findViewById(R.id.callbutton24));
        callButtons.add((CallButton) findViewById(R.id.callbutton25));
        callButtons.add((CallButton) findViewById(R.id.callbutton26));
        callButtons.add((CallButton) findViewById(R.id.callbutton27));
        callButtons.add((CallButton) findViewById(R.id.callbutton28));
        callButtons.add((CallButton) findViewById(R.id.callbutton29));
        callButtons.add((CallButton) findViewById(R.id.callbutton30));
        callButtons.add((CallButton) findViewById(R.id.callbutton31));
        callButtons.add((CallButton) findViewById(R.id.callbutton32));
        callButtons.add((CallButton) findViewById(R.id.callbutton33));
        callButtons.add((CallButton) findViewById(R.id.callbutton34));
        callButtons.add((CallButton) findViewById(R.id.callbutton35));
        callButtons.add((CallButton) findViewById(R.id.callbutton36));
        callButtons.add((CallButton) findViewById(R.id.callbutton37));
        callButtons.add((CallButton) findViewById(R.id.callbutton38));
        callButtons.add((CallButton) findViewById(R.id.callbutton39));
        callButtons.add((CallButton) findViewById(R.id.callbutton40));
        callButtons.add((CallButton) findViewById(R.id.callbutton41));
        callButtons.add((CallButton) findViewById(R.id.callbutton42));
        callButtons.add((CallButton) findViewById(R.id.callbutton43));
        callButtons.add((CallButton) findViewById(R.id.callbutton44));
        callButtons.add((CallButton) findViewById(R.id.callbutton45));
        callButtons.add((CallButton) findViewById(R.id.callbutton46));
        callButtons.add((CallButton) findViewById(R.id.callbutton47));
        callButtons.add((CallButton) findViewById(R.id.callbutton48));
        passButton = (Button) findViewById(R.id.callPassButton);
        passButton.setTag(-1);

        for(int i=0;i<49;++i) {
            CallButton callBtn = callButtons.get(i);

            callBtn.setTrumpUI(i);
            callBtn.setTag(i);
            callBtn.listener = this;
        }

        passButton.setOnClickListener( new OnClickListener() {
            @Override
            public void onClick(View view) {
                if (listener != null) {
                    listener.buttonsClicker((int)view.getTag());
                }
            }
        });
    }

    public void reset() {
        for(CallButton callButton : callButtons) {
            callButton.setEnable(true);
        }
    }

    public void disableFrom(int index) {
        for(int i=0;i<index;++i) {
            callButtons.get(i).setEnable(false);
        }
    }

    @Override
    public void buttonClicker(int index) {
        if (listener != null) {
            listener.buttonsClicker(index);
        }
    }
}
