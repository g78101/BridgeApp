package com.talka.fancybridge.Views.Components;

import android.content.Context;
import android.support.constraint.ConstraintLayout;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.talka.fancybridge.Manager.PokerManager;
import com.talka.fancybridge.Manager.StateManager;
import com.talka.fancybridge.R;

public class FinishView extends ConstraintLayout {

    TextView text;
    ImageView image;
    Button button;

    public FinishView(Context context) {
        super(context);
        init();
    }

    public FinishView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public FinishView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init();
    }

    public void init() {
        LayoutInflater inflate = (LayoutInflater) this.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View view = inflate.inflate(R.layout.finish_view, this, true);

        text = (TextView) findViewById(R.id.finishText);
        image = (ImageView) findViewById(R.id.finishImage);
        button = (Button) findViewById(R.id.finishBtn);

        button.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View view) {
                setVisibility(INVISIBLE);
                image.clearAnimation();
                PokerManager.getInstance().reset();
                StateManager.getInstance().reset();
                StateManager.getInstance().connectServer();
            }
        });
    }

    public void setInfo(Boolean lose) {
        text.setText(lose ? "You Lose..." : "You Win!");

        int resID = getContext().getResources().getIdentifier(lose ? "ying_cry" : "ying_happy", "mipmap", getContext().getPackageName());
        image.setImageDrawable(getContext().getDrawable(resID));

        Animation finishAnim = AnimationUtils.loadAnimation(getContext(), R.anim.finishanim);
        image.startAnimation(finishAnim);
    }
}