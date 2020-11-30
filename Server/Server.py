#coding=utf8
 
import socket, select
import random
import Room
import Type
import Observer
import IpCheck

def sendDataToRoom (room,message):
    for user in room.users:
        try :
            if user.socket != None:
                user.socket.send(message)
            else:
                continue
        except :
            removeRoomSockets(room)
            break

def removeRoomSockets (room):
    users = room.users
    Rooms.remove(room)
    for i in range(0,len(users)):
        socket = users[i].socket
        if socket != None:
            socket.close()
            CONNECTION_LIST.remove(socket)
    room = None  

def findSocketInRoomIndex (socket):
    for i in range(0,len(Rooms)):
        room = Rooms[i]
        if room.findSocketIndex(socket) != -1:
            return i
    return -1

def sendData(str):
    return str+"\n"

def newPlayerEnterRoom(room,sock,name,uuid):
    startGame = False
    room.setUserInfo(sock,name,uuid)
    sock.send(sendData("S%d,%d"%(room.state.value,len(room.users)-1)))
    if len(room.users) < 4:
        sendDataToRoom(room,sendData("W%d,%d"%(len(room.users),room.threeModeCount)))
    elif room.isAllRead():
        users = room.getNameStr(room.users)
        sendDataToRoom(room,sendData("N%s"%users))
        room.dealingCards()
        for i in range(0,4):
            playCard = room.getPlayerCards(i)
            room.users[i].socket.send(sendData("H%s"%playCard))
        room.nextuser=random.randint(0,3)
        sendDataToRoom(room,sendData("S%d,%d,0"%(room.state.value,room.nextuser)))
        startGame = True
    return startGame    

if __name__ == "__main__":
    
    # List to keep track of socket descriptors
    CONNECTION_LIST = []
    Rooms = []
    RECV_BUFFER = 1024 # Advisable to keep it as an exponent of 2
    PORT = 8888
    MAXROOMCOUNT = 10
     
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    # this has no effect, why ?
    server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server_socket.bind(("0.0.0.0", PORT))
    server_socket.listen(50)

    # Add server socket to the list of readable connections
    CONNECTION_LIST.append(server_socket)
 
    print "Socket server started on port " + str(PORT)

    observer = Observer.WebSocket()
    observer.start()

    ipCheck = IpCheck.Manager()
    interruptList = []

    try:
      while 1:
        # Get the list sockets which are ready to be read through select
        read_sockets,write_sockets,error_sockets = select.select(CONNECTION_LIST,[],[])
        for sock in read_sockets:
            #New connection
            if sock == server_socket:
                # Handle the case in which there is a new connection recieved through server_socket
                sockfd, addr = server_socket.accept()
                if ipCheck.canConnection(addr[0]) or addr[0] == "127.0.0.1":
                    print addr
                    CONNECTION_LIST.append(sockfd)
                    sockfd.send(sendData("S%d"%(Type.RoomState.connected.value)))

                    if len(Rooms) == 0 :
                        Rooms.append(Room.PokerRoom())
                else:
                    sockfd.send("Not Connecting")
                    sockfd.close()
            #Some incoming message from a client
            else:
                # Data recieved from client, process it
                try:
                    #In Windows, sometimes when a TCP program closes abruptly,
                    # a "Connection reset by peer" exception will be thrown
                    data = sock.recv(RECV_BUFFER)
                    
                    # print("data:"+data)
                    if data:
                        if observer.debugMode:
                            print "data: "+data
                        connectState = data[0:1]
                        info = data[1:]

                        if connectState == "N":
                            infoArray = info.split(',',1)
                            name = infoArray[0]
                            uuid = infoArray[1]

                            reconnect = False
                            for index in interruptList:
                                interruptRoom = Rooms[index]
                                foundIndex = interruptRoom.findTheSameUUIDIndex(uuid)
                                if foundIndex != -1:
                                    recoverList = interruptRoom.recoverRoom(foundIndex,sock)
                                    for recoverInfo in recoverList:
                                        sock.send(sendData(recoverInfo))
                                        if observer.debugMode:
                                            userIndex = room.findSocketIndex(sock)
                                            print "Room-%d %d recoverInfo: %s"%(index, foundIndex,recoverInfo)
                                    reconnect = True
                                    sendDataToRoom(room,sendData("D1"))
                                    break
                            if reconnect == False:
                                newRoom = True
                                for room in Rooms:
                                    if room.isRoomFull() == False:
                                        if newPlayerEnterRoom(room,sock,name,uuid):
                                            observer.updateContent(Rooms,Rooms.index(room))
                                        newRoom = False
                                        break
                                if newRoom:
                                    if len(Rooms) < MAXROOMCOUNT:
                                        room = Room.PokerRoom()
                                        Rooms.append(room)
                                        if newPlayerEnterRoom(room,sock,name,uuid):
                                            observer.updateContent(Rooms,Rooms.index(room))
                                        if observer.debugMode:
                                            print "Create Another New Room-%d for %s"%(Rooms.index(room), name)
                                    else:
                                        sock.send("is Full")
                                        CONNECTION_LIST.remove(sock)
                                        sockfd.close()
                            continue

                        roomIndex = findSocketInRoomIndex(sock)
                        room = Rooms[roomIndex]
                        if connectState == "W":
                            room.threeModeCount+=1
                            if room.threeModeCount < 3:
                                sendDataToRoom(room,sendData("W%d,%d"%(len(room.users),room.threeModeCount)))
                            elif room.threeModeCount==3:
                                room.setThreeMode()
                                users = room.getNameStr(room.users)
                                sendDataToRoom(room,sendData("N%s"%users))
                                room.dealingCards()
                                for i in range(0,4):
                                    playCard = room.getPlayerCards(i)
                                    if i < 3:
                                        room.users[i].socket.send(sendData("H%s"%playCard))
                                room.nextuser=random.randint(0,2)
                                sendDataToRoom(room,sendData("S%d,%d,1"%(room.state.value,room.nextuser)))
                                observer.updateContent(Rooms,roomIndex)
                        elif connectState == "C":
                            sendStr=room.callingInfo(info)
                            sendDataToRoom(room,sendData(sendStr))
                            observer.updateContent(Rooms,roomIndex)
                            if observer.debugMode:
                                userIndex = room.findSocketIndex(sock)
                                print "Room-%d %d call: %s"%(roomIndex, userIndex,sendStr)
                        elif connectState == "T":
                            room.setNewNames(int(info))
                            users = room.getNameStr(room.threeModeUsers)
                            sendDataToRoom(room,sendData("N%s"%users))
                            playCard = room.getPlayerCards(3)
                            sendDataToRoom(room,sendData("H%s"%playCard))
                            sendStr = room.threeModeSetting()
                            sendDataToRoom(room,sendData(sendStr))
                            observer.updateContent(Rooms,roomIndex)
                            if observer.debugMode:
                                userIndex = room.findSocketIndex(sock)
                                print "Room-%d %d three: %s"%(roomIndex, userIndex,sendStr)
                        elif connectState == "P":
                            sendStr=room.playingInfo(info)
                            sendDataToRoom(room,sendData(sendStr))
                            observer.updateContent(Rooms,roomIndex)
                            if observer.debugMode:
                                userIndex = room.findSocketIndex(sock)
                                print "Room-%d %d play: %s"%(roomIndex, userIndex,sendStr)
                       
                    elif len(data) == 0:
                        # sock disconnect
                        print("sock disconnect")
                        sock.close()
                        roomIndex = findSocketInRoomIndex(sock)
                        CONNECTION_LIST.remove(sock)
                        if roomIndex == -1:
                            continue
                        room = Rooms[roomIndex]
                        room.removeSocker(sock)
                        if room.isRoomFull() == False:
                            removeRoomSockets(room)
                        else:
                            if room.checkInterruptSocketNum() > 1:
                                for i in range(0,len(interruptList)):
                                    if interruptList[i] > roomIndex:
                                        interruptList[i]-=1
                                interruptList.remove(roomIndex)
                                sendDataToRoom(room,sendData("D2"))
                                removeRoomSockets(room)
                                if observer.debugMode:
                                    print "Room-%d destroy"%(roomIndex)
                            else:
                                interruptList.append(roomIndex)
                                sendDataToRoom(room,sendData("D0"))
                                if observer.debugMode:
                                    print "Room-%d waiting player"%(roomIndex)
                 
                except:
                    continue
    except IndexError as e:
      print(type(e), str(e))
      observer.stop()
      server_socket.close()
