package com.talka.fancybridge.Views.Components;

import android.content.Context;
import android.support.constraint.ConstraintLayout;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;

import com.talka.fancybridge.Manager.StateManager;
import com.talka.fancybridge.R;
import com.talka.fancybridge.Views.AlertView;
import com.talka.fancybridge.Views.LoadingView;

import java.util.ArrayList;
import java.util.List;

public class SelectPartnerView extends ConstraintLayout {

    private List<Button> chooseButtons = new ArrayList<Button>();
    private Button okButton;
    private int selectIndex = -1;
    private int[] indexTable = {0,0,0};

    private View.OnClickListener selectedPlayer = new OnClickListener() {
        @Override
        public void onClick(View view) {
            for(Button button : chooseButtons) {
                button.setAlpha(1.0f);
            }

            view.setAlpha(0.25f);
            selectIndex = (int)view.getTag();
        }
    };

    public SelectPartnerView(Context context) {
        super(context);
        init();
    }

    public SelectPartnerView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public SelectPartnerView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init();
    }

    public void init() {
        LayoutInflater inflate = (LayoutInflater) this.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View view = inflate.inflate(R.layout.select_partner_view, this, true);

        chooseButtons.add((Button) findViewById(R.id.chooseButton0));
        chooseButtons.add((Button) findViewById(R.id.chooseButton1));
        chooseButtons.add((Button) findViewById(R.id.chooseButton2));

        for (int i=0;i<3;++i) {
            Button button = chooseButtons.get(i);

            button.setTag(i);
            button.setOnClickListener(selectedPlayer);
        }

        okButton = (Button) findViewById(R.id.chooseOK);
        okButton.setOnClickListener( new OnClickListener() {
            @Override
            public void onClick(View view) {
                if (selectIndex == -1) {
                    AlertView.showViewSetText(getContext(), "Please choose one");
                } else {
                    StateManager.getInstance().choosedPartner(indexTable[selectIndex]);
                }
            }
        });
    }

    @Override
    public void setVisibility(int visibility) {
        super.setVisibility(visibility);

        if (visibility == View.VISIBLE) {

            int buttonIndex = 0;
            indexTable = new int[]{0,0,0};

            for(int i=0;i<4;++i) {

                if(i == StateManager.getInstance().playInfo.turnIndex) {
                    continue;
                }

                indexTable[buttonIndex]=i;
                chooseButtons.get(buttonIndex).setText(StateManager.getInstance().players[i]);
                buttonIndex++;
            }
        }
    }
}