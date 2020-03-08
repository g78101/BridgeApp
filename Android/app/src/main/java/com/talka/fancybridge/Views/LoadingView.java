package com.talka.fancybridge.Views;

import android.app.Activity;
import android.content.Context;
import android.content.ContextWrapper;
import android.support.constraint.ConstraintLayout;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ProgressBar;

import com.talka.fancybridge.R;

public class LoadingView extends ConstraintLayout {
    ProgressBar progressBar;

    static  LoadingView loadingView;

    public LoadingView(Context context) {
        super(context);

        LayoutInflater inflate = (LayoutInflater) this.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View view = inflate.inflate(R.layout.loading_view, this, true);
        progressBar = (ProgressBar) view.findViewById(R.id.loadingProgressBar);
    }

    public static void checkLoadingView(Context context) {

        if (loadingView == null) {
            loadingView = new LoadingView(context);
        }
    }

    public static void start(Context context) {
        Activity activity = getActivity(context);
        ViewGroup newParent = (ViewGroup)activity.getWindow().getDecorView().getRootView();
        checkLoadingView(activity);

        ViewGroup parentView = (ViewGroup) loadingView.getParent();
        if (parentView != null) {
            stop(activity);
        }

        newParent.addView(loadingView,newParent.getWidth(),newParent.getHeight());
    }

    public static void stop(Context context) {
        checkLoadingView(context);

        ViewGroup parentView = (ViewGroup) loadingView.getParent();
        if (parentView != null) {
            parentView.removeView(loadingView);
        }
    }

    public static Activity getActivity(Context context) {
        while (context instanceof ContextWrapper) {
            if (context instanceof Activity) {
                return (Activity) context;
            }
            context = ((ContextWrapper) context).getBaseContext();
        }
        return null;
    }

}