#coding=utf8

from enum import Enum

class RoomState(Enum):
    connected = -1
    wait = 0
    call = 1
    callChoosePartner = 2
    play = 3


class PlayState(Enum):
	Normal = 0
	LastCard = 1
	GameOver = 2

class RoomUser():
	def __init__(self, name, socket, uuid):
		self.name = name
		self.socket = socket
		self.uuid = uuid