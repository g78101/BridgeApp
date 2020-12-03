#coding=utf8

import requests
import json
import time

class Manager:
	def __init__(self):
            self.url = "https://freegeoip.app/json/"
	    self.headers = {
                            'accept': "application/json",
                            'content-type': "application/json"
                           }
            self.lastIp=None
            self.lastTime=None
            self.logger=None
            self.ipDict = dict()

        def canConnection(self,ip):
            ipAreaAllow = False
            if ip not in self.ipDict.keys():
                code = self.findCountryCode(ip)

                if code == "TW" or code == "JP" or code == "KR" or code == "CN" or code == "HK" or code == "MO" or code == "Failed":
                       ipAreaAllow = True
                self.ipDict[ip] = ipAreaAllow
                self.logger.info(self.ipDict)
            else:
                ipAreaAllow = self.ipDict[ip]

            if ipAreaAllow:
                return self.avoidDdosCheck(ip)
            else:
                return False

	def findCountryCode(self,ip):
            response = requests.request("GET", self.url+ip, headers=self.headers)
            if response:
                jsonObject = json.loads(response.text)
                return jsonObject["country_code"]
            else:
                return "Failed"

        def avoidDdosCheck(self,ip):
            canConnect = False
            if self.lastIp == None or self.lastTime == None:
                self.logger.info("avoidDdosCheck - None")
                canConnect = True
            elif self.lastIp != ip:
                canConnect = True
                self.logger.info("avoidDdosCheck - Different ip")
            elif self.lastIp == ip:
                nowTime = time.time()
                interval = nowTime - self.lastTime
                self.logger.info("avoidDdosCheck - The same ip")
                if interval > 0.2:
                    canConnect = True
                    self.logger.info("avoidDdosCheck ----- over 0.2s")
                else:
                    self.logger.info("avoidDdosCheck ----- below 0.2s")

            self.lastIp = ip
            self.lastTime = time.time()

            return canConnect

