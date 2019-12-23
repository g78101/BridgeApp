#coding=utf8

import Type
import Poker
import random

class PokerRoom:
	def __init__(self):
		self.MaxCount = 4 
		self.state = Type.RoomState.wait
		self.threeModeCount = 0
		self.threeModeUsers = [""] * 4
		self.threeModeIndex = [-1] * 4
		self.callFirst = -1
		self.users = [""] * 4
		self.sockets = []
		self.trump_type_who_play_fast = [-1] * 7
                self.trump_type_who_call_fast = [-1] * 7
		self.bridge = Poker.Bridge()

	def findSocket(self,socket):
		if socket in self.sockets:
			return True
		else:
			return False

	def addSocket(self,socket):
		if len(self.sockets) < self.MaxCount :
			self.sockets.append(socket)
			return True
		else:
			return False

	def isRoomFull(self):
		if len(self.sockets) == self.MaxCount :
			return True
		else:
			return False

	def setNameWithSocket(self,socket,name):
		index = self.sockets.index(socket)
		self.users[index] = name

	def isAllRead(self):
		if "" in self.users:
			return False
		else:
			self.state = Type.RoomState.call
			return True

	def setState(self,type):
		if type == 1:
			self.state = Type.RoomState.call
		elif type == 2:
			self.state = Type.RoomState.play

	def dealingCards(self):
		self.bridge.deal_Four()
		self.bridge.order_Card()

	def setNewNames(self,index):
		indexArray = [0,1,2,3]
		indexArray.remove(self.threeModeIndex[0])
		indexArray.remove(index)
		self.threeModeIndex[1]=indexArray[0]
		self.threeModeIndex[2]=index
		self.threeModeIndex[3]=indexArray[1]
		for i in range(0,4):
			self.threeModeUsers[i] = self.users[self.threeModeIndex[i]]

	def getNameStr(self,list):
		users=""
		for user in list:
			users+=user
			if user != list[-1]:
				users+=","
		return users

	def getPlayerCards(self,index):
		str = ""
		for i in range(13*index,13*(index+1)):
			str+="%d"%self.bridge.cards[i]
			if i != 13*(index+1)-1:
				str+=","
		return str

	def sendComCardsIndex(self):
		if self.threeModeIndex[2] == 3:
			return self.threeModeIndex[0]
		else:
			return self.threeModeIndex[1]

	def callingInfo(self,info):
		infoArray = info.split(',',1)
		returnStr = ""
		lastUser = int(infoArray[0])
		nowCall = int(infoArray[1])
		nextuser = -1

		if self.bridge.trump!=-1 and self.bridge.bout == self.MaxCount-2 and nowCall == -1:
			if self.threeModeCount == 3:
				self.threeModeIndex[0] = (lastUser+1)%self.MaxCount
				self.callFirst = self.trump_type_who_call_fast[self.bridge.trump%7]
				returnStr = "T%d"%self.threeModeIndex[0]
				self.bridge.bout = 0
			else:
				self.state = Type.RoomState.play
				returnStr = "S2,%d,%d,%d"%(self.bridge.trump,(self.trump_type_who_call_fast[self.bridge.trump%7]+1)%4,lastUser)
				self.bridge.bout = 0
		else:
			if self.bridge.trump==-1 and self.bridge.bout == self.MaxCount-1 and nowCall == -1:
				nextuser = random.randint(0,self.MaxCount-1)
				self.bridge.bout = 0
			else:
				if nowCall==-1:
					self.bridge.bout+=1
				else:
					self.bridge.bout=0
					self.bridge.trump=nowCall
					if self.trump_type_who_call_fast[nowCall%7]==-1:
						self.trump_type_who_call_fast[nowCall%7]=lastUser

				nextuser = (lastUser+1)%self.MaxCount

			returnStr = "C%d,%d,%d"%(lastUser,nextuser,nowCall)

		return returnStr

	def playingInfo(self,info):
		infoArray = info.split(',',1)
		returnStr = ""
		lastUser = int(infoArray[0])
		lastPoker = int(infoArray[1])
		nextuser = -1
		type = Type.PlayState.Normal

		if self.bridge.bout < 4:
			self.bridge.table[lastUser]=lastPoker
			nextuser=(lastUser+1)%4
			
			if self.bridge.bout == 3:
				type = Type.PlayState.LastCard
			if self.bridge.bout == 0:
				self.bridge.flower = (lastPoker-1)/13
			self.bridge.bout+=1
			
		elif lastPoker == 0:
			self.bridge.round+=1
			nextuser = self.bridge.judge()
			self.bridge.bout = 0

			if self.bridge.round == 13:
				type = Type.PlayState.GameOver

		returnStr = "P%d,%d,%d"%(lastPoker,type.value,nextuser)

		return returnStr
