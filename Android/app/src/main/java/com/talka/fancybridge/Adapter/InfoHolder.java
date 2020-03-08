package com.talka.fancybridge.Adapter;

import android.view.View;

import com.talka.fancybridge.R;
import com.talka.fancybridge.Views.Components.RecordView;

import java.util.ArrayList;
import java.util.List;

public class InfoHolder {
    public List<RecordView> recordViews = new ArrayList<RecordView>();

    public InfoHolder(View view) {

        recordViews.add((RecordView)view.findViewById(R.id.infoholder0));
        recordViews.add((RecordView)view.findViewById(R.id.infoholder1));
        recordViews.add((RecordView)view.findViewById(R.id.infoholder2));
        recordViews.add((RecordView)view.findViewById(R.id.infoholder3));
    }

    public void reset() {
        for(RecordView recordView : recordViews) {
            recordView.reset();
        }
    }

    public void clearRecordsBG() {
        for(RecordView recordView : recordViews) {
            recordView.setBackground(null);
        }
    }

    public void setWinRecord(int index) {
        recordViews.get(index).setBackgroundResource(R.color.colorBGAlpha);
    }

    public void setCallRecords(List<Integer> callValues) {

        for(int i=0;i<4;++i) {
            int trump = callValues.get(i);
            if (trump == -2) {
                continue;
            }
            recordViews.get(i).setTrump(trump);
        }
    }

    public void setPlayRecords(List<Integer> playValues) {
        for(int i=0;i<4;++i) {
            int card = playValues.get(i);
            if (card == -1) {
                continue;
            }
            recordViews.get(i).setRecord(card);
        }
    }
}
