package com.talka.fancybridge.Views;

import android.app.Activity;
import android.content.Context;
import android.content.ContextWrapper;
import android.support.constraint.ConstraintLayout;
import android.text.SpannableString;
import android.text.style.RelativeSizeSpan;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.talka.fancybridge.Manager.PokerManager;
import com.talka.fancybridge.R;

public class AlertView extends ConstraintLayout {

    private Button bgButton;
    private TextView otherText;
    private TextView numberText;
    private ImageView flowerImage;
    private Button okButton;

    private boolean notDo = false;
    private int trump = -1;

    public static void showView(Context context,int trump) {
        AlertView alertView = new AlertView(context);
        alertView.setTrump(trump);
        alertView.addToSuperview();
    }

    public static void showViewSetText(Context context,String text) {
        AlertView alertView = new AlertView(context);
        alertView.notDo = true;
        alertView.setTextTrump(99,text);
        alertView.addToSuperview();
    }

    public AlertView(Context context) {
        super(context);
        init();
    }

    public AlertView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public AlertView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init();
    }

    public void init() {
        LayoutInflater inflate = (LayoutInflater) this.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View view = inflate.inflate(R.layout.alert_view, this, true);

        bgButton = (Button) findViewById(R.id.alertBG);
        otherText = (TextView) findViewById(R.id.alertOtherCallText);
        numberText = (TextView) findViewById(R.id.alertNumberText);
        flowerImage = (ImageView) findViewById(R.id.alertFlowerImage);
        okButton = (Button) findViewById(R.id.alertOk);

        bgButton.setOnClickListener( new OnClickListener() {
            @Override
            public void onClick(View view) {
                if(!notDo) {
                    removeFromSuperview();
                }
            }
        });

        okButton.setOnClickListener( new OnClickListener() {
            @Override
            public void onClick(View view) {
                if(!notDo) {
                    PokerManager.getInstance().callTrump(trump);
                }

                removeFromSuperview();
            }
        });
    }

    public void setTrump(int trump) {
        this.trump = trump;

        if( trump%7 >= 2 && trump%7 < 6) {
            setImageTrump(trump);
        }
        else {
            String trumpText = "";

            if(trump == 99) {
                trumpText = "-";
            }
            else if(trump == -1) {
                trumpText = "Pass";
            }
            else if(trump%7==0) {
                trumpText = "SM";
            }
            else if(trump%7==1) {
                trumpText = "MD";
            }
            else if(trump%7==6) {
                trumpText = "NT";
            }

            setTextTrump(trump,trumpText);
        }
    }

    public void setImageTrump(int trump) {

        int flowerIndex = trump%7-2;

        if(flowerIndex == 0) {
            flowerIndex=1;
        }
        else if(flowerIndex == 1) {
            flowerIndex=0;
        }

        numberText.setVisibility(View.VISIBLE);
        flowerImage.setVisibility(View.VISIBLE);

        numberText.setText(String.format("%d",trump/7+1));
        int resID = getContext().getResources().getIdentifier(PokerManager.Flowers[flowerIndex], "mipmap", getContext().getPackageName());
        flowerImage.setImageDrawable(getContext().getDrawable(resID));
    }

    public void setTextTrump(int number,String trump) {

        otherText.setTextSize(30);

        if(number == -1 || number == 99) {
            otherText.setTextSize(20);
            SpannableString ss=  new SpannableString(trump);
            ss.setSpan(new RelativeSizeSpan(1.2f), 0,trump.length(), 0); // set size
            otherText.setText(ss);
        }
        else {
            SpannableString ss=  new SpannableString(String.format("%d %s",number/7+1,trump));
            ss.setSpan(new RelativeSizeSpan(1.2f), 0,2, 0); // set size
            otherText.setText(ss);
        }

        otherText.setVisibility(View.VISIBLE);
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