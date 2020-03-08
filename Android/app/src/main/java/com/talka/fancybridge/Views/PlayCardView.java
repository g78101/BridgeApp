package com.talka.fancybridge.Views;

import android.app.Activity;
import android.content.Context;
import android.content.ContextWrapper;
import android.support.constraint.ConstraintLayout;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.talka.fancybridge.Manager.PokerManager;
import com.talka.fancybridge.R;

public class PlayCardView extends ConstraintLayout {

    private Button bgButton;
    private TextView numberText;
    private ImageView flowerImage;
    private Button playButton;

    public interface PlayCardViewListener {
        void confirmPoker(int index);
    }

    public PlayCardViewListener listener;

    public PlayCardView(Context context) {
        super(context);
        init();
    }

    public PlayCardView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public PlayCardView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init();
    }

    public void init() {
        LayoutInflater inflate = (LayoutInflater) this.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View view = inflate.inflate(R.layout.play_card_view, this, true);

        bgButton = (Button) findViewById(R.id.playCardBG);
        numberText = (TextView) findViewById(R.id.playCardNumberText);
        flowerImage = (ImageView) findViewById(R.id.playCardFlowerImage);
        playButton = (Button) findViewById(R.id.playCardPlay);

        bgButton.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View view) {
                removeFromSuperview();
            }
        });

        playButton.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View view) {
                if (listener != null) {
                    listener.confirmPoker((int)getTag());
                }
                removeFromSuperview();
            }
        });
    }

    public void setCard(int card) {
        int numberIndex = (card-1)%13;
        int flowerIndex = (card-1)/13;
        setTag(card);

        if(card==0) {
            numberText.setText("");
            flowerImage.setImageDrawable(null);
        }
        else {
            numberText.setText(PokerManager.Numbers[numberIndex]);
            numberText.setTextColor(PokerManager.Colors[flowerIndex%2]);

            int resID = getContext().getResources().getIdentifier(PokerManager.Flowers[flowerIndex], "mipmap", getContext().getPackageName());
            flowerImage.setImageDrawable(getContext().getDrawable(resID));
        }
    }

    public void addToSuperview() {
        Activity activity = getActivity(getContext());
        ViewGroup newParent = (ViewGroup)activity.getWindow().getDecorView().getRootView();

        newParent.addView(this,newParent.getWidth(),newParent.getHeight());
    }

    public void removeFromSuperview() {

        ViewGroup parentView = (ViewGroup) this.getParent();
        if (parentView != null) {
            parentView.removeView(this);
        }
    }

    public static Activity getActivity(Context context) {
        while (context instanceof ContextWrapper) {
            if (context instanceof Activity) {
                return (Activity) context;
            }
            context = ((ContextWrapper) context).getBaseContext();
        }
        return null;
    }
}
