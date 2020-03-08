package com.talka.fancybridge.Views;

import android.content.Context;
import android.support.constraint.ConstraintLayout;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.talka.fancybridge.Adapter.InfoCallView;
import com.talka.fancybridge.Adapter.InfoPlayView;
import com.talka.fancybridge.Manager.PokerManager;
import com.talka.fancybridge.Manager.StateManager;
import com.talka.fancybridge.R;
import com.talka.fancybridge.Views.Components.CardView;
import com.talka.fancybridge.Views.Components.FlowerCount;
import com.talka.fancybridge.Views.Components.NamesText;

import java.util.ArrayList;
import java.util.List;

public class InfoView extends ConstraintLayout {

    public NamesText infoName;
    public ListView infoCall;
    public NamesText infoNameThree;
    public ListView infoPlay;
    public List<FlowerCount> flowerCounts = new ArrayList<FlowerCount>();

    private InfoCallView callListAdapter;
    private InfoPlayView playListAdapter;

    public InfoView(Context context) {
        super(context);
        LayoutInflater inflate = (LayoutInflater) this.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View view = inflate.inflate(R.layout.info_view, this, true);

        infoName = (NamesText) findViewById(R.id.infoName);
        infoCall = (ListView) findViewById(R.id.infoCall);
        infoNameThree = (NamesText) findViewById(R.id.infoNameThree);
        infoPlay = (ListView) findViewById(R.id.infoPlay);
        flowerCounts.add((FlowerCount) findViewById(R.id.infoFlower0));
        flowerCounts.add((FlowerCount) findViewById(R.id.infoFlower1));
        flowerCounts.add((FlowerCount) findViewById(R.id.infoFlower2));
        flowerCounts.add((FlowerCount) findViewById(R.id.infoFlower3));

        callListAdapter = new InfoCallView(context);
        infoCall.setAdapter(callListAdapter);
        callListAdapter.isDefaultSytle = false;
        infoCall.setDividerHeight(0);

        playListAdapter = new InfoPlayView(context);
        infoPlay.setAdapter(playListAdapter);
        infoPlay.setDividerHeight(0);

        this.setOnClickListener(mCloseOnClickListener);

        infoName.setBackgroundResource(R.color.colorRedBG);
        infoName.setPlayersName(StateManager.getInstance().players);

        infoNameThree.setBackgroundResource(R.color.colorGreenBG);
        infoNameThree.setPlayersName(StateManager.getInstance().players);

        if(PokerManager.getInstance().threeMode) {
            infoNameThree.setPlayersName(StateManager.getInstance().threeModePlayers);
        }
        else {
            infoNameThree.getLayoutParams().height = 5;
        }

        for(int i=0;i<4;++i) {
            flowerCounts.get(i).setValue(PokerManager.Flowers[i],PokerManager.getInstance().flowerCountRecord[i]);
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
