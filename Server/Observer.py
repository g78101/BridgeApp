#coding=utf8

from websocket_server import WebsocketServer
import logging
import threading
import Type
import time
import pytz, datetime

Trumps = [" SA"," MD"," C"," D"," H"," S"," NT"]
Flowers = ["♦(D)","♣(C)","♥(H)","♠(S)"]
Numbers = ["A","2","3","4","5","6","7","8","9","10","J","Q","K"]

def showPokerStr(poker):
    return (" %s-%s,")%(Numbers[(poker-1)%13],Flowers[(poker-1)/13])

class S():

    def __init__(self):

        self.players = [""] * 4
        self.callsRecord = [""] * 4
        self.callsRaw = [""] * 4
        self.threeModeUsers = [""] * 4
        self.playsRecord = [""] * 4
        self.playsRaw = [""] * 4
        self.boutsWinRecord = []
        self.flowerCountRecord = [0] * 4
        self.playsPokerHand = [[] for i in range(4)]
        self.threeModeIndex = [-1] * 4

        self.trump = 'Waiting'
        self.trumpRaw = -1
        self.attackIndex = [-1] * 2
        self.attackWinNumber = 7
        self.attackTeam = ''
        self.attackScore = 0
        self.defenseTeam = ''
        self.defenseScore = 0
        self.threeMode = False

    def getUpdateInfo(self):

        # trump^{info}^{Name}^{call}^{three}^{play}^{card}

        info = ""
        if self.attackTeam!="":
            info = self.attackTeam + "|" + ("%d / %d")%(self.attackScore,self.attackWinNumber) + "|" + self.defenseTeam + "|" + ("%d / %d")%(self.defenseScore,14-self.attackWinNumber)
        name = ""
        for player in self.players:
            name += player + "|"
        name = name[:-1]
        call = ""
        subCalls = [[],[],[],[]]
        for index in range(4):
            subCalls[index] = self.callsRaw[index].split('^')
        count=0;index=0;length=0
        while 1:
            subCall = subCalls[index]
            str = ""
            if length < len(subCall) and subCall[length]!="":
                str = subCall[length]
            elif(subCalls[index]!=""):
                count+=1
                subCalls[index]=""
            if count == 4:
                break
            call += str + ","
            if index+1 == 4:
                index = 0
                length += 1
                call = call[:-1]
                call += "|"
            else:
                index += 1
        call = call[:-1]
        three = ""
        for player in self.threeModeUsers:
            three += player + "|"
        three = three[:-1]
        play = ""
        subPlays = [[],[],[],[]]
        for index in range(4):
            subPlays[index] = self.playsRaw[index].split('^')
        count=0;index=0;length=0
        while 1:
            subPlay = subPlays[index]
            str = ""
            if length < len(subPlay):
                str = subPlay[length]
            if count == 13:
                break
            play += str + ","
            if index+1 == 4:
                index = 0
                length += 1
                count += 1
                play = play[:-1]
                play += "|"
            else:
                index += 1
        play = play[:-1]
        winBount = ""
        for bouts in self.boutsWinRecord:
            winBount += ("%d|")%bouts
        winBount = winBount[:-1]
        flower = ""
        for index in range(4):
            flower += ("%d|")%self.flowerCountRecord[index]
        flower = flower[:-1]
        card = ""
        if self.players[0]!="":
            for index in range(4):
                str = ""
                for poker in self.playsPokerHand[index]:
                    str += ("%d,")%poker
                card += str[:-1] + "|"
        card = card[:-1]
        return ("%d")%self.trumpRaw + "^" + info + "^" + name + "^" + call + "^" + three + "^" + play + "^" + winBount + "^"+ flower + "^" +card

class WebSocket:
    def __init__(self):
        self.server = None
        self.S = None

    # Called for every client connecting (after handshake)
    def new_client(self,client, server):
        #print("New client connected and was given id %d" % client['id'])
        str = self.S.getUpdateInfo()
        server.send_message(client,str)

    # Called for every client disconnecting
    def client_left(self,client, server):
        #print("Client(%d) disconnected" % client['id'])
        pass

    def start(self):
        port=3344
        self.S = S()
        self.server = WebsocketServer(port,host='0.0.0.0',loglevel=logging.CRITICAL)
        self.server.set_fn_new_client(self.new_client)
        self.server.set_fn_client_left(self.client_left)
        server_thread = threading.Thread(target=self.server.run_forever)
        server_thread.start()

    def stop(self):
        self.server.server_close()

    def reset(self):

        self.S.players = [""] * 4
        self.S.callsRecord = [""] * 4
        self.S.callsRaw = [""] * 4
        self.S.threeModeUsers = [""] * 4
        self.S.playsRecord = [""] * 4
        self.S.playsRaw = [""] * 4
        self.S.boutsWinRecord = []
        self.S.flowerCountRecord = [0] * 4
        self.S.playsPokerHand = [[] for i in range(4)]
        self.S.threeModeIndex = [-1] * 4

        self.S.trump = 'Waiting'
        self.S.trumpRaw = -1
        self.S.attackIndex = [-1] * 2
        self.S.attackWinNumber = 7
        self.S.attackTeam = ''
        self.S.attackScore = 0
        self.S.defenseTeam = ''
        self.S.defenseScore = 0
        self.S.threeMode = False

    def setPlayers(self,str):
        self.S.players = str.split(',')
        self.server.send_message_to_all(self.S.getUpdateInfo())

    def setThreeModePlayers(self,str):
        self.S.threeModeUsers = str.split(',')

    def setThreeModeIndex(self,list):
        self.S.threeModeIndex = list

    def setPlayersPoker(self,index,cards):
        cardArray = cards.split(',')
        for card in cardArray:
            self.S.playsPokerHand[index].append(int(card))
        self.server.send_message_to_all(self.S.getUpdateInfo())

    def updateContent(self,str):
        connectState = str[0:1]
        info = str[1:]
        # print connectState,info
        if connectState == "S":
            splitArray = info.split(',')
            trump = int(splitArray[1])
            lastUser = int(splitArray[3])

            self.S.trump = ("%d%s")%(trump/7+1,Trumps[trump%7])
            self.S.trumpRaw = trump
            self.S.attackWinNumber = (trump/7+7)

            if self.S.threeMode:
                self.S.attackIndex[0] = 0
                self.S.attackIndex[1] = 2
            else:
                self.S.attackIndex[0] = (lastUser+1)%4
                self.S.attackIndex[1] = (lastUser+3)%4

            attackTeam = ''
            defenseTeam = ''

            for i in range(0,4):
                player = self.S.players[i]
                if self.S.threeMode:
                    player = self.S.threeModeUsers[i]
                if i in self.S.attackIndex:
                    attackTeam = attackTeam + player + ' , '
                else:
                    defenseTeam = defenseTeam + player + ' , '
            self.S.attackTeam = attackTeam[0:len(attackTeam)-3]
            self.S.defenseTeam = defenseTeam[0:len(defenseTeam)-3]

        elif connectState == "T":
            self.S.threeMode = True
        elif connectState == "C":
            splitArray = info.split(',')
            lastUser = int(splitArray[0])
            trump = int(splitArray[2])
            updateRecord = self.S.callsRecord[lastUser]
            updateRaw = self.S.callsRaw[lastUser]
            if trump != -1:
                tempStr = ("%d%s,")%((trump/7)+1,Trumps[trump%7])
            else:
                tempStr = "Pass,"
            self.S.callsRecord[lastUser] = updateRecord + tempStr
            self.S.callsRaw[lastUser] = updateRaw + ("%d^")%trump

        elif connectState == "P":
            splitArray = info.split(',')
            nextUser = int(splitArray[2])
            lastUser = (nextUser+4-1)%4
            poker = int(splitArray[0])
            playState = Type.PlayState(int(splitArray[1]))
            
            if poker != 0:
                removeIndex = lastUser
                updateRecord = self.S.playsRecord[lastUser]
                updateRaw = self.S.playsRaw[lastUser]
                tempStr = showPokerStr(poker)
                self.S.playsRecord[lastUser] = updateRecord + tempStr
                self.S.playsRaw[lastUser] = updateRaw + ("%d^")%poker
                flower = int((poker-1)/13)
                self.S.flowerCountRecord[flower] += 1;
                if self.S.threeMode:
                    removeIndex = self.S.threeModeIndex[lastUser]
                self.S.playsPokerHand[removeIndex].remove(poker)
            else:
                if nextUser in self.S.attackIndex:
                    self.S.attackScore += 1
                else:
                    self.S.defenseScore += 1

                self.S.boutsWinRecord.append(nextUser)
                if poker != 0:
                    flower = int((poker-1)/13)
                    self.S.flowerCountRecord[flower] += 1;
                
                for index in range(4):
                    tempStr = self.S.playsRecord[index]
                    tempStr = tempStr[:-1]
                    if index == nextUser:
                        tempStr+= "✓,"
                    else:
                        tempStr+= "✗,"
                    self.S.playsRecord[index] = tempStr
            
            if playState == Type.PlayState.GameOver:
                self.recordCSV()
                self.saveShowRecord()
        
        self.server.send_message_to_all(self.S.getUpdateInfo())

    def recordCSV(self):
        #{time},{trump},{threeMode},{name},{call},{play},{threeName}
        file = open('record.csv',"a+")

        timeStr = time.strftime("%Y-%m-%d %H:%M", time.localtime()) 

        trumpStr = self.S.trump

        nameStr = ""
        for player in self.S.players:
            nameStr += player + "|" 
        nameStr = nameStr[:-1]

        callStr = ""
        for callRaw in self.S.callsRaw:
            callStr += callRaw[0:-1] + "|"
        callStr = callStr[:-1]

        playStr = ""
        for playRaw in self.S.playsRaw:
            playStr += playRaw[0:-1] + "|"
        playStr = playStr[:-1]

        threeStr = ""
        if self.S.threeModeUsers[0]!="":
            for player in self.S.threeModeUsers:
                threeStr += player + "|"
            threeStr = threeStr[:-1]

        file.write("%s,%s,%s,%s,%s,%s\n"%(timeStr,trumpStr,nameStr,callStr,playStr,threeStr))
        file.close()

    def saveShowRecord(self):
        #{time},{trump},{name},{call},{threeName},{play}
        file = open('/var/www/html/data/showRecord.csv',"a+")

        local = pytz.timezone ("Etc/GMT+8")
        naive = datetime.datetime.now()
        local_dt = local.localize(naive, is_dst=None)
        utc_dt = local_dt.astimezone(pytz.utc)
        timeStr = utc_dt.strftime('%Y-%m-%d %H:%M')
        
        winFlag = "✓"
        if(self.S.attackScore<self.S.attackWinNumber):
            winFlag = "✗"
        trumpStr = ("%s %s %d:%d")%(self.S.trump,winFlag,self.S.attackScore,self.S.defenseScore)
        
        nameStr = ""
        for player in self.S.players:
            nameStr += player + "|" 
        nameStr = nameStr[:-1]
        
        callStr = ""
        subCalls = [[],[],[],[]]
        for index in range(4):
            subCalls[index] = self.S.callsRecord[index].split(',')
        count=0;index=0;length=0
        while 1:
            subCall = subCalls[index]
            str = ""
            if length < len(subCall) and subCall[length]!="":
                str = subCall[length]
            elif(subCalls[index]!=""):
                count+=1
                subCalls[index]=""
            
            if count == 4:
                break
            callStr += str + " - "
            if index+1 == 4:
                index = 0
                length += 1
                callStr = callStr[:-2]
                callStr += "|"
            else:
                index += 1
        callStr = callStr[:-1]
        
        threeStr = ""
        if self.S.threeModeUsers[0]!="":
            for player in self.S.threeModeUsers:
                threeStr += player + "|"
            threeStr = threeStr[:-1]
        
        playStr = ""
        subPlays = [[],[],[],[]]
        for index in range(4):
            subPlays[index] = self.S.playsRecord[index].split(',')
        for i in range(13):
            for j in range(4):
                subPlay = subPlays[j]
                str = subPlay[i]
                playStr += str + " | "
            playStr = playStr[:-2]
            playStr += ","
        playStr = playStr[:-1]
        file.write("%s,%s,%s,%s,%s,%s\n"%(timeStr,trumpStr,nameStr,callStr,threeStr,playStr))
        file.close()
