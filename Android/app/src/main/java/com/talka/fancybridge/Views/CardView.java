package com.talka.fancybridge.Views;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.util.AttributeSet;
import android.view.View;
import android.widget.ImageButton;

import com.talka.fancybridge.Manager.PokerManager;

public class CardView extends ImageButton {

    static String[] Flowers = {"♦(D)","♣(C)","♥(H)","♠(S)"};
    static String[] Numbers = {"A","2","3","4","5","6","7","8","9","10","J","Q","K"};

    public static String showPokerStr(int poker) {
        return String.format("%s-%s\n",Numbers[(poker-1)%13],Flowers[(poker-1)/13]);
    }

    public interface CardViewListener {
        void confirmPoker(int index);
    }

    PokerManager pokerManager;
    CardViewListener listener;

    public CardView(Context context) {
        super(context);
        init();
    }

    public CardView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public CardView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init();
    }

    public void init() {
        pokerManager = PokerManager.getInstance();

        setOnClickListener( new OnClickListener() {
            @Override
            public void onClick(View view) {

                AlertDialog.Builder alert = new AlertDialog.Builder(getContext());
                int currentPoker = Integer.parseInt(pokerManager.cards[(int)getTag()]);
                Boolean haveFlower = false;

                if(pokerManager.currentFlower != -1) {
                    for(int i=0;i<13;++i) {
                        int poker = Integer.parseInt(pokerManager.cards[i]);

                        if(poker != 0 && (poker-1)/13==pokerManager.currentFlower)
                        {
                            haveFlower = true;
                            break;
                        }
                    }
                }

                alert.setTitle("");
                if(haveFlower && (currentPoker-1)/13 != pokerManager.currentFlower) {

                    alert.setMessage("Foul!!!");
                    alert.setNegativeButton("OK", null);
                }
                else {
                    int takePoker = Integer.parseInt(pokerManager.cards[(int)getTag()]);
                    String message = String.format("You will play %s\n",CardView.showPokerStr(takePoker));

                    alert.setMessage(message);
                    alert.setNegativeButton("Cancel", null);
                    alert.setPositiveButton("Confirm", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialogInterface, int i) {
                            if (listener != null) {
                                listener.confirmPoker((int)getTag());
                            }
                        }
                    });
                }

                alert.show();
            }
        });
    }

    public void setCard(int card) {
        String fileName = String.format("card%d",card);
        int resID = getResources().getIdentifier(fileName, "mipmap", getContext().getPackageName());
        setImageResource(resID);
    }

    public void resetPosition() {

    }
}