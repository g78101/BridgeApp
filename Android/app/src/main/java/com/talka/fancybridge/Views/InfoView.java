package com.talka.fancybridge.Views;

import android.content.Context;
import android.support.constraint.ConstraintLayout;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.TextView;

import com.talka.fancybridge.Manager.PokerManager;
import com.talka.fancybridge.Manager.StateManager;
import com.talka.fancybridge.R;

import java.util.ArrayList;
import java.util.List;

public class InfoView extends ConstraintLayout {

    private ImageButton closeButton;
    public List<TextView> nameLabels = new ArrayList<TextView>();
    public List<TextView> callLabels = new ArrayList<TextView>();
    public List<TextView> playLabels = new ArrayList<TextView>();
    public List<TextView> flowerLabels = new ArrayList<TextView>();

    public InfoView(Context context) {
        super(context);
        LayoutInflater inflate = (LayoutInflater) this.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View view = inflate.inflate(R.layout.info_view, this, true);

        closeButton = (ImageButton) findViewById(R.id.closeButton);
        nameLabels.add((TextView)findViewById(R.id.infoLabel0));
        nameLabels.add((TextView)findViewById(R.id.infoLabel1));
        nameLabels.add((TextView)findViewById(R.id.infoLabel2));
        nameLabels.add((TextView)findViewById(R.id.infoLabel3));
        callLabels.add((TextView)findViewById(R.id.infoCall0));
        callLabels.add((TextView)findViewById(R.id.infoCall1));
        callLabels.add((TextView)findViewById(R.id.infoCall2));
        callLabels.add((TextView)findViewById(R.id.infoCall3));
        playLabels.add((TextView)findViewById(R.id.infoPlay0));
        playLabels.add((TextView)findViewById(R.id.infoPlay1));
        playLabels.add((TextView)findViewById(R.id.infoPlay2));
        playLabels.add((TextView)findViewById(R.id.infoPlay3));
        flowerLabels.add((TextView)findViewById(R.id.flowerLabel0));
        flowerLabels.add((TextView)findViewById(R.id.flowerLabel1));
        flowerLabels.add((TextView)findViewById(R.id.flowerLabel2));
        flowerLabels.add((TextView)findViewById(R.id.flowerLabel3));

        this.setOnClickListener(mCloseOnClickListener);
        closeButton.setOnClickListener(mCloseOnClickListener);

        for(int i=0;i<4;++i) {
            nameLabels.get(i).setText(StateManager.getInstance().players[i]);
            callLabels.get(i).setText(PokerManager.getInstance().callsRecord[i]);
            playLabels.get(i).setText(PokerManager.getInstance().playsRecord[i]);
            flowerLabels.get(i).setText(String.format("%s:%d",CardView.Flowers[i],PokerManager.getInstance().flowerCountRecord[i]));
        }
    }

    private void close() {
        ViewGroup parentView = (ViewGroup) getParent();
        if(parentView != null) {
            parentView.removeView(this);
        }
    }

    private View.OnClickListener mCloseOnClickListener = new View.OnClickListener() {
        @Override
        public void onClick(View view) {
            close();
        }
    };
}
