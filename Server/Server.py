#coding=utf8
 
import socket, select
import random
import Room
import Observer

def sendDataToRoom (room,message):
    for socket in room.sockets:
        try :
            socket.send(message)
        except :
            removeRoomSockets(room)
            break

def removeRoomSockets (room):
    sockets = room.sockets
    Rooms.remove(room)
    for i in range(0,len(sockets)):
        socket = sockets[i]
        socket.close()
        CONNECTION_LIST.remove(socket)    
    room = None  

def findSocketInRoomIndex (socket):
    for i in range(0,len(Rooms)):
        room = Rooms[i]
        if room.findSocket(socket):
            return i
    return -1

def sendData(str):
    return str+"\n"

if __name__ == "__main__":
     
    # List to keep track of socket descriptors
    CONNECTION_LIST = []
    Rooms = []
    RECV_BUFFER = 1024 # Advisable to keep it as an exponent of 2
    PORT = 9999
     
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    # this has no effect, why ?
    server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server_socket.bind(("0.0.0.0", PORT))
    server_socket.listen(10)

    # Add server socket to the list of readable connections
    CONNECTION_LIST.append(server_socket)
 
    print "Socket server started on port " + str(PORT)

    observer = Observer.HttpServer()
    observer.start()
 	
    try:
      while 1:
        # Get the list sockets which are ready to be read through select
        read_sockets,write_sockets,error_sockets = select.select(CONNECTION_LIST,[],[])
 
        for sock in read_sockets:
            #New connection
            if sock == server_socket:
                # Handle the case in which there is a new connection recieved through server_socket
                sockfd, addr = server_socket.accept()

                CONNECTION_LIST.append(sockfd)

                if len(Rooms) == 0:
                    observer.reset()
                    Rooms.append(Room.PokerRoom())

                for room in Rooms:

                    if not room.addSocket(sockfd):
                        # current only one room 
                        # newRoom = Room.PokerRoom()
                        # newRoom.addSocket(sockfd)
                        # Rooms.append(newRoom)

                        sockfd.send("is Full")
                        CONNECTION_LIST.remove(sockfd)
                        sockfd.close()
                    else:
                        try :
                            sockfd.send(sendData("S%d,%d"%(room.state.value,len(room.sockets)-1)))
                        except :
                            removeRoomSockets(room)
                        
                        # sockfd.send("S01,02,03,04,05,06,07,08,09,10,11,12,13")
            #Some incoming message from a client
            else:
                # Data recieved from client, process it
                try:
                    #In Windows, sometimes when a TCP program closes abruptly,
                    # a "Connection reset by peer" exception will be thrown
                    data = sock.recv(RECV_BUFFER)
                    room = Rooms[findSocketInRoomIndex(sock)]

                    if data:
                        connectState = data[0:1]
                        info = data[1:]

                        if connectState == "N":
                            room.setNameWithSocket(sock,info)
                            if len(room.sockets) < 4:
                                sendDataToRoom(room,sendData("M%s enter room (%d/4)"%(info,len(room.sockets))))
                            elif room.isAllRead():
                                users=""
                                for user in room.users:
                                    users+=user
                                    if user != room.users[-1]:
                                        users+=","
                                sendDataToRoom(room,sendData("N%s"%users))
                                observer.setPlayers(users)
                                room.dealingCards()
                                for i in range(0,4):
                                    playCard = room.getPlayerCards(i)
                                    room.sockets[i].send(sendData("H%s"%playCard))
                                    observer.setPlayersPoker(i,playCard)
                                sendDataToRoom(room,sendData("S%d,%d"%(room.state.value,random.randint(0,3))))
                        elif connectState == "C":
                            sendStr=room.callingInfo(info)
                            sendDataToRoom(room,sendData(sendStr))
                            observer.updateContent(sendStr)

                        elif connectState == "P":
                            sendStr=room.playingInfo(info)
                            sendDataToRoom(room,sendData(sendStr))
                            observer.updateContent(sendStr)
                       
                    elif len(data) == 0:
                        # sock disconnect
                        removeRoomSockets(room)
                 
                except:
                    continue
    except:
      observer.stop()
      server_socket.close()
