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
		self.users = []
		self.trump_type_who_call_fast = [-1] * 7
		self.bridge = Poker.Bridge()
		self.callFirst = -1
		self.nextuser = -1
		self.callLast = -1

		# for observer
		self.callsRaw = [""] * 4
		self.playsRaw = [""] * 4
		self.boutsWinRecord = ""
		self.attackIndex = [-1] * 2
		self.attackWinNumber = 7
		self.attackTeam = ''
		self.attackScore = 0
		self.defenseTeam = ''
		self.defenseScore = 0
		self.flowerCountRecord = [0] * 4
		self.playsPokerHand = [[] for i in range(4)]

	def findSocketIndex(self,socket):
		for i in range(0,len(self.users)):
			if socket == self.users[i].socket:
				return i
		return -1

	def removeSocker(self,socket):
		index  = self.findSocketIndex(socket)
		self.users[index].socket=None

	def checkInterruptSocketNum(self):
		num=0
		for i in range(0,len(self.users)):
			if self.users[i].socket==None and self.users[i].uuid != "":
				num+=1
		return num

	def findTheSameUUIDIndex(self,uuid):
		for i in range(0,len(self.users)):
			if uuid == self.users[i].uuid:
				return i
		return -1

	def recoverRoom(self,index,socket):
		self.users[index].socket=socket
		
		recoverList = []
		threeMode = False
		if self.users[3].uuid == "":
			threeMode = True

		recoveryCard="R1^%s"%(self.getPlayerCards(index))
		if threeMode:
			recoveryCard+="^%s"%(self.getPlayerCards(3))
		
		recoveryName = "R2^%d^%s"%(index,self.getNameStr(self.users))
		if threeMode and self.threeModeUsers[0] != "":
			recoveryName+="^%s"%(self.getNameStr(self.threeModeUsers))
		
		recoverCall = "R3^%s"%(self.callsRawTranslate())

		recoverPlay = "R4^%s"%(self.playsRawTranslate())

		recoverBoutsWin = "R5^%s"%(self.boutsWinRecord[:-1])

		recoverStatus="R6^%s^%s^%s^%s"%(self.state.value,self.nextuser,self.bridge.trump,self.callLast)
		
		recoverList.append(recoveryCard)
		recoverList.append(recoveryName)
		recoverList.append(recoverCall)
		recoverList.append(recoverPlay)
		recoverList.append(recoverBoutsWin)
		recoverList.append(recoverStatus)
		return recoverList

	def isRoomFull(self):
		if len(self.users) == 4 :
			return True
		else:
			return False

	def callsRawTranslate(self):
		callStr = ""
		for callRaw in self.callsRaw:
			callStr += callRaw[0:-1] + "|"
		callStr = callStr[:-1]
		return callStr

	def playsRawTranslate(self):
		playStr = ""
		for playRaw in self.playsRaw:
			playStr += playRaw[0:-1] + "|"
		playStr = playStr[:-1]
		return playStr

	def setUserInfo(self,socket,name,uuid):
		self.users.append(Type.RoomUser(name,socket,uuid))

	def isAllRead(self):
		for i in range(0,len(self.users)):
			if "" == self.users[i].name:
				return False	
		self.state = Type.RoomState.call
		return True

	def dealingCards(self):
		self.bridge.deal_Four()
		self.bridge.order_Card()
		for i in range(0,4):
			cards = self.getPlayerCards(i)
			cardArray = cards.split(',')
			for card in cardArray:
				self.playsPokerHand[i].append(int(card))

	def setThreeMode(self):
		self.MaxCount = 3
		self.state = Type.RoomState.call
		self.users.append(Type.RoomUser("-",None,""))

	def setNewNames(self,index):
		indexArray = [0,1,2,3]
		indexArray.remove(self.threeModeIndex[0])
		indexArray.remove(index)
		self.threeModeIndex[1]=indexArray[0]
		self.threeModeIndex[2]=index
		self.threeModeIndex[3]=indexArray[1]
		for i in range(0,4):
			self.threeModeUsers[i] = self.users[self.threeModeIndex[i]].name

	def getNameStr(self,list):
		users=""
		for user in list:
			str=""
			if isinstance(user,Type.RoomUser):
				str=user.name
			else:
				str=user
			users+=str
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

	def getTrump(self):
		return self.bridge.trump

	def sendComCardsIndex(self):
		if self.threeModeIndex[2] == 3:
			return self.threeModeIndex[0]
		else:
			return self.threeModeIndex[1]

	def threeModeSetting(self):
		self.callLast = ((self.threeModeIndex[0]+(self.MaxCount-1))%self.MaxCount)
		self.state = Type.RoomState.play
		self.nextuser = (self.threeModeIndex.index(self.callFirst)+1)%4
		returnStr = "S%d,%d,%d,%d"%(self.state.value,self.bridge.trump,self.nextuser,self.callLast)
		self.updateAttackDefenseInfo(self.bridge.trump,self.callLast)
		return returnStr

	def callingInfo(self,info):
		infoArray = info.split(',',1)
		returnStr = ""
		lastUser = int(infoArray[0])
		nowCall = int(infoArray[1])

		if self.bridge.trump!=-1 and self.bridge.bout == self.MaxCount-2 and nowCall == -1:
			if self.threeModeCount == 3:
				self.threeModeIndex[0] = (lastUser+1)%self.MaxCount
				self.callFirst = self.trump_type_who_call_fast[self.bridge.trump%7]
				returnStr = "T%d"%self.threeModeIndex[0]
				self.state=Type.RoomState.callChoosePartner
				self.nextuser=self.threeModeIndex[0]
			else:
				self.callLast = lastUser
				self.state = Type.RoomState.play
				returnStr = "S%d,%d,%d,%d"%(self.state.value,self.bridge.trump,(self.trump_type_who_call_fast[self.bridge.trump%7]+1)%4,self.callLast)
				self.updateAttackDefenseInfo(self.bridge.trump,self.callLast)
			self.bridge.bout = 0
		else:
			if self.bridge.trump==-1 and self.bridge.bout == self.MaxCount-1 and nowCall == -1:
				self.nextuser = random.randint(0,self.MaxCount-1)
				self.bridge.bout = 0
			else:
				if nowCall==-1:
					self.bridge.bout+=1
				else:
					self.bridge.bout=0
					self.bridge.trump=nowCall
					if self.trump_type_who_call_fast[nowCall%7]==-1:
						self.trump_type_who_call_fast[nowCall%7]=lastUser

				self.nextuser = (lastUser+1)%self.MaxCount

			returnStr = "C%d,%d,%d"%(lastUser,self.nextuser,nowCall)

		updateRaw = self.callsRaw[lastUser]
		self.callsRaw[lastUser] = updateRaw + ("%d^")%nowCall
		return returnStr

	def playingInfo(self,info):
		roundFinish=False
		infoArray = info.split(',',1)
		returnStr = ""
		lastUser = int(infoArray[0])
		lastPoker = int(infoArray[1])
		type = Type.PlayState.Normal

		if self.bridge.bout < 4:
			
			self.bridge.table[lastUser]=lastPoker
			self.nextuser=(lastUser+1)%4
			
			if self.bridge.bout == 3:
				type = Type.PlayState.LastCard
				roundFinish=True
			if self.bridge.bout == 0:
				self.bridge.flower = (lastPoker-1)/13
			self.bridge.bout+=1
			updateRaw = self.playsRaw[lastUser]
			self.playsRaw[lastUser] = updateRaw + ("%d^")%lastPoker
			flower = int((lastPoker-1)/13)
			self.flowerCountRecord[flower] += 1;
			removeIndex = lastUser
			if self.users[3].uuid == "":
				removeIndex = self.threeModeIndex[lastUser]
			self.playsPokerHand[removeIndex].remove(lastPoker)
			
		elif lastPoker == 0:
			self.bridge.round+=1
			self.nextuser = self.bridge.judge()
			self.boutsWinRecord+= ("%d|")%(self.nextuser)
			self.bridge.bout = 0

			if self.bridge.round == 13:
				type = Type.PlayState.GameOver

			if self.nextuser in self.attackIndex:
				self.attackScore += 1
			else:
				self.defenseScore += 1

		returnStr = "P%d,%d,%d"%(lastPoker,type.value,self.nextuser)

		if roundFinish:
			self.nextuser = -1

		return returnStr

	def updateAttackDefenseInfo(self,trump,lastUser):

		threeMode = False
		if self.users[3].uuid == "":
			threeMode = True
		self.attackWinNumber = (self.bridge.trump/7+7)

		if threeMode:
			self.attackIndex[0] = 0
			self.attackIndex[1] = 2
		else:
			self.attackIndex[0] = (lastUser+1)%4
			self.attackIndex[1] = (lastUser+3)%4

		attackTeam = ''
		defenseTeam = ''

		for i in range(0,4):
			player = self.users[i].name
			if threeMode:
				player = self.threeModeUsers[i]
			if i in self.attackIndex:
				attackTeam = attackTeam + player + ' , '
			else:
				defenseTeam = defenseTeam + player + ' , '
		self.attackTeam = attackTeam[0:len(attackTeam)-3]
		self.defenseTeam = defenseTeam[0:len(defenseTeam)-3]