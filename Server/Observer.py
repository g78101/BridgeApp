#coding=utf8

from websocket_server import WebsocketServer
import logging
import threading
import Room
import Type
import time
import pytz, datetime    

class WebSocket:
    def __init__(self):
        self.server = None
        self.rooms = None
        self.debugMode = False

    # Called for every client connecting (after handshake)
    def new_client(self,client, server):
        print("New client connected and was given id %d" % client['id'])

        if self.rooms == None or len(self.rooms) == 0:
            server.send_message(client,"0")
        else:
            messageStr = self.getUpdateInfo(self.rooms[0])
            server.send_message(client,messageStr)
        pass

    # Called for every client disconnecting
    def client_left(self,client, server):
        # print("Client(%d) disconnected" % client['id'])
        print("Client disconnected")
        pass

    # Called when a client sends a message
    def message_received(self,client, server, message):
        if len(message) > 200:
            message = message[:200]+'..'
        print("Client(%d) said: %s" % (client['id'], message))
        if message == "debug":
            self.debugMode = True
        elif message == "normal":
            self.debugMode = False

        print client
        # server.send_message(client,"Test")

    def start(self):
        port=3344
        self.server = WebsocketServer(port,host='0.0.0.0')
        self.server.set_fn_new_client(self.new_client)
        self.server.set_fn_client_left(self.client_left)
        self.server.set_fn_message_received(self.message_received)
        server_thread = threading.Thread(target=self.server.run_forever)
        server_thread.start()

    def stop(self):
        self.server.server_close()

    def updateContent(self,Rooms,roomIndex):
        self.rooms=Rooms
        messageStr = self.getUpdateInfo(Rooms[roomIndex])
        self.server.send_message_to_all(messageStr)

    def getUpdateInfo(self,room):
        # trump^{info}^{Name}^{call}^{three}^{play}^{card}
        info = ""
        if room.attackTeam!="":
            info = room.attackTeam + "|" + ("%d / %d")%(room.attackScore,room.attackWinNumber) + "|" + room.defenseTeam + "|" + ("%d / %d")%(room.defenseScore,14-room.attackWinNumber)
        name = ""
        for user in room.users:
            name += user.name + "|"
        name = name[:-1]
        call = ""
        subCalls = [[],[],[],[]]
        for index in range(4):
            subCalls[index] = room.callsRaw[index].split('^')
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
        for player in room.threeModeUsers:
            three += player + "|"
        three = three[:-1]
        play = ""
        subPlays = [[],[],[],[]]
        for index in range(4):
            subPlays[index] = room.playsRaw[index].split('^')
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
        winBount = room.boutsWinRecord[:-1]
        flower = ""
        for index in range(4):
            flower += ("%d|")%room.flowerCountRecord[index]
        flower = flower[:-1]
        card = ""
        if room.users[0].name!="":
            for index in range(4):
                str = ""
                for poker in room.playsPokerHand[index]:
                    str += ("%d,")%poker
                card += str[:-1] + "|"
        card = card[:-1]
        return ("%d")%room.getTrump() + "^" + info + "^" + name + "^" + call + "^" + three + "^" + play + "^" + winBount + "^"+ flower + "^" +card
