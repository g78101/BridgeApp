package com.talka.fancybridge.Adapter;

import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.talka.fancybridge.Manager.PokerManager;
import com.talka.fancybridge.R;
import com.talka.fancybridge.Views.Components.RecordView;

import java.util.ArrayList;
import java.util.List;

public class InfoCallView extends BaseAdapter {

    public static int[] Colors = {Color.parseColor("#FFE8F0"),Color.parseColor("#FFFFFF")};
    public boolean isDefaultSytle = true;
    private LayoutInflater mInflater;

    public InfoCallView(Context context) {
        mInflater = LayoutInflater.from(context);
    }

    @Override
    public int getCount() {
        int length = 5;//(isDefaultSytle ? 4 : 5);

        for(int i=0;i<4;++i) {
            int count = PokerManager.getInstance().callsRecord.get(i).size();
            if(count > length) {
                length = count;
            }
        }

        return length;
    }

    @Override
    public Object getItem(int i) {
        return "";
    }

    @Override
    public long getItemId(int i) {
        return 0;
    }

    @Override
    public View getView(int index, View view, ViewGroup viewGroup) {

        View v = view;
        InfoHolder holder;
        if (v == null) {
            v = mInflater.inflate(R.layout.info_holder, null);
            holder = new InfoHolder(v);
            v.setBackgroundColor(Color.WHITE);

            v.setTag(holder);
        } else {
            holder = (InfoHolder) v.getTag();
        }

        if(!isDefaultSytle) {
            v.setBackgroundColor(InfoCallView.Colors[index%2]);
//            v.setMinimumHeight(29 * 4);
//            v.requestLayout();
        }
        holder.reset();

        if(index < PokerManager.getInstance().findMaxCallCount()) {

            List<Integer> callValues = new ArrayList<Integer>();
            for (int i=0 ;i<4;++i) {
                int value = -2;
                if(index < PokerManager.getInstance().callsRecord.get(i).size()) {
                    value = PokerManager.getInstance().callsRecord.get(i).get(index);
                }
                if(i==3 && PokerManager.getInstance().threeMode){
                    value = 99;
                }
                callValues.add(value);
            }
            holder.setCallRecords(callValues);
        }

        return v;
    }
}
