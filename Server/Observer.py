#coding=utf8

from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
# import ssl
import SocketServer
import threading
import Type

Trumps = [" SA"," MD"," C"," D"," H"," S"," NT"]
Flowers = [" D"," C"," H"," S"]

class S(BaseHTTPRequestHandler):

    trumpHtml = '<div style="color:#000000;border:1px solid #333333; width:30%;height:200px; float: left; vertical-align:middle; padding: 10px ; text-align: center; line-height: 200px; font-size:45px">'
    scoreHtml = '<div style="color:#000000;border:1px solid #333333; width:50%;height:200px; float: left; vertical-align:middle; padding: 10px; text-align: left;font-size:30px">'
    nameHtml = '<div style="color:#000000; width:20%; float: left; vertical-align:middle; padding: 10px ; text-align: center; font-size:35px;">'
    callHtml = '<div style="border:1px solid #333333; width:20%; height:200px; float: left; vertical-align:middle; padding: 10px;font-size: 25px">'
    playHtml = '<div style="border:1px solid #333333; width:20%; height:400px; float: left; vertical-align:middle; padding: 10px;font-size: 25px">'

    players = [""] * 4
    callsRecord = [""] * 4
    playsRecord = [""] * 4

    trump = 'Waiting'
    attackIndex = [-1] * 2
    attackWinNumber = 7
    attackTeam = ''
    attackScore = 0
    defenseTeam = ''
    defenseScore = 0

    def log_request(self, code): pass

    def _set_headers(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html; charset=utf-8')
        self.send_header('refresh', '3')
        self.end_headers()

    def do_GET(self):
        self._set_headers()
        self.wfile.write('<html><head><title>BridgeApp</title></head>')
        self.wfile.write('<body style="margin:20px"><div style="text-align: center;margin: 0;padding: 0;"><div>')
        # title
        self.wfile.write(self.trumpHtml)
        self.wfile.write(self.trump+  '</div>')
        self.wfile.write(self.scoreHtml)
        self.wfile.write(self.attackTeam+ ' team<br>')
        self.wfile.write('<div align="right">' + ("%d / %d")%(self.attackScore,self.attackWinNumber) + '</div><br>')
        self.wfile.write(self.defenseTeam+ ' team<br>')
        self.wfile.write('<div align="right">' + ("%d / %d")%(self.defenseScore,14-self.attackWinNumber) + '</div><br> </div></div>')
        # name
        for name in self.players:
            self.wfile.write(self.nameHtml)
            self.wfile.write(name+'</div>')
        # call
        for call in self.callsRecord:
            self.wfile.write(self.callHtml)
            subCall = call.split(',')
            for temp in subCall:
                self.wfile.write(temp + '<br>')
            self.wfile.write('</div>')
        # play
        for play in self.playsRecord:
            self.wfile.write(self.playHtml)
            subPlay = play.split(',')
            for temp in subPlay:
                self.wfile.write(temp + '<br>')
            self.wfile.write('</div>')

        self.wfile.write('</body></html>')

    def do_HEAD(self):
        self._set_headers()

class HttpServer:
    def __init__(self):
        self.httpd = None
        self.thread = None
        self.handler_class = None

    def run(self,server_class=HTTPServer, handler_class=S, port=3344):
        server_address = ('', port)
        self.httpd = server_class(server_address, handler_class)
        # self.httpd.socket = ssl.wrap_socket (self.httpd.socket,
        #                   keyfile='/etc/apache2/ssl.crt/private.key',
        #                   certfile='/etc/apache2/ssl.crt/certificate.crt',
        #                   ca_certs='/etc/apache2/ssl.crt/ca_bundle.crt',
        #                   server_side=True)
        print 'Httpd server started on port ' + str(port)
        self.httpd.serve_forever()

    def start(self):
        t = threading.Thread(target = self.run)
        t.start()

    def stop(self):
        self.httpd.server_close()

    def reset(self):
        S.players = [""] * 4
        S.callsRecord = [""] * 4
        S.playsRecord = [""] * 4

        S.trump = 'Waiting'
        S.attackIndex = [-1] * 2
        S.attackWinNumber = 7
        S.attackTeam = ''
        S.attackScore = 0
        S.defenseTeam = ''
        S.defenseScore = 0

    def setPlayers(self,list):
        S.players = list.split(',')

    def updateContent(self,str):
        connectState = str[0:1]
        info = str[1:]
        # print connectState,info
        if connectState == "S":
            splitArray = info.split(',')
            trump = int(splitArray[1])
            lastUser = int(splitArray[3])

            S.trump = ("%d%s")%(trump/7+1,Trumps[trump%7])

            S.attackIndex[0] = (lastUser+1)%4
            S.attackIndex[1] = (lastUser+3)%4
            S.attackWinNumber = (trump/7+7)

            attackTeam = ''
            defenseTeam = ''

            for i in range(0,4):
                player = S.players[i]
                if i in S.attackIndex:
                    attackTeam = attackTeam + player + ' , '
                else:
                    defenseTeam = defenseTeam + player + ' , '
            S.attackTeam = attackTeam[0:len(attackTeam)-3]
            S.defenseTeam = defenseTeam[0:len(defenseTeam)-3]

        elif connectState == "C":
            splitArray = info.split(',')
            lastUser = int(splitArray[0])
            trump = int(splitArray[2])
            updateRecord = S.callsRecord[lastUser]
            if trump != -1:
                tempStr = ("%d%s,")%((trump/7)+1,Trumps[trump%7])
            else:
                tempStr = "Pass,"
            S.callsRecord[lastUser] = updateRecord + tempStr

        elif connectState == "P":
            splitArray = info.split(',')
            nextUser = int(splitArray[2])
            lastUser = (nextUser+4-1)%4
            poker = int(splitArray[0])
            playState = Type.PlayState(int(splitArray[1]))

            if poker != 0:
                updateRecord = S.playsRecord[lastUser]
                tempStr = ("%d%s,")%((poker-1)%13+1,Flowers[(poker-1)/13])
                S.playsRecord[lastUser] = updateRecord + tempStr
            else:
                if nextUser in S.attackIndex:
                    S.attackScore += 1
                else:
                    S.defenseScore += 1

        