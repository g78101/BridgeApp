#coding=utf8

#The file is just for test client

import socket, select, string, sys
 
#main function
if __name__ == "__main__":
     
    if(len(sys.argv) < 2) :
       print 'Usage : name'
       sys.exit()
     
    host = "0.0.0.0"#sys.argv[1]
    port = 9999#int(sys.argv[2])
    name = sys.argv[1]
    turn = ""

    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.settimeout(2)
     
    # connect to remote host
    try :
        s.connect((host, port))
    except :
        print 'Unable to connect'
        sys.exit()
     
    print 'Connected to remote host. Start sending messages'
     
    while 1:
        socket_list = [sys.stdin, s]
         
        # Get the list sockets which are readable
        read_sockets, write_sockets, error_sockets = select.select(socket_list , [], [])
         
        for sock in read_sockets:
            #incoming message from remote server
            if sock == s:
                data = sock.recv(1024)
                if not data :
                    print '\nDisconnected from chat server'
                    sys.exit()
                else :
                    for subData in data.split("\0"):
                        if subData == "":
                            continue
                        connectState = subData[0:1]
                        info = subData[1:]
                        infoArray = info.split(',',1)
                        print connectState,infoArray
                        if connectState == "S":
                            if infoArray[0] == "0":
                                sock.send("N%s"%name)
                                turn = infoArray[1]
                                
                        elif connectState == "C":
                            if info[0] == turn:
                                sock.send("C%s,-1"%turn)
                        elif connectState == "P":
                            tempArray = infoArray[1].split(',',1)
                            if tempArray[1] == turn:
                               sock.send("P%s,%d"%(turn,int(turn)+3))
             
           