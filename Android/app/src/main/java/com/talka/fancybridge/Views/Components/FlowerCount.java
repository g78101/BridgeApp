package com.talka.fancybridge.Views.Components;

import android.content.Context;
import android.support.constraint.ConstraintLayout;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.talka.fancybridge.R;

public class FlowerCount extends ConstraintLayout {

    ImageView flower;
    TextView number;

    public FlowerCount(Context context) {
        super(context);
        init();
    }

    public FlowerCount(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public FlowerCount(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init();
    }

    public void init() {
        LayoutInflater inflate = (LayoutInflater) this.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View view = inflate.inflate(R.layout.flower_count, this, true);

        flower = (ImageView) findViewById(R.id.flowercountImage);
        number = (TextView) findViewById(R.id.flowercountText);
    }

    public void setValue(String imageName,int number) {

        int resID = getContext().getResources().getIdentifier(imageName, "mipmap", getContext().getPackageName());
        flower.setImageDrawable(getContext().getDrawable(resID));
        this.number.setText(String.format("X %d",number));
    }
}
