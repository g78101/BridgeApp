package com.talka.fancybridge.Views.Components;

import android.content.Context;
import android.graphics.Color;
import android.graphics.PorterDuff;
import android.support.constraint.ConstraintLayout;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;

import com.talka.fancybridge.R;

public class CallButton extends ConstraintLayout {

    private Button bgButton;
    private RecordView recordView;

    public interface CallButtonListener {
        void buttonClicker(int index);
    }

    CallButtonListener listener;

    public CallButton(Context context) {
        super(context);
        init();
    }

    public CallButton(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public CallButton(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init();
    }

    public void init() {
        LayoutInflater inflate = (LayoutInflater) this.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View view = inflate.inflate(R.layout.call_button, this, true);

        bgButton = (Button) findViewById(R.id.btnCallBG);
        recordView = (RecordView) findViewById(R.id.btnRecord);
        recordView.setWhiteColor();

        bgButton.setOnClickListener( new OnClickListener() {
            @Override
            public void onClick(View view) {
                if (listener != null) {
                    listener.buttonClicker((int)getTag());
                }
            }
        });
    }
    public void setEnable(boolean isEnable) {
        if (isEnable) {
            this.setAlpha(1);
            bgButton.setEnabled(true);
        }
        else {
            this.setAlpha(0.5f);
            bgButton.setEnabled(false);
        }
    }

    public void setTrumpUI(int trump) {
        recordView.setTrump(trump);
    }
}