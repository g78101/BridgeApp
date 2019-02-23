#coding=utf8

import Type
import random

class Bridge:
	def __init__(self):
		self.round = 0
		self.bout = 0
		self.trump = -1
		self.flower = -1
		self.cards = []
		self.table = [-1] * 4

		for i in range(1,53):
			self.cards.append(i)

	def deal_Four(self):
		for i in range(0,52):
			j =  random.randint(0,51)
			temp = self.cards[i]
			self.cards[i] = self.cards[j]
			self.cards[j] = temp

	def order_Card(self):
		tempList = self.cards
		self.cards = []
		for i in range(0,4):
			self.cards += sorted(tempList[13*i:13*(i+1)])

	def judge(self):
		max = -1
		max_index = -1
		type = self.trump%7
		compare_type = [False] * 4
		FourFlower = [3,2,4,5]

		if 1<type and type<6:
			for i in range(0,4):
				if FourFlower[(self.table[i]-1)/13] == type :
					compare_type[i]=True
			if True in compare_type:
				for i in range(0,4):
					if compare_type[i]:
						if (self.table[i]==1 or self.table[i]==14 or self.table[i]==27 or self.table[i]==40):
							max_index = i
							break
						elif self.table[i] > max:
							max = self.table[i]
							max_index = i
			else:
				for i in range(0,4):
					if (self.table[i]==1 or self.table[i]==14 or self.table[i]==27 or self.table[i]==40) and (self.table[i]-1)/13 == self.flower:
						max_index = i
						break
					elif (self.table[i]-1)/13 == self.flower and self.table[i]>max:
						max = self.table[i]
						max_index = i
		
		elif type == 6:
			for i in range(0,4):
				if (self.table[i]==1 or self.table[i]==14 or self.table[i]==27 or self.table[i]==40) and (self.table[i]-1)/13 == self.flower:
					max_index = i
					break
				elif (self.table[i]-1)/13 == self.flower and self.table[i]>max:
					max = self.table[i]
					max_index = i
		elif type == 1:
			for i in range(0,4):
				if (self.table[i]-1)/13 == self.flower:
					card = self.table[i]%13
					change_number = -1
					if card == 7:
						change_number=13
					elif card == 6:
						change_number=12
					elif card == 8:
						change_number=11
					elif card == 5:
						change_number=10
					elif card == 9:
						change_number=9
					elif card == 4:
						change_number=8
					elif card == 10:
						change_number=7
					elif card == 3:
						change_number=6
					elif card == 11:
						change_number=5
					elif card == 2:
						change_number=4
					elif card == 12:
						change_number=3
					elif card == 1:
						change_number=2
					elif card == 13 or card == 0:
						change_number=1

					if change_number > max:
						max = change_number
						max_index = i
		else:
			for i in range(0,4):
				if (self.table[i]-1)/13 == self.flower and (self.table[i] < max or max == -1):
					max = self.table[i]
					max_index = i
		return max_index