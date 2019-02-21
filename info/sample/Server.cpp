#include "BridgeServer.h"
#include <QThread>

int randInt(int low, int high)
{
    // Random number between low and high
    return qrand() % ((high + 1) - low) + low;
}
int compare (const void * a, const void * b)
{
  return ( *(int*)a - *(int*)b );
}

BridgeServer::BridgeServer(QObject *parent) : QTcpServer(parent)
{
    //記錄將連線名單傳送給client端了沒!!  初始化為false
	sendUser=false;
    //第幾輪 先設為0
    round=0;
    //還沒喊王 先設-1
	trump=-1;
    //sleep()會讓某些值繼續加 所以多這個變數控制 (try and error結論 詳細尚待了解)
    sleep_time=2;
    
    //回合初始化為1
	call_or_play_bout=1;
    //初始化牌 1~52
    for (int i=1; i<=52; ++i) {
        card[i-1]=i;
    }
    //初始化誰先喊哪個花色
    for (int i=0; i<7; ++i) {
        trump_type_who_call_fast[i]=-1;
    }
	//初始化table
    for (int i=0; i<4; ++i) {
        table[i]=-1;
    }
    QTime time = QTime::currentTime();
	qsrand((uint)time.msec());
}

void BridgeServer::startServer(){

	this->listen(QHostAddress::Any, 4200);
	QString ipAddress;
	QList<QHostAddress> ipAddressesList = QNetworkInterface::allAddresses();
    // use the first non-localhost IPv4 address
    for (int i = 0; i < ipAddressesList.size(); ++i) {
        if (ipAddressesList.at(i) != QHostAddress::LocalHost &&
            ipAddressesList.at(i).toIPv4Address()) {
            ipAddress = ipAddressesList.at(i).toString();
            break;
        }
    }
    // if we did not find one, use IPv4 localhost
    if (ipAddress.isEmpty())
        ipAddress = QHostAddress(QHostAddress::LocalHost).toString();

	QString serverMessage=tr("Ready ")+ipAddress;
    
    now_Stage=waiting;
	
	emit changeMessage(serverMessage);
}

//當有連線者連入
void BridgeServer::incomingConnection(qintptr socketId){
//void BridgeServer::incomingConnection(int socketfd) {
    QTcpSocket *client = new QTcpSocket(this);
//    client->setSocketDescriptor(socketfd);
    client->setSocketDescriptor(socketId);
    
    //若所有連線數小於4
	if(clients.count()<4)
	{
	    clients.insert(client);
        //回傳還要等待幾個人  4-(連線數)=需要等的人數
		QString people= QString::number((4-clients.count()),10);
        
        //回傳Server訊息給GUI
	    QString serverMessage = tr("New client from:")+client->peerAddress().toString();

        //傳給目前有連線的client端
		foreach(QTcpSocket *client, clients)
		{
            //尚未滿則......."/system:waiting "等待人數" people
			if(clients.count()<4)
				client->write(QString("/system:" +tr("waiting")+":" +people+tr(" people")+"\n").toUtf8());
			else
            {
                //滿四人則將server改成calling階段 並對client發出change訊息
                now_Stage=calling;
                client->write(QString("/system:" +tr("change_callPage")+":" +tr("")+"\n").toUtf8());
            }
		}
        //connect QTcpSocket 所發出的SIGNAL 給server SLOT接收 (readyRead,disconnected)
		connect(client, SIGNAL(readyRead()), this, SLOT(readyRead()));
		connect(client, SIGNAL(disconnected()), this, SLOT(disconnected()));

        
        emit changeMessage(serverMessage);
    }
	else
	{
		client->write(QString(tr("Server") + ":" + tr("Full") + "\n").toUtf8());
	
	}
	
}
void BridgeServer::readyRead()
{
    QTcpSocket *client = (QTcpSocket*)sender();
	QString serverMessage;
    while(client->canReadLine())
    {
        QString line = QString::fromUtf8(client->readLine()).trimmed();
        serverMessage= tr("Read line:")+line;

        QRegExp meRegex("^/me:(.*)$");
        QRegExp fullRegex("^/system:(.*):(.*)$");

        if(fullRegex.indexIn(line) != -1)
        {
            QString use = fullRegex.cap(1);
            QStringList message = fullRegex.cap(2).split(",");
            
            if(use=="callcall")
            {   //這裡的call_or_play_bout 主要是記錄連續pass的幾次
				int nowcall=message[1].toInt();
				int lastuser=message[0].toInt(),nextuser;
                //尚未有人開始喊牌且四方都pass
				if(trump==-1&&call_or_play_bout==4)
				{
                    //rand下一個喊牌是誰
					nextuser =  randInt(0,3);
                    //將回合重設為1
					call_or_play_bout=1;
				}
                //喊牌成立!!! 先前已有喊王牌&&回合數到了第三次&&第四次的人喊了pass 喊牌成立
				else if(trump!=-1&&call_or_play_bout==3&&nowcall==-1)
				{
					 now_Stage=playing;
                    //VXXO V = lastuser XX = trump  O = who call first
                    int temp=lastuser*1000+trump*10+trump_type_who_call_fast[trump%7];
                 
					 foreach(QTcpSocket *client, clients)
					 client->write(QString("/system:" +tr("change_playPage")+":" +QString::number(temp)+"\n").toUtf8());
                    //將回合初始化為1 因為play階段也要用到
                    call_or_play_bout=1;
                    
                    //sleep在play階段用到  在進入play階段再重設sleep_time=2
                    //為何不再斷線那重設 或許是因為client分別重連 會造成sleep_time誤加
                    sleep_time=2;
                    round=0;
					//change!!!!!
				}
                //大家輪流喊牌
				else
				{
                    //若是pass則回合數加一
					if(nowcall==-1)
					{	
						call_or_play_bout++;
					}
                    //若有人接續喊上去
					else 
					{
                        //將回合重設為0
						call_or_play_bout=1;
                        
                        //若trump還沒被喊過
                         if(trump_type_who_call_fast[nowcall%7]==-1)
                            //則將首喊的玩家id記錄到陣列裡
                            trump_type_who_call_fast[nowcall%7]=lastuser;
						
                        //將目前的王 放到trump裡
                        trump = nowcall;
					}
					//下一個喊牌的人
					nextuser = (lastuser+1)%4;
				}
                //數字轉換為字串 方便傳輸
				message[0]=QString::number(nextuser,10);	
		
                foreach(QTcpSocket *client, clients)
                client->write(QString("/system:" +tr("callcall")+":" +message.join(",")+"\n").toUtf8());
            }
            else if(use=="playplay")
            {   //這裡的call_or_play_bout 主要是記錄出牌到第幾次
                int last_poker=message[1].toInt();
				int lastuser=message[0].toInt(),nextuser;
                
                //原本到4就該進來 可是為了將第四次的結果傳給所有client端 所以5才是每一輪的結束
                if(call_or_play_bout==5)
                {
                    //每輪結束 round++
                    round++;
                    
                    //Server暫停2秒 讓client可以看到那墩是哪一張牌吃到
                    QThread::sleep(2);
                    
                    int nextuser;
                    nextuser = judge(); //看當輪誰吃到此墩  因為table跟trump跟flower都是class的member value 所以不用傳值
                 
                    //到13輪代表牌都打完了 進入判別勝負階段並.....
                    if(round==13)
                    {
                        //type=3 代表要傳給client的代號 3 = 結束
                        int type=3;
                        // XO   X = type   O = 最後那墩誰吃到  
                        message[0]=QString::number((type*10)+nextuser,10);
                        
                        foreach(QTcpSocket *client, clients)
                        client->write(QString("/system:" +tr("playplay")+":" +message.join(",")+"\n").toUtf8());
                        
                        //重設部分所有值 以便下次牌局開始所使用
                        trump=-1;
                        sleep_time=2;
                        
                        now_Stage=waiting;
                        round=0;
                        sendUser=false;
                        users.clear();
                        clients.clear();
                        for (int i=0; i<7; ++i) {
                            trump_type_who_call_fast[i]=-1;
                        }
                        for (int i=0; i<4; ++i) {
                            table[i]=-1;
                        }
                    }
                    else
                    {   //type=2 代表當輪結束  將誰吃那墩的訊息傳送給client端知道
                        int type=2;
                        
                        message[0]=QString::number((type*10)+nextuser,10);
                        
                        foreach(QTcpSocket *client, clients)
                        client->write(QString("/system:" +tr("playplay")+":" +message.join(",")+"\n").toUtf8());
                        
                        //結束當輪後 將sleep_time設為-1 call_or_play_bout設為1 (因為是新的一輪)
                        sleep_time=-1;
                        call_or_play_bout=1;
                    }
                }
                else if(sleep_time<2) //sleep()的關係  
                    sleep_time++;
                //正常出牌狀態
                else if (call_or_play_bout<5) {
                    //將lastuser所打的牌(last_poker)放到table裡
                    table[lastuser]=last_poker;
                    //下一個出牌者 似乎不用多一個變數 不想優化了 XD
                    nextuser=(lastuser+1)%4;
                    
                    //type=0 代表正常出牌狀態
                    int type=0;
                    //本輪第四次
                    if(call_or_play_bout==4)
                    {   //type=1 代表只是要將第四次出牌的結果通知所有client端
                        type=1;
                    }
                    //若是第一回合 則紀錄當輪的花色是什麼
                    if(call_or_play_bout==1)
                        flower = (last_poker-1)/13;
                  
                    //XXOV XX last_poker O type V nextuser
                    message[0]=QString::number((last_poker*100)+(type*10)+nextuser,10);
                   
                    foreach(QTcpSocket *client, clients)
                    client->write(QString("/system:" +tr("playplay")+":" +message.join(",")+"\n").toUtf8());
                   
                    //結束後回合++
                    call_or_play_bout++;
                }
            }
        }
        else if(meRegex.indexIn(line) != -1)
        {
            QString user = meRegex.cap(1);
            users[client] = user;
            foreach(QTcpSocket *client, clients)
                client->write(QString("Server:" + user + " has joined.\n").toUtf8());
            sendUserList();
        }
        else if(users.contains(client))
        {
            QString message = line;
            QString user = users[client];

            foreach(QTcpSocket *otherClient, clients)
			{
                otherClient->write(QString(user + ":" + message + "\n").toUtf8());
			}
        }
        else
        {
            qWarning() << "Got bad message from client:" << client->peerAddress().toString() << line;
        }
		emit changeMessage(serverMessage);
    }
}

void BridgeServer::disconnected()
{
    QTcpSocket *client = (QTcpSocket*)sender();
    QString serverMessage = tr("Client disconnected:")+client->peerAddress().toString();

    clients.remove(client);

    QString user = users[client];
    users.remove(client);
    
    sendUserList();
    foreach(QTcpSocket *client, clients)
    client->write(QString("Server:" + user + " has left.\n").toUtf8());
	emit changeMessage(serverMessage);
    
    //若是在叫牌階段或玩牌階段則初始化所有值 並將剩餘連線中的玩家也踢掉
    //因為在這兩個階段 有一位玩家斷線則無法繼續遊戲
    if(now_Stage==calling||now_Stage==playing)
    {
        trump=-1;
        sleep_time=2;
    
        now_Stage=waiting;
        round=0;
        sendUser=false;
        users.clear();
        clients.clear();
        for (int i=0; i<7; ++i) {
            trump_type_who_call_fast[i]=-1;
        }
        for (int i=0; i<4; ++i) {
            table[i]=-1;
        }
    }
}

void BridgeServer::sendUserList()
{
    QStringList userList;
    foreach(QString user, users.values())
        userList << user;
    
    //當連線者為4且還未給連線者名單時....
    if (!sendUser&&userList.count()==4) {
        
        QStringList userListCard[4];
        //洗兩次牌 因為洗一次好像不怎麼乾淨
        deal_Four();
        deal_Four();
        for (int i=0; i<52; ++i) {
            //將牌放到QString裡
            userListCard[i/13]<<QString::number(card[i]);
        }
        
        foreach(QTcpSocket *client, clients)
        client->write(QString("/system:" +tr("users")+":" + userList.join(",") +"\n").toUtf8());
        
        for (int i=0; i<4; ++i) {
            foreach(QTcpSocket *client, clients)
            client->write(QString("/system:" +userList[i]+":" + userListCard[i].join(",") +"\n").toUtf8());
        }
        //初始化輪到誰
        call_or_play_bout=1;
        
        //紀錄已經發牌了
        sendUser=true;
    }

    foreach(QTcpSocket *client, clients)
        client->write(QString("/users:" + userList.join(",") + "\n").toUtf8());
}
void BridgeServer::deal_Four()
{
	int temp,j;
	//洗牌
	for(int i=0;i<52;++i)
	{
		j =  randInt(0,51);
		temp = card[i];
		card[i] = card[j];
		card[j] = temp;
	}

	//poker_sort 不用另外要記憶體 把0~12 13~25 26~38 39~52的位置當作是已發給玩家的牌
	for(int i=0;i<4;++i)
	{
		int *head=&card[i*13];

		qsort(head,13,sizeof(int),compare);
	}
}
//判斷當局誰吃到的函式
int BridgeServer::judge()
{
    //1~13 D  14~26 C 27~39 H 40~52 S
    // type=0 small type=1 middle type=2 C type=3 D type=4 H type=5 S type=6 NoTrump
    //flower<<" SA"<<" MD"<<" ♣(C)"<<" ♦(D)"<<" ♥(H)"<<" ♠(S)"<<" NT";
    int type = trump%7,save_true=0;
    bool compare_type[4];
    for (int i=0; i<4; ++i) compare_type[i]=false;
    int max=0,max_number=-1;
    
    if(type>1&&type<6)   //four flower
    {
        //為了讓牌有紅黑紅黑錯開 所以我在檔案調動了club && diamond的位置
        //可是現實是club<diamond 所以要調回來
        //好像可以不用那麼"搞甘" 不過懶的優化了
        
        //撲克牌這樣排序 ♦(D) ♣(C) ♥(H) ♠(S)
       
        //type-2 直接從D開始 可是還要轉換D-C
        int C_D_change_type = type-2;
        
        //其實好像不需要轉換也人比 可是懶得改了
        if (C_D_change_type == 0) C_D_change_type = 1;
        else if (C_D_change_type == 1) C_D_change_type = 0;
        
        
        for (int i=0; i<4; ++i) {
            ////because K = 13 26 39 52  so we have to -1
            if ((table[i]-1)/13==C_D_change_type) {
                //看那四張牌是不是有跟目前的王牌一樣
                //記錄是哪個位置跟王牌一樣
                compare_type[i]=true;
                //並加加
                save_true++;
            }
        }
        //都不是王牌的話就是....
        if(save_true==0){ //無王狀態下
            
            for (int i=0; i<4; ++i) {
                //若是A(1,14,27,40)且有跟當輪flower一樣 直接把值+13塞到max
                if((table[i]==1||table[i]==14||table[i]==27||table[i]==40)&&(table[i]-1)/13==flower)
                {
                    //好像直接把i值塞到max_number就可以 可是懶得改
                    max=table[i]+13;  max_number=i;
                }
                //若花色一樣且數字比max大  就一樣那樣 你知道的
                if((table[i]-1)/13==flower&&table[i]>max)
                {
                    max=table[i]; max_number=i;
                }
            }
        }
        else
        {
            for(int i=0;i<4;++i)
            {   //有王的狀態 直接看是哪一個有王  再進行比大小 (看有沒有王 就不用再比花色了)
                if(compare_type[i])
                {
                    if((table[i]==1||table[i]==14||table[i]==27||table[i]==40))
                    {
                        max=table[i]+13;  max_number=i;
                    }
                    else if (table[i]>max)
                    {
                        max=table[i];   max_number=i;
                    }
                }
            }
        }
    }
    else if(type==6) //No Trump
    {
        //若是A(1,14,27,40)且有跟當輪flower一樣 直接把值+13塞到max
        for (int i=0; i<4; ++i) {
            
            if((table[i]==1||table[i]==14||table[i]==27||table[i]==40)&&(table[i]-1)/13==flower)
            {
                max=table[i]+13;  max_number=i;
            }
            if((table[i]-1)/13==flower&&table[i]>max)
            {
                max=table[i]; max_number=i;
            }
        }
    }
    else if(type==1) //middle
    {
        for (int i=0; i<4; ++i) {
            //先看花色之後將牌的數字轉換成middle的權重後放到change_number 有較大再塞入max
            if((table[i]-1)/13==flower)
            {
                int change_number;
                switch (table[i]%13) {
                    case 7:
                        change_number=13;
                        break;
                    case 6:
                        change_number=12;
                        break;
                    case 8:
                        change_number=11;
                        break;
                    case 5:
                        change_number=10;
                        break;
                    case 9:
                        change_number=9;
                        break;
                    case 4:
                        change_number=8;
                        break;
                    case 10:
                        change_number=7;
                        break;
                    case 3:
                        change_number=6;
                        break;
                    case 11:
                        change_number=5;
                        break;
                    case 2:
                        change_number=4;
                        break;
                    case 12:
                        change_number=3;
                        break;
                    case 1:
                        change_number=2;
                        break;
                    case 13:
                    case 0:
                        change_number=1;
                        break;
                }
                if( change_number > max )
                {
                    max=change_number;  max_number=i;
                }
            }
        }
    }
    else//small
    {
        for (int i=0; i<4; ++i) {
            //直接看誰最小 max初值為0 所以會直接進去
            if((table[i]-1)/13==flower&&(table[i]<max||max==0))
            {
                max=table[i]; max_number=i;
            }
        }
    }
    
    return max_number;
}
