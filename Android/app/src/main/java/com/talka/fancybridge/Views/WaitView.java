package com.talka.fancybridge.Views;

import android.app.AlertDialog;
import android.content.Context;
import android.content.pm.PackageManager;
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

    private TextView infoView;
    private TextView versionView;
    private EditText editText;
    private Button confirm;

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
        infoView = (TextView) findViewById(R.id.infoView);
        versionView = (TextView) findViewById(R.id.versionView);
        editText = (EditText) findViewById(R.id.editText);
        confirm = (Button) findViewById(R.id.confirm);

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

                confirm.setEnabled(s.length() != 0);
            }

            @Override
            public void afterTextChanged(Editable editable) {

            }
        });

        editText.setOnKeyListener(new View.OnKeyListener() {
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                if ((event.getAction() == KeyEvent.ACTION_DOWN) && (keyCode == KeyEvent.KEYCODE_ENTER)) {
                    Log.d("onKey: ","123");
                    return true;
                }
                return false;
            }
        });

        confirm.setOnClickListener( new OnClickListener() {
            @Override
            public void onClick(View view) {

                if(!editText.getText().equals("")) {
                    StateManager.getInstance().playInfo.name = ""+editText.getText();
                    StateManager.getInstance().connectServer();
                    confirm.setEnabled(false);
                    editText.setRawInputType(InputType.TYPE_CLASS_TEXT);
                    editText.setEnabled(false);
                }
                else {
                    AlertDialog.Builder alert = new AlertDialog.Builder(getContext());
                    alert.setTitle("Warning");
                    alert.setMessage("Please enter name");
                    alert.setNegativeButton("OK", null);
                    alert.show();
                }
            }
        });
    }

    public void clearInfo() {
        infoView.setText("");
    }

    public void updateInfo(String str) {
        infoView.setText(infoView.getText() + str +"\n");
    }

}