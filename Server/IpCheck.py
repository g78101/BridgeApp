#coding=utf8

import requests
import json

class Manager:
	def __init__(self):
            self.url = "https://freegeoip.app/json/"
	    self.headers = {
                            'accept': "application/json",
                            'content-type': "application/json"
                           }
            self.ipDict = dict()

        def canConnection(self,ip):
            if ip not in self.ipDict.keys():
                allow = False 
                code = self.findCountryCode(ip)

                if code == "TW" or code == "JP" or code == "KR" or code == "CN" or code == "HK" or code == "MO" or code == "Failed":
                       allow = True
                self.ipDict[ip] = allow
                print self.ipDict
                return allow
            else:
                return self.ipDict[ip]

	def findCountryCode(self,ip):
            response = requests.request("GET", self.url+ip, headers=self.headers)
            if response:
                jsonObject = json.loads(response.text)
                return jsonObject["country_code"]
            else:
                return "Failed"
