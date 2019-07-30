#coding=utf8

import Type
import Poker
import random

class PokerRoom:
	def __init__(self):
		self.state = Type.RoomState.wait
		self.users = [""] * 4
		self.sockets = []
		self.trump_type_who_call_fast = [-1] * 7
		self.bridge = Poker.Bridge()

	def findSocket(self,socket):
		if socket in self.sockets:
			return True
		else:
			return False

	def addSocket(self,socket):
		if len(self.sockets) < 4 :
			self.sockets.append(socket)
			return True
		else:
			return False

	def isRoomFull(self):
		if len(self.sockets) == 4 :
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

	def dealingCards(self):
		self.bridge.deal_Four()
		self.bridge.order_Card()

	def getPlayerCards(self,index):
		str = ""
		for i in range(13*index,13*(index+1)):
			str+="%d"%self.bridge.cards[i]
			if i != 13*(index+1)-1:
				str+=","
		return str

	def callingInfo(self,info):
		infoArray = info.split(',',1)
		returnStr = ""
		lastUser = int(infoArray[0])
		nowCall = int(infoArray[1])
		nextuser = -1

		if self.bridge.trump!=-1 and self.bridge.bout == 2 and nowCall == -1:
			self.state = Type.RoomState.play
			returnStr = "S2,%d,%d,%d"%(self.bridge.trump,(self.trump_type_who_call_fast[self.bridge.trump%7]+1)%4,lastUser)
			self.bridge.bout = 0
		else:
			if self.bridge.trump==-1 and self.bridge.bout == 3 and nowCall == -1:
				nextuser = random.randint(0,3)
				self.bridge.bout = 0
			else:
				if nowCall==-1:
					self.bridge.bout+=1
				else:
					self.bridge.bout=0
					self.bridge.trump=nowCall
					if self.trump_type_who_call_fast[nowCall%7]==-1:
						self.trump_type_who_call_fast[nowCall%7]=lastUser

				nextuser = (lastUser+1)%4

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