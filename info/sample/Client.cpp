#include "MainWindow.h"
#include <Qtcore/QRegExp>
#include <QtGui>

#include "CoreFoundation/CoreFoundation.h"

#define POKER_CALL_BUTTON_NUMBER 49

ALboolean MainWindow::LoadALData()
{
    // Variables to load into.
    ALenum format;
    ALsizei size;
    ALvoid* data;
    ALsizei freq;
    ALboolean loop;
    
	// Position of the source sound.
	ALfloat SourcePos[1][3] = { 0.0, 0.0, 0.0 };
    
	// Velocity of the source sound.
	ALfloat SourceVel[1][3] = { {0.0, 0.0, 0.0} };
    
    // Load wav datas into 5 buffers.
    alGenBuffers(1, Buffers);
    if(alGetError() != AL_NO_ERROR)
        return AL_FALSE;
    std::string wavePath = std::string(resourcesPath);
    wavePath.append("/ring.wav");
    alutLoadWAVFile((ALbyte*)wavePath.c_str(), &format, &data, &size, &freq);
    alBufferData(Buffers[0], format, data, size, freq);
    alutUnloadWAV(format, data, size, freq);
    
    alGenSources(1, Sources);
    
    if(alGetError() != AL_NO_ERROR)
		return AL_FALSE;
    
    alSourcei (Sources[0], AL_BUFFER,Buffers[0]);
    alSourcef (Sources[0], AL_PITCH,1.0);
    alSourcef (Sources[0], AL_GAIN,1.0);
    alSourcefv(Sources[0], AL_POSITION,SourcePos[0]);
    alSourcefv(Sources[0], AL_VELOCITY,SourceVel[0]);
    alSourcei (Sources[0], AL_LOOPING,AL_FALSE);
    
    if(alGetError() == AL_NO_ERROR)
		return AL_TRUE;
    
    return AL_FALSE;
}
void MainWindow::SetListenerValues()
{
	// Position of the Listener.
	ALfloat ListenerPos[] = { 0.0, 0.0, 0.0 };
    
	// Velocity of the Listener.
	ALfloat ListenerVel[] = { 0.0, 0.0, 0.0 };
    
	// Orientation of the Listener. (first 3 elements are "at", second 3 are "up")
	// Also note that these should be units of '1'.
	ALfloat ListenerOri[] = { 0.0, 0.0, -1.0,  0.0, 1.0, 0.0 };
    
    alListenerfv(AL_POSITION,    ListenerPos);
    alListenerfv(AL_VELOCITY,    ListenerVel);
    alListenerfv(AL_ORIENTATION, ListenerOri);
}
void MainWindow::KillALData()
{
    alDeleteBuffers(1, Buffers);
    alDeleteSources(1, Sources);
    alutExit();
}

// This is our MainWindow constructor (you C++ n00b)
MainWindow::MainWindow(QWidget *parent) : QMainWindow(parent)
{
    CFBundleRef mainBundle = CFBundleGetMainBundle();
    CFURLRef resourcesURL = CFBundleCopyResourcesDirectoryURL(mainBundle);
    resourcesPath = (char *)malloc(sizeof(char)*PATH_MAX);
    if (!CFURLGetFileSystemRepresentation(resourcesURL, TRUE, (UInt8 *)resourcesPath, PATH_MAX)) // Error: expected unqualified-id before 'if'
    {
        // error!
    }
    CFRelease(resourcesURL);
    
	this->resize(1280, 800);
    stackedWidget = new QStackedWidget(this);
    stackedWidget->setObjectName(QString::fromUtf8("stackedWidget"));
    
    now_Stage=waiting;
    flower<<" SA"<<" MD"<<" C"<<" D"<<" H"<<" S"<<" NT";
    //flower<<" SA"<<" MD"<<" ♣(C)"<<" ♦(D)"<<" ♥(H)"<<" ♠(S)"<<" NT";
    trump=0;
    GUI_initial();
    
    // When using Designer, you should always call setupUi(this)
    // in your constructor. This creates and lays out all the widgets
    // on the MainWindow that you setup in Designer.
    
    stackedWidget->setCurrentWidget(loginPage);
    // Make sure that we are showing the login page when we startup:
    
    // Instantiate our socket (but don't actually connect to anything
    // yet until the user clicks the loginButton:
    socket = new QTcpSocket(this);
    
    alutInit(NULL, 0);
	alGetError();
	// Load the wav data.
	if(LoadALData() == AL_FALSE)
	{
		printf("Error loading data.");
	}
	SetListenerValues();
	// Setup an exit procedure.
    //	atexit(KillALData);
    
    // This is how we tell Qt to call our readyRead() and connected()
    // functions when the socket has text ready to be read, and is done
    // connecting to the server (respectively):
    connect(socket, SIGNAL(readyRead()), this, SLOT(readyRead()));
    connect(socket, SIGNAL(connected()), this, SLOT(connected()));
}

MainWindow::~MainWindow()
{
	KillALData();
    delete [] callbutton;
    delete [] userEdit;
    delete [] SNPcall_userEdit;
    delete [] SNPplay_userEdit;
}


void MainWindow::GUI_initial()
{
    //GUI以兩個stackedWidget組成
    //最上層stackedWidget裡面放置loginPage與stackedWidget2
    //之所以還要分stackedWidget2是因為讓chatwidget在登入後都能使用
    
    QVBoxLayout *verticalLayout;
	QLabel *titleLabel;
    QFrame *mainFrame;
    
    QVBoxLayout *verticalLayout_2;
    QVBoxLayout *verticalLayout_3;
    QGridLayout *gridLayout;
    QGridLayout *gridLayout_1;
    QPushButton *sayButton;
    QGridLayout *gridLayout_3;
    QSpacerItem *verticalSpacer;
    QSpacerItem *horizontalSpacer;
    QFrame *loginFrame;
    QGridLayout *gridLayout_2;
	QGridLayout *gridLayout_4;
    QLabel *label;
    QLabel *label_2;
    
    QPushButton *loginButton;
    QSpacerItem *horizontalSpacer_2;
    QSpacerItem *verticalSpacer_2;
    
    this->setStyleSheet(QString::fromUtf8("#titleLabel {\n"
                                          "background: white;\n"
                                          "color: blue;\n"
                                          "font-size: 20px;\n"
                                          "border: none;\n"
                                          "border-bottom:  1px solid black;\n"
                                          "padding: 5px;\n"
                                          "}\n"
                                          "\n"
                                          "#mainFrame {\n"
                                          "border: none;\n"
                                          "background: white;\n"
                                          "}\n"
                                          "\n"
                                          "#loginFrame {\n"
                                          "background: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #ddf, stop: 1 #aaf);\n"
                                          "border: 1px solid gray;\n"
                                          "padding: 10px;\n"
                                          "border-radius: 25px;\n"
                                          "}"));
    //標題列的GUI
    centralwidget = new QWidget(this);
    centralwidget->setObjectName(QString::fromUtf8("centralwidget"));
    verticalLayout = new QVBoxLayout(centralwidget);
    verticalLayout->setSpacing(0);
    verticalLayout->setContentsMargins(0, 0, 0, 0);
    verticalLayout->setObjectName(QString::fromUtf8("verticalLayout"));
    titleLabel = new QLabel(centralwidget);
    titleLabel->setObjectName(QString::fromUtf8("titleLabel"));
    titleLabel->setText(tr("Bridge 1.1 Beta"));
    QSizePolicy sizePolicy(QSizePolicy::Preferred, QSizePolicy::Fixed);
    sizePolicy.setHorizontalStretch(0);
    sizePolicy.setVerticalStretch(0);
    sizePolicy.setHeightForWidth(titleLabel->sizePolicy().hasHeightForWidth());
    titleLabel->setSizePolicy(sizePolicy);
    
    verticalLayout->addWidget(titleLabel);
    
    mainFrame = new QFrame(centralwidget);
    mainFrame->setObjectName(QString::fromUtf8("mainFrame"));
    mainFrame->setFrameShape(QFrame::StyledPanel);
    verticalLayout_2 = new QVBoxLayout(mainFrame);
    verticalLayout_2->setObjectName(QString::fromUtf8("verticalLayout_2"));
    secondFrame = new QFrame();
    secondFrame->setObjectName(QString::fromUtf8("secondFrame"));
    verticalLayout_3 = new QVBoxLayout(secondFrame);
    verticalLayout_3->setObjectName(QString::fromUtf8("verticalLayout_3"));
    
    //標題列(mainFrame)的子類別stackWidget
    stackedWidget = new QStackedWidget(mainFrame);
    stackedWidget->setObjectName(QString::fromUtf8("stackedWidget"));
    
    //stackWidget2初始化
    stackedWidget2 = new QStackedWidget(mainFrame);
    stackedWidget2->setObjectName(QString::fromUtf8("stackedWidget2"));
    
    /**************** chatwidget ****************/
    
    chatwidget = new QWidget(this);
    chatwidget->setObjectName(QString::fromUtf8("chatwidget"));
    gridLayout = new QGridLayout(chatwidget);
    gridLayout->setObjectName(QString::fromUtf8("gridLayout"));
    roomTextEdit = new QTextEdit(chatwidget);
    roomTextEdit->setObjectName(QString::fromUtf8("roomTextEdit"));
    roomTextEdit->setReadOnly(true);
    
    gridLayout->addWidget(roomTextEdit, 0, 0, 1, 1);
    
    userListWidget = new QListWidget(chatwidget);
    userListWidget->setObjectName(QString::fromUtf8("userListWidget"));
    
    gridLayout->addWidget(userListWidget, 0, 1, 1, 2);
    
    sayLineEdit = new QLineEdit(chatwidget);
    sayLineEdit->setObjectName(QString::fromUtf8("sayLineEdit"));
    
    gridLayout->addWidget(sayLineEdit, 1, 0, 1, 2);
    
    sayButton = new QPushButton(chatwidget);
    sayButton->setObjectName(QString::fromUtf8("sayButton"));
    sayButton->setText("Say");
    QSizePolicy sizePolicy1(QSizePolicy::Fixed, QSizePolicy::Fixed);
    sizePolicy1.setHorizontalStretch(0);
    sizePolicy1.setVerticalStretch(0);
    sizePolicy1.setHeightForWidth(sayButton->sizePolicy().hasHeightForWidth());
    sayButton->setSizePolicy(sizePolicy1);
    sayButton->setMaximumSize(QSize(50, 16777215));
    
    gridLayout->addWidget(sayButton, 1, 2, 1, 1);
    
    /**************** waitingPage ****************/
    
    waitingPage = new QWidget();
    
    gridLayout_1 = new QGridLayout(waitingPage);
    systemEdit = new QTextEdit(waitingPage);
    systemEdit->setObjectName(QString::fromUtf8("stageEdit"));
    systemEdit->setReadOnly(true);
    
    gridLayout_1->addWidget(systemEdit, 0, 0, 1, -1);
    
    gridLayout_1->addWidget(chatwidget, 1, 0,1,-1);
    
    stackedWidget2->addWidget(waitingPage);
    
    /**************** loginPage ****************/
    
    loginPage = new QWidget();
    loginPage->setObjectName(QString::fromUtf8("loginPage"));
    gridLayout_3 = new QGridLayout(loginPage);
    gridLayout_3->setObjectName(QString::fromUtf8("gridLayout_3"));
    verticalSpacer = new QSpacerItem(20, 100, QSizePolicy::Minimum, QSizePolicy::Fixed);
    
    gridLayout_3->addItem(verticalSpacer, 0, 1, 1, 1);
    
    horizontalSpacer = new QSpacerItem(223, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);
    
    gridLayout_3->addItem(horizontalSpacer, 1, 0, 1, 1);
    
    loginFrame = new QFrame(loginPage);
    loginFrame->setObjectName(QString::fromUtf8("loginFrame"));
    sizePolicy1.setHeightForWidth(loginFrame->sizePolicy().hasHeightForWidth());
    loginFrame->setSizePolicy(sizePolicy1);
    loginFrame->setMinimumSize(QSize(300, 0));
    loginFrame->setFrameShape(QFrame::StyledPanel);
    gridLayout_2 = new QGridLayout(loginFrame);
    gridLayout_2->setSpacing(20);
    gridLayout_2->setObjectName(QString::fromUtf8("gridLayout_2"));
    label = new QLabel(loginFrame);
    label->setObjectName(QString::fromUtf8("label"));
    label->setText("Server IP:");
    gridLayout_2->addWidget(label, 0, 0, 1, 1);
    
    serverLineEdit = new QLineEdit(loginFrame);
    serverLineEdit->setObjectName(QString::fromUtf8("serverLineEdit"));
    
    gridLayout_2->addWidget(serverLineEdit, 0, 1, 1, 1);
    
    label_2 = new QLabel(loginFrame);
    label_2->setObjectName(QString::fromUtf8("label_2"));
    label_2->setText("User name:");
    gridLayout_2->addWidget(label_2, 1, 0, 1, 1);
    
    userLineEdit = new QLineEdit(loginFrame);
    userLineEdit->setObjectName(QString::fromUtf8("userLineEdit"));
    
    gridLayout_2->addWidget(userLineEdit, 1, 1, 1, 1);
    
    loginButton = new QPushButton(loginFrame);
    loginButton->setObjectName(QString::fromUtf8("loginButton"));
    loginButton->setText("Login");
    sizePolicy1.setHeightForWidth(loginButton->sizePolicy().hasHeightForWidth());
    loginButton->setSizePolicy(sizePolicy1);
    
    gridLayout_2->addWidget(loginButton, 2, 1, 1, 1);
    gridLayout_3->addWidget(loginFrame, 1, 1, 1, 1);
    
    horizontalSpacer_2 = new QSpacerItem(223, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);
    
    gridLayout_3->addItem(horizontalSpacer_2, 1, 2, 1, 1);
    
    verticalSpacer_2 = new QSpacerItem(20, 267, QSizePolicy::Minimum, QSizePolicy::Expanding);
    
    gridLayout_3->addItem(verticalSpacer_2, 2, 1, 1, 1);
    
    stackedWidget->addWidget(loginPage);
    
    verticalLayout_2->addWidget(stackedWidget);
    
    verticalLayout->addWidget(mainFrame);
    
    /**************** callingPage ****************/
    
    callingPage = new QWidget();

	callingBridge = new GLCallBridge(0,0);
    
    callbutton = new QPushButton* [POKER_CALL_BUTTON_NUMBER];
    QPushButton *callpass = new QPushButton("Pass");
    QGridLayout *gridLayout_call =  new QGridLayout();
    
    for (unsigned int i=0; i<POKER_CALL_BUTTON_NUMBER; ++i) {
        // i/7指的是第幾level   i%7指的是7種喊牌
        // 將喊牌圖案以同一level放在同一列
        // 1S=5  第0層(5/7)  第5種喊牌(5%7)
        // 6H=39 第5層(39/7) 第4種喊牌(39%7)
        callbutton[i] = new QPushButton;
        callbutton[i]->setIcon(QIcon(QString("%1/%2.png").arg(resourcesPath,QString::number(i))));
        callbutton[i]->setIconSize(QSize(50,21));
        gridLayout_call->addWidget(callbutton[i],i/7,i%7);
        connect(callbutton[i],SIGNAL(clicked()),this,SLOT(callButtonClick()));
    }
    
    gridLayout_call->addWidget(callpass,7,0,1,-1);
    
    QGridLayout *gridLayout_user =  new QGridLayout();
    
    //各個玩家的喊牌紀錄
    userEdit = new QTextEdit[4];
   
    for (int i=0; i<4; ++i)
        userEdit[i].setReadOnly(true);

    //玩家的名稱
    user0 = new QLabel();
    user1 = new QLabel();
    user2 = new QLabel();
    user3 = new QLabel();
    
    gridLayout_user->addWidget(user0, 0, 0);
    gridLayout_user->addWidget(user1, 0, 1);
    gridLayout_user->addWidget(user2, 0, 2);
    gridLayout_user->addWidget(user3, 0, 3);
    gridLayout_user->addWidget(&userEdit[0], 1, 0);
    gridLayout_user->addWidget(&userEdit[1], 1, 1);
    gridLayout_user->addWidget(&userEdit[2], 1, 2);
    gridLayout_user->addWidget(&userEdit[3], 1, 3);
    
    //callingBridge(OpenGL)放在第一層
    //第二層第一個放gridLayout_call(按鈕)
    //第二層第二個放gridLayout_user(名稱+紀錄)
    gridLayout_4 = new QGridLayout(callingPage);
    gridLayout_4->setObjectName(QString::fromUtf8("gridLayout_4"));
    gridLayout_4->addWidget(callingBridge,0,0,1,-1);
    gridLayout_4->addLayout(gridLayout_call,1,0,1,1);
    gridLayout_4->addLayout(gridLayout_user, 1, 1,1,1);

    connect(callpass,SIGNAL(clicked()),this,SLOT(button_pass()));

    connect(this,SIGNAL(callingsend_signal(int)),this,SLOT(callingsend_slot(int)));
    stackedWidget2->addWidget(callingPage);
    
    /**************** playPage ****************/
	
	QHBoxLayout *hLayout;
	QVBoxLayout *vLayout;
    
	playingPage = new QWidget();
	hLayout = new QHBoxLayout(playingPage);
	vLayout = new QVBoxLayout();
    QHBoxLayout *ourScore_hLayout = new QHBoxLayout();
    QHBoxLayout *enemyScore_hLayout = new QHBoxLayout();
	playingBridge = new GLPlayBridge(0,0);
	trumpLabel = new QLabel();
	ourTeam = new QLabel();
	ourScore = new QLCDNumber();
    goal_ourScore = new QLCDNumber();
	enemyTeam = new QLabel();
	enemyScore = new QLCDNumber();
    goal_enemyScore = new QLCDNumber();
	showbutton = new QPushButton();
	showbutton->setText("Show Now Pokers");
    
	vLayout->addWidget(trumpLabel);
	vLayout->addWidget(ourTeam);
    
    ourScore_hLayout->addWidget(ourScore);
    ourScore_hLayout->addWidget(goal_ourScore);
    vLayout->addLayout(ourScore_hLayout);
	
	vLayout->addWidget(enemyTeam);
    
    enemyScore_hLayout->addWidget(enemyScore);
    enemyScore_hLayout->addWidget(goal_enemyScore);
    vLayout->addLayout(enemyScore_hLayout);
	vLayout->addWidget(showbutton);
    
    //////////////////////////////////
    //showbutton裡呼叫的元件初始化
    SNP_user0 = new QLabel();
    SNP_user1 = new QLabel();
    SNP_user2 = new QLabel();
    SNP_user3 = new QLabel();
    
    SNPcall_userEdit = new QTextEdit[4];
    SNPplay_userEdit = new QTextEdit[4];
    
    for (int i=0; i<4; ++i) {
        SNPcall_userEdit[i].setReadOnly(true);
        SNPplay_userEdit[i].setReadOnly(true);
    }
    ////////////////////////////////////
    
    //水平左邊是playingBridge(OpenGL)
	hLayout->addWidget(playingBridge);
	hLayout->addLayout(vLayout);
	stackedWidget2->addWidget(playingPage);
    
	connect(this,SIGNAL(setOurScore(int)),ourScore,SLOT(display(int)));
	connect(this,SIGNAL(setEnemyScore(int)),enemyScore,SLOT(display(int)));
	connect(showbutton,SIGNAL(clicked()),this,SLOT(showAllPoker()));
    
    //playingBridge將打出的牌傳給MainWindow知道
	connect(playingBridge,SIGNAL(leadPoker(int)),this,SLOT(catchInformation(int)));
    
    //ready to delete
    stackedWidget->addWidget(secondFrame);
    verticalLayout_3->addWidget(stackedWidget2);
    verticalLayout_3->addWidget(chatwidget);
    
    this->setCentralWidget(centralwidget);
    
    QWidget::setTabOrder(serverLineEdit, userLineEdit);
    QWidget::setTabOrder(userLineEdit, loginButton);
    QWidget::setTabOrder(loginButton, roomTextEdit);
    QWidget::setTabOrder(roomTextEdit, userListWidget);
    QWidget::setTabOrder(userListWidget, sayLineEdit);
    QWidget::setTabOrder(sayLineEdit, sayButton);
    
    QObject::connect(sayLineEdit, SIGNAL(returnPressed()), sayButton, SLOT(animateClick()));
    QObject::connect(serverLineEdit, SIGNAL(returnPressed()), userLineEdit, SLOT(setFocus()));
    QObject::connect(userLineEdit, SIGNAL(returnPressed()), loginButton, SLOT(animateClick()));

    stackedWidget->setCurrentIndex(1);
    
    QMetaObject::connectSlotsByName(this);
}

// This gets called when the loginButton gets clicked:
// We didn't have to use connect() to set this up because
// Qt recognizes the name of this function and knows to set
// up the signal/slot connection for us.
void MainWindow::on_loginButton_clicked()
{
    // Start connecting to the chat server (on port 4200).
    // This returns immediately and then works on connecting
    // to the server in the background. When it's done, we'll
    // get a connected() function call (below). If it fails,
    // we won't get any error message because we didn't connect()
    // to the error() signal from this socket.
    socket->connectToHost(serverLineEdit->text(), 4200);
}

// This gets called when the user clicks the sayButton (next to where
// they type text to send to the chat room):
void MainWindow::on_sayButton_clicked()
{
    // What did they want to say (minus white space around the string):
    QString message = sayLineEdit->text().trimmed();
    
    // Only send the text to the chat server if it's not empty:
    if(!message.isEmpty())
    {
        socket->write(QString(message + "\n").toUtf8());
    }
    
    // Clear out the input box so they can type something else:
    sayLineEdit->clear();
    
    // Put the focus back into the input box so they can type again:
    sayLineEdit->setFocus();
}

// This function gets called whenever the chat server has sent us some text:
void MainWindow::readyRead()
{
    // We'll loop over every (complete) line of text that the server has sent us:
    while(socket->canReadLine())
    {
        // Here's the line the of text the server sent us (we use UTF-8 so
        // that non-English speakers can chat in their native language)
        QString line = QString::fromUtf8(socket->readLine()).trimmed();
        
        // These two regular expressions describe the kinds of messages
        // the server can send us:
        
        //  Normal messges look like this: "username:The message"
        QRegExp messageRegex("^([^:]+):(.*)$");
        
		QRegExp fullRegex("^/system:(.*):(.*)$");
        
        // Any message that starts with "/users:" is the server sending us a
        // list of users so we can show that list in our GUI:
        QRegExp usersRegex("^/users:(.*)$");
        
        // Is this a users message:
        if(usersRegex.indexIn(line) != -1)
        {
            // If so, udpate our users list on the right:
            QStringList users = usersRegex.cap(1).split(",");
            userListWidget->clear();
            foreach(QString user, users)
            new QListWidgetItem(QPixmap(QString("%1/user.png").arg(resourcesPath)), user, userListWidget);
        }
        //主要判別狀態並動作的地方!!!!
		else if(fullRegex.indexIn(line) != -1)
		{
			QString use = fullRegex.cap(1);
            QStringList message = fullRegex.cap(2).split(",");
            
            //client目前在什麼狀態
            if(now_Stage==waiting)
            {
                //當從server接到change_callPage
                if(use=="change_callPage")
                {
                    //更換GUI頁面並將client狀態改成calling
                    stackedWidget2->setCurrentWidget(callingPage);
                    now_Stage=calling;
                }
                
                //人數不足則顯示等待
                systemEdit->append("<b>" + tr("waiting") + " </b> "+ message[0].toLocal8Bit().constData());
            }
            else if(now_Stage==calling)
            {
                if(use=="users")
                {
                    //server會先傳送玩家的名稱 方便client紀錄
                    userName<<message;
                 
                    user0->setText(tr("(Team A) Player 1\n")+userName[0]);
                    user1->setText(tr("(Team B) Player 2\n")+userName[1]);
                    user2->setText(tr("(Team A) Player 3\n")+userName[2]);
                    user3->setText(tr("(Team B) Player 4\n")+userName[3]);
                    SNP_user0->setText(tr("(Team A) Player 1\n")+userName[0]);
                    SNP_user1->setText(tr("(Team B) Player 2\n")+userName[1]);
                    SNP_user2->setText(tr("(Team A) Player 3\n")+userName[2]);
                    SNP_user3->setText(tr("(Team B) Player 4\n")+userName[3]);
                    
                    //初始化兩邊分數
                    ourScore_number=0;
                    enemyScore_number=0;
                    //紀錄client的名稱在server的名稱陣列為第幾個位置 
                    for (int i=0; i<4; ++i) {
                        if(userLineEdit->text()==userName[i])
                        {
                            myturnid=i;
                            break;
                        }
                    }
                    //將喊牌權交給第一個
                    call_or_play_turn=0;
                    //若client為第一個 則第一個喊牌 並發出音效
                    if (myturnid==0) {
                        roomTextEdit->append("<b>" + tr("system : ") + "</b>: " + tr("your turn"));
						alSourcePlay(Sources[0]);
                    }
                }
                //server將牌發給client
                if(use==userLineEdit->text())
                {
                    for (int i=0; i<13; ++i) {
                        card[i]=message[i].toInt();
                    }
                    //並將牌傳入callingBridge
                    callingBridge->setCard(card);
                }
                if(use=="callcall")
                {
                    call_or_play_turn=message[0].toInt();
                    int now_call = message[1].toInt();
                    int lastturn = (call_or_play_turn-1+4)%4;
                    
                    if (now_call!=-1) {
                        //更新前一位玩家所喊的王牌到client的user表裡
                        userEdit[lastturn].append(QString::number((now_call/7)+1)+" "+flower[now_call%7]);
                        SNPcall_userEdit[lastturn].append(QString::number((now_call/7)+1)+" "+flower[now_call%7]);
                        //將目前"喊到王牌"之前的按鈕設定為不可按
                        for(int i=trump;i<=now_call;++i)
                        {
                            callbutton[i]->setEnabled(0);
                        }  
                        trump=now_call+1;
                    }
                    else {
                        userEdit[lastturn].append(tr("Pass"));
                        SNPcall_userEdit[lastturn].append(tr("Pass"));
                    }
                    
                    if (myturnid==call_or_play_turn) {
                        alSourcePlay(Sources[0]);
                        roomTextEdit->append("<b>" + tr("system : ") + "</b>: " + tr("your turn"));
                    }
                }
				if(use=="change_playPage")
                {
                    //更換GUI為playingPage 並切換目前狀態為playing
                    stackedWidget2->setCurrentWidget(playingPage);
                    now_Stage=playing;
                    
					//VXXO V = lastuser XX = trump  O = who call first
                    int temp=message[0].toInt();
                    
					trump=(temp/10)%100;
                  
                    if ((temp/1000)==myturnid||(temp/1000)==(myturnid+2)%4) //沒喊到
                        win_number = 14-(trump/7+7);
                    else
                        win_number = (trump/7+7);
                    
                    goal_ourScore->display(win_number);
                    goal_enemyScore->display((14-win_number));
                    
                    //設定起始牌桌 53(快出牌啊!!) 0(牌的封面)
                    for(int i=0,k=myturnid;i<4;++i,++k) {
                        if (k==4) k=0;
                        
                        if (k==((temp%10)+1)%4) {
                            table[i]=53;
                        }
                        else
                            table[i]=0;
                    }
                    //若是client先打 則將playingBridge設定為true
                    if(myturnid==((temp%10)+1)%4)
					{
						alSourcePlay(Sources[0]);
                        playingBridge->setTurn(true);
					}
                    playingBridge->setMyturnid(myturnid);
                    
                    //table_time在這初始 因為第二盤之後 一些client還沒結束會讓table_time++
					table_time=1;
                    
					trumpLabel->setText("Trump : "+QString::number((trump/7)+1)+flower[trump%7]+"!!!");
                    
					ourTeam->setText("Our Team\n"+userName[myturnid]+"\n"+userName[(myturnid+2)%4]);
                    
					enemyTeam->setText("Enemy Team\n"+userName[(myturnid+1)%4]+"\n"+userName[(myturnid+3)%4]);
                    
                    //將牌與目前檯面狀態傳進playingBridge畫出
					playingBridge->setCard(card);
                    playingBridge->setTable(table);
                    
                    //call牌的喊牌記錄用不到了 直接先清掉
                    for(int i=0;i<4;++i)
                        userEdit[i].clear();
                }
            }
            else if(now_Stage==playing)
            {
                if(use=="playplay")
                {
					call_or_play_turn=message[0].toInt()%10;
                    int gameStatus = (message[0].toInt()/10)%10;
                    int last_poker = message[0].toInt()/100;
                    //XXVO  XX = poker V = type  O = play turn
                    switch (gameStatus) {
                        case PLAY_CARD://每輪的前三次
                        {
                            //table_time==1 代表為第一次尚未設定當輪的花色 故要記錄
                            if (table_time==1)  now_flower=(last_poker-1)/13;
                            
                            //為了將前一個人的牌存入table裡 所以要先算他的play_turn是多少
                            int last_turn=(call_or_play_turn-1+4)%4;
                            //將last_turnid所打的牌放到table裡
                            //EX: 2-3-0-1 (因為只有一個是從0開始)
                            for(int i=0,k=myturnid;i<4;++i,++k) {
                                //因為為遞增 所以超過邊界 則變為0
                                if (k==4) k=0;
                                if (k==last_turn) {
                                    //將上一輪的出牌放到對應的table上
                                    table[i]=last_poker;
                                    //並將出完牌的下一位設定成"快出牌啊"
                                    table[(i+1)%4]=53;
                                    break;
                                }
                                
                            }
                            //為了讓牌有紅黑紅黑錯開 所以我在檔案調動了club && diamond的位置
                            //可是現實是club<diamond 所以要調回來
                            //好像可以不用那麼"搞甘" 不過懶的優化了
                            
                            //計算上一張牌在flower是哪個位置  撲克牌這樣排序 ♦(D) ♣(C) ♥(H) ♠(S)
                            //flower<<" SA"<<" MD"<<" ♣(C)"<<" ♦(D)"<<" ♥(H)"<<" ♠(S)"<<" NT";
                            int change_C_D_flower = ((last_poker-1)/13)+2;
                            //because K = 13 26 39 52  so we have to -1
                            
                            //若是diamond就換成club
                            if (change_C_D_flower==2) change_C_D_flower=3;
                            //若是club就換成diamond
                            else if (change_C_D_flower==3) change_C_D_flower=2;
                            
                            //放進Show Now Poker的lastturn userEdit裡面
                            SNPplay_userEdit[last_turn].append(flower[change_C_D_flower]+tr(" ")+QString::number(((last_poker-1)%13)+1));
                            
                            //動作完畢就增加一次
                            table_time++;
                            //將table傳進OpenGL顯示 並設定當輪的花色
                            playingBridge->setTable(table);
                            playingBridge->setNowFlower(now_flower);
                            
                            
                            //將last_turn的動作都做完後 若輪到client則發聲音通知
                            if(myturnid==call_or_play_turn)
                            {
                                alSourcePlay(Sources[0]);
                                //並在OpenGL打開出牌權
                                playingBridge->setTurn(true);
                            }
                        }   break;
                            
                        case PLAY_LAST_CARD: //當輪的第四次  把最後出的牌更新到GUI上 不然不知最後一張是什麼牌就直接結束
                        {
                            //為了將前一個人的牌存入table裡 所以要先算他的play_turn是多少
                            int last_turn=(call_or_play_turn-1+4)%4;
                            //將last_turnid所打的牌放到table裡
                            //EX: 2-3-0-1 (因為只有一個是從0開始)
                            for(int i=0,k=myturnid;i<4;++i,++k) {
                                //因為為遞增 所以超過邊界 則變為0
                                if (k==4) k=0;
                                //將上一輪的出牌放到對應的table上
                                if (k==last_turn) {
                                    table[i]=last_poker;
                                    break;
                                }
                                //因為是第四次的狀態 不用設定"快出牌啊"
                                
                            }
                            //為了讓牌有紅黑紅黑錯開 所以我在檔案調動了club && diamond的位置
                            //可是現實是club<diamond 所以要調回來
                            //好像可以不用那麼"搞甘" 不過懶的優化了
                            
                            //計算上一張牌在flower是哪個位置  撲克牌這樣排序 ♦(D) ♣(C) ♥(H) ♠(S)
                            //flower<<" SA"<<" MD"<<" ♣(C)"<<" ♦(D)"<<" ♥(H)"<<" ♠(S)"<<" NT";
                            int change_C_D_flower = ((last_poker-1)/13)+2;
                            //because K = 13 26 39 52  so we have to -1
                            
                            //若是diamond就換成club
                            if (change_C_D_flower==2) change_C_D_flower=3;
                            //若是club就換成diamond
                            else if (change_C_D_flower==3) change_C_D_flower=2;
                            //放進Show Now Poker的lastturn userEdit裡面
                            
                            SNPplay_userEdit[last_turn].append(flower[change_C_D_flower]+tr(" ")+QString::number(((last_poker-1)%13)+1));
                            //只需設定OpenGL的table值
                            playingBridge->setTable(table);
                            
                            //主要是讓server繼續待在playplay裡 所以後面的值給0 0只是隨便給
                            QStringList send;
                            send<<QString::number(0,10)<<QString::number(0,10);
                            socket->write(QString("/system:" +tr("playplay")+":" +send.join(",")+"\n").toUtf8());
                        }   break;
                            
                        case PLAY_WAITING_JUDGE: //當輪結束更新桌面 Server會回傳下一輪的出牌權 這也代表誰吃到了那墩
                        {
                            //將table_time重設為1 因為下一輪開始了要恢復成第一次
                            table_time=1;
                            
                            for(int i=0,k=myturnid;i<4;++i,++k) {
                                if (k==4) k=0;
                                //將出牌權的table設為"快出牌啊"
                                if (k==call_or_play_turn) {
                                    table[i]=53;
                                }
                                //其餘設為牌的封面
                                else
                                    table[i]=0;
                            }
                            //若是自己 則發出聲音 並打開OpenGL出牌權
                            if(myturnid==(call_or_play_turn))
                            {
                                alSourcePlay(Sources[0]);
                                playingBridge->setTurn(true);
                            }
                            
                            //知道誰吃到那墩可以進而計算分數 自己或隊友(+2)
                            if(myturnid==call_or_play_turn||(myturnid+2)%4==call_or_play_turn)
                                ourScore_number++;
                            //若不是 則是敵方吃到 敵方分數++
                            else
                                enemyScore_number++;
                            //當輪結束將OpenGL裡的現在花色設為-1(OpenGL裡尚未有設定的意思為-1)
                            playingBridge->setNowFlower(-1);
                            
                            
                            //將更新的分數傳到GUI裡
                            emit setOurScore(ourScore_number);
                            emit setEnemyScore(enemyScore_number);
                            
                            //設定OpenGL的table值
                            playingBridge->setTable(table);
                        }   break;
                            
                        case PLAY_GAME_OVER: //遊戲結束狀態
                        {
                            //結束對Server的連線
                            socket->close();
                            
                            //將最後一輪誰吃到的墩  加到分數裡
                            
                            if(myturnid==call_or_play_turn||(myturnid+2)%4==call_or_play_turn)
                                ourScore_number++;
                            else
                                enemyScore_number++;
                            
                            //更新的分數傳到GUI裡
                            emit setOurScore(ourScore_number);
                            emit setEnemyScore(enemyScore_number);
                            
                            
                            QString final;
                            //看Client是贏是輸 放進final字串裡
                            if (ourScore_number>=win_number) {
                                final = " You Win...";
                            }
                            else
                            {
                                final = " You Lose...";
                            }
                            
                            //yes or no 視窗
                            QMessageBox message(QMessageBox::NoIcon, "Again ???",
                                                "<b>" + final + "</b><br><br> <b>Again ???</b>", QMessageBox::Yes | QMessageBox::No , 0);
                            
                            //若回傳視窗的值是yes
                            if(message.exec() == QMessageBox::Yes) {
                                //重新對Server連線  連線成功時會自動跳到waitingPage
                                //因為會呼叫到connected()
                                socket->connectToHost(serverLineEdit->text(), 4200);
                                //將狀態設為waiting
                                now_Stage=waiting;
                                
                                //將Show Now Poker裡的值清掉 方便新的一局紀錄
                                for(int i=0;i<4;++i)
                                {
                                    SNPcall_userEdit[i].clear();
                                    SNPplay_userEdit[i].clear();
                                }
                                //把callPage裡的button都重新設為可按
                                for(int i=0;i<POKER_CALL_BUTTON_NUMBER;++i)
                                    callbutton[i]->setEnabled(1);
                                //重設各值為0
                                trump=0;
                                ourScore_number=0;
                                enemyScore_number=0;
                                //清掉系統訊息與聊天訊息與連線者名單 新的一局#$%#@%@
                                systemEdit->clear();
                                roomTextEdit->clear();
                                userName.clear();
                                //將分數都重設為0
                                ourScore->display(0);
                                enemyScore->display(0);
                                //OpenGL在play也有用到很多值 需要重設
                                playingBridge->again();
                            }
                        }   break;
                            
                        default:
                            break;
                    }
                }
            }
        }
		// Is this a normal chat message:
        else if(messageRegex.indexIn(line) != -1)
        {
            // If so, append this message to our chat box:
            QString user = messageRegex.cap(1);
            QString message = messageRegex.cap(2);
            
            roomTextEdit->append("<b>" + user + "</b>: " + message);
        }
    }
}

// This function gets called when our socket has successfully connected to the chat
// server. (see the connect() call in the MainWindow constructor).
void MainWindow::connected()
{
    stackedWidget->setCurrentWidget(secondFrame);
    stackedWidget2->setCurrentWidget(waitingPage);

    // for debug
//    stackedWidget2->setCurrentWidget(callingPage);
//    stackedWidget2->setCurrentWidget(playingPage);
    
    // And send our username to the chat server.
    socket->write(QString("/me:" + userLineEdit->text() + "\n").toUtf8());
}
void MainWindow::showAllPoker()
{
    QGridLayout *gridLayout = new QGridLayout();
    
    QLabel *showAllPokerLabel = new QLabel();
    showAllPokerLabel->resize(380, 520);
    gridLayout->addWidget(SNP_user0, 0, 0);
    gridLayout->addWidget(SNP_user1, 0, 1);
    gridLayout->addWidget(SNP_user2, 0, 2);
    gridLayout->addWidget(SNP_user3, 0, 3);
    gridLayout->addWidget(&SNPcall_userEdit[0], 1, 0);
    gridLayout->addWidget(&SNPcall_userEdit[1], 1, 1);
    gridLayout->addWidget(&SNPcall_userEdit[2], 1, 2);
    gridLayout->addWidget(&SNPcall_userEdit[3], 1, 3);
    gridLayout->addWidget(&SNPplay_userEdit[0], 2, 0);
    gridLayout->addWidget(&SNPplay_userEdit[1], 2, 1);
    gridLayout->addWidget(&SNPplay_userEdit[2], 2, 2);
    gridLayout->addWidget(&SNPplay_userEdit[3], 2, 3);
    
    showAllPokerLabel->setLayout(gridLayout);
	showAllPokerLabel->show();
}

void MainWindow::callingsend_slot(int message)
{
    //roomTextEdit->append(QString::number( callpoker ));
    
    if(myturnid==call_or_play_turn)
    {
        QStringList send;
        send<<QString::number(myturnid,10)<<QString::number(message,10);
        
        socket->write(QString("/system:" +tr("callcall")+":" +send.join(",")+"\n").toUtf8());
    }
}
void MainWindow::catchInformation(int poker)
{
    QStringList send;
    send<<QString::number(myturnid,10)<<QString::number(poker,10);
    //std::cout<<myturnid<<" "<<poker<<std::endl;
    socket->write(QString("/system:" +tr("playplay")+":" +send.join(",")+"\n").toUtf8());
}

void MainWindow::callButtonClick() {

    for (unsigned int i=0; i<POKER_CALL_BUTTON_NUMBER; ++i) {
        if ( callbutton[i] == sender() ) {
            callpoker = i;
            emit callingsend_slot(callpoker);
//            printf("%d\n",callpoker);
            break;
        }
    }
}

void MainWindow::button_pass()
{
    callpoker=-1;
    emit callingsend_signal(callpoker);
}
