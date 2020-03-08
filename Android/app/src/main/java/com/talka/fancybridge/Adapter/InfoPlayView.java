package com.talka.fancybridge.Adapter;

import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;

import com.talka.fancybridge.Manager.PokerManager;
import com.talka.fancybridge.R;

import java.util.ArrayList;
import java.util.List;

public class InfoPlayView extends BaseAdapter {

    public static int[] Colors = {Color.parseColor("#3300C888"),Color.parseColor("#FFFFFF")};
    private LayoutInflater mInflater;

    public InfoPlayView(Context context) {
        mInflater = LayoutInflater.from(context);
    }

    @Override
    public int getCount() {
        return 13;
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

            v.setTag(holder);
        } else {
            holder = (InfoHolder) v.getTag();
        }

        v.setBackgroundColor(InfoPlayView.Colors[index%2]);
        holder.clearRecordsBG();
        holder.reset();

        if(index < PokerManager.getInstance().findMaxPlayCount()) {

            List<Integer> playValues = new ArrayList<Integer>();
            for(int i=0;i<4;++i) {
                int value = -1;
                if(index < PokerManager.getInstance().playsRecord.get(i).size()) {
                    value = PokerManager.getInstance().playsRecord.get(i).get(index);
                }
                playValues.add(value);
            }
            holder.setPlayRecords(playValues);

            if(index < PokerManager.getInstance().boutsWinRecord.size()) {
                holder.setWinRecord(PokerManager.getInstance().boutsWinRecord.get(index));
            }
        }

        return v;
    }
}
