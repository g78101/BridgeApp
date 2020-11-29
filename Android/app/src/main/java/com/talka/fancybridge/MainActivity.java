package com.talka.fancybridge;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.view.WindowManager;

import com.talka.fancybridge.Manager.PokerManager;
import com.talka.fancybridge.Manager.StateManager;
import com.talka.fancybridge.Views.CallView;
import com.talka.fancybridge.Views.PlayView;
import com.talka.fancybridge.Views.WaitView;

public class MainActivity extends AppCompatActivity implements StateManager.StateManagerListener {

    WaitView mWaitView;
    CallView mCallView;
    PlayView mPlayView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
        setContentView(R.layout.activity_main);

        mWaitView = (WaitView)findViewById(R.id.wait);
        mCallView = (CallView)findViewById(R.id.call);
        mPlayView = (PlayView)findViewById(R.id.play);

        StateManager.getInstance();
        StateManager.getInstance().setContext(MainActivity.this);
        StateManager.getInstance().listener = this;

        mWaitView.setVisibility(View.VISIBLE);
        mCallView.setVisibility(View.INVISIBLE);
        mPlayView.setVisibility(View.INVISIBLE);

//        StateManager.getInstance().players = new String[]{"我我我我我", "我我我我我", "我我我我我","我我我我我"};
//        PokerManager.getInstance().setCards( new String[]{"1", "2", "3","14","15", "16", "27","28","29", "40", "41","42","0"});
//        mWaitView.setVisibility(View.INVISIBLE);
//        mCallView.setVisibility(View.INVISIBLE);
//        mPlayView.setVisibility(View.VISIBLE);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();

        StateManager.getInstance().interruptConnect();
    }

    @Override
    public void updateWaitingUI(int normalCount,int threeModeCount) {
        mWaitView.updateUI(normalCount, threeModeCount);
    }

    @Override
    public void changeStateUI(StateManager.GameState state) {

        switch (state) {
            case Connected:
                break;
            case Wait:
                mWaitView.clear();
                mWaitView.setVisibility(View.VISIBLE);
                mCallView.setVisibility(View.INVISIBLE);
                mPlayView.setVisibility(View.INVISIBLE);
                break;
            case Call:
                mWaitView.setVisibility(View.INVISIBLE);
                mCallView.setVisibility(View.VISIBLE);
                mPlayView.setVisibility(View.INVISIBLE);
                break;
            case CallChoosePartner:
                mWaitView.setVisibility(View.INVISIBLE);
                mCallView.setVisibility(View.VISIBLE);
                mPlayView.setVisibility(View.INVISIBLE);
                break;
            case Play:
                mWaitView.setVisibility(View.INVISIBLE);
                mCallView.setVisibility(View.INVISIBLE);
                mPlayView.setVisibility(View.VISIBLE);
                break;
        }
    }

    // back
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK && event.getRepeatCount() == 0) {
            return false;
        }

        return super.onKeyDown(keyCode, event);
    }
}
