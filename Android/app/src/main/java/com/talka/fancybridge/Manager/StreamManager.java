package com.talka.fancybridge.Manager;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.InetAddress;
import java.net.Socket;
import java.util.concurrent.CountDownLatch;

import static java.lang.System.exit;

public class StreamManager {

    static StreamManager instance = null;

    public interface StreamManagerListener {
        public void getData(String data);
    }

    private static String ServerURL = "talkaying.ga";
    private static int ServerPort = 8888;

    private Thread thread;
    private Socket clientSocket;
    private BufferedWriter bw;
    private BufferedReader br;
    private String tmp;

    public StreamManagerListener listener;
    public Context context;

    public static synchronized StreamManager getInstance() {
        if (instance == null) {
            instance = new StreamManager();
        }
        return instance;
    }

    public void setContext(Context context) {
        this.context = context;
    }

    public void connect() {
        thread=new Thread(Connection);
        thread.start();
    }

    public void sendMessage(final String message) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    bw.write(message);
                    bw.flush();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }).start();
    }

    private Runnable Connection=new Runnable(){
        @Override
        public void run() {
            // TODO Auto-generated method stub
            try{
                InetAddress serverIp = InetAddress.getByName(StreamManager.ServerURL);

                clientSocket = new Socket(serverIp, StreamManager.ServerPort);

                bw = new BufferedWriter( new OutputStreamWriter(clientSocket.getOutputStream()));
                br = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));

                while (clientSocket.isConnected()) {
                    tmp = br.readLine();

                    if(tmp!=null && !tmp.equals("is Full")) {
                        final CountDownLatch latch = new CountDownLatch(1);
                        Handler mainHandler = new Handler(Looper.getMainLooper());
                        Runnable myRunnable = new Runnable() {
                            @Override
                            public void run() {
                                if (listener != null) {
                                    listener.getData(tmp);
                                }
                                latch.countDown();
                            }
                        };
                        mainHandler.post(myRunnable);
                        latch.await();
                    }
                    else {
                        throw new Exception("Exception thrown");
                    }

                    if(tmp==null) {
                        break;
                    }
                }
            }catch(Exception e){
                e.printStackTrace();

                if(!StateManager.getInstance().isGameOver) {
                    Handler mainHandler = new Handler(Looper.getMainLooper());
                    Runnable myRunnable = new Runnable() {
                        @Override
                        public void run() {
                            AlertDialog.Builder alert = new AlertDialog.Builder(context);
                            alert.setTitle("Server Error");
                            alert.setMessage("Something is wrong");
                            alert.setPositiveButton("OK", new DialogInterface.OnClickListener() {
                                @Override
                                public void onClick(DialogInterface dialogInterface, int i) {
                                    exit(1);
                                }
                            });
                            alert.show();
                        }
                    };
                    mainHandler.post(myRunnable);
                }
            }
        }
    };

    public void disconnect() {
        try {
            bw.write("");
            bw.flush();
            bw.close();
            br.close();
            clientSocket.close();
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            Log.e("text","finalize()="+e.toString());
        }
    }
}