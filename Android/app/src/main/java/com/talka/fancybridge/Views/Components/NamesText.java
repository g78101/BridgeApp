package com.talka.fancybridge.Views.Components;

import android.content.Context;
import android.support.constraint.ConstraintLayout;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;

import com.talka.fancybridge.R;

import java.util.ArrayList;
import java.util.List;

public class NamesText extends ConstraintLayout {

    private List<TextView> nameTexts = new ArrayList<TextView>();

    public NamesText(Context context) {
        super(context);
        init();
    }

    public NamesText(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public NamesText(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init();
    }

    public void init() {
        LayoutInflater inflate = (LayoutInflater) this.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View view = inflate.inflate(R.layout.names_text, this, true);

        nameTexts.add((TextView) findViewById(R.id.nametext0));
        nameTexts.add((TextView) findViewById(R.id.nametext1));
        nameTexts.add((TextView) findViewById(R.id.nametext2));
        nameTexts.add((TextView) findViewById(R.id.nametext3));
    }

    public void setFontSize(float size) {
        for(TextView nameText : nameTexts) {
            nameText.setTextSize(size);
        }
    }

    public void setPlayersName(String[] players) {
        for(int i=0;i<4;++i) {
            nameTexts.get(i).setText(players[i]);
        }
    }
}