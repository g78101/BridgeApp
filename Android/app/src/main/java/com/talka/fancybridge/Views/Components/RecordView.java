package com.talka.fancybridge.Views.Components;

import android.content.Context;
import android.graphics.Color;
import android.support.constraint.ConstraintLayout;
import android.text.SpannableString;
import android.text.style.RelativeSizeSpan;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.talka.fancybridge.Manager.PokerManager;
import com.talka.fancybridge.R;

public class RecordView extends ConstraintLayout {

    private TextView numberText;
    private TextView  otherCallText;
    private ImageView flowerImage;

    public RecordView(Context context) {
        super(context);
        init();
    }

    public RecordView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public RecordView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init();
    }

    public void init() {
        LayoutInflater inflate = (LayoutInflater) this.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View view = inflate.inflate(R.layout.record_view, this, true);

        numberText = (TextView)findViewById(R.id.numberText);
        otherCallText = (TextView)findViewById(R.id.otherCallText);
        flowerImage = (ImageView)findViewById(R.id.flowerImage);
    }

    public void setWhiteColor() {
        numberText.setTextColor(Color.WHITE);
        otherCallText.setTextColor(Color.WHITE);
    }

    public void reset() {
        numberText.setVisibility(View.INVISIBLE);
        otherCallText.setVisibility(View.INVISIBLE);
        flowerImage.setVisibility(View.INVISIBLE);
    }

    public void setTrump(int trump) {

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

        if(number == -1 || number == 99) {
            SpannableString ss=  new SpannableString(trump);
            ss.setSpan(new RelativeSizeSpan(1.2f), 0,trump.length(), 0); // set size
            otherCallText.setText(ss);
        }
        else {
            SpannableString ss=  new SpannableString(String.format("%d %s",number/7+1,trump));
            ss.setSpan(new RelativeSizeSpan(1.2f), 0,2, 0); // set size
            otherCallText.setText(ss);
        }

        otherCallText.setVisibility(View.VISIBLE);
    }

    public void setRecord(int card) {

        int numberIndex = (card-1)%13;
        int flowerIndex = (card-1)/13;

        numberText.setText(PokerManager.Numbers[numberIndex]);

        int resID = getContext().getResources().getIdentifier(PokerManager.Flowers[flowerIndex], "mipmap", getContext().getPackageName());
        flowerImage.setImageDrawable(getContext().getDrawable(resID));

        numberText.setVisibility(View.VISIBLE);
        flowerImage.setVisibility(View.VISIBLE);
    }
}