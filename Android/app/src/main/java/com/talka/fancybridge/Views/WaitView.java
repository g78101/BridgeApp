package com.talka.fancybridge.Views;

import android.app.AlertDialog;
import android.content.Context;
import android.content.pm.PackageManager;
import android.graphics.Paint;
import android.support.constraint.ConstraintLayout;
import android.text.Editable;
import android.text.InputType;
import android.text.TextWatcher;
import android.util.AttributeSet;
import android.util.Log;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.talka.fancybridge.Manager.StateManager;
import com.talka.fancybridge.R;

public class WaitView extends ConstraintLayout {

    static String comfirmText = "Join (%d/4)";
    static String threeModeText = "Three player mode(%d/3)";

    private TextView versionView;
    private EditText editText;
    private Button confirm;
    private Button threeModeBtn;

    public WaitView(Context context) {
        super(context);
        init(context);
    }

    public WaitView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }

    public WaitView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init(context);
    }

    private void init(Context context) {
        LayoutInflater inflate = (LayoutInflater) this.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View view = inflate.inflate(R.layout.wait_view, this, true);
        versionView = (TextView) findViewById(R.id.versionView);
        editText = (EditText) findViewById(R.id.editText);
        confirm = (Button) findViewById(R.id.confirm);
        threeModeBtn = (Button) findViewById(R.id.threemodebtn);

        String versionStr = "";
        try {
            versionStr = getContext().getPackageManager().getPackageInfo(getContext().getPackageName(),0).versionName;
        } catch (PackageManager.NameNotFoundException e) {

        }
        versionView.setText(versionStr);

        editText.addTextChangedListener(new TextWatcher() {

            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

                confirm.setEnabled(true);
            }

            @Override
            public void afterTextChanged(Editable editable) {

            }
        });

        editText.setOnKeyListener(new View.OnKeyListener() {
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                if ((event.getAction() == KeyEvent.ACTION_DOWN) && (keyCode == KeyEvent.KEYCODE_ENTER)) {
                    editText.setRawInputType(InputType.TYPE_CLASS_TEXT);
                    return true;
                }
                return false;
            }
        });

        confirm.setOnClickListener( new OnClickListener() {
            @Override
            public void onClick(View view) {

                if(editText.getText().length() > 5) {
                    AlertView.showViewSetText(getContext(),"Please enter less 5 length name");
                }
                else if(editText.getText().length() != 0) {
                    StateManager.getInstance().playInfo.name = ""+editText.getText();
                    StateManager.getInstance().connectServer();
                    confirm.setEnabled(false);
                    editText.setRawInputType(InputType.TYPE_CLASS_TEXT);
                    editText.setEnabled(false);
                }
                else {
                    AlertView.showViewSetText(getContext(),"Please enter name");
                }
            }
        });

        threeModeBtn.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View view) {
                threeModeBtn.setEnabled(false);
                StateManager.getInstance().joinThreeMode();
            }
        });

        threeModeBtn.setPaintFlags(Paint.UNDERLINE_TEXT_FLAG);
    }

    public void clear() {
        threeModeBtn.setEnabled(true);
    }

    public void updateUI(int normalCount,int threeModeCount) {
        confirm.setText(String.format(WaitView.comfirmText,normalCount));
        threeModeBtn.setText(String.format(WaitView.threeModeText,threeModeCount));
        threeModeBtn.setVisibility(VISIBLE);
    }
}