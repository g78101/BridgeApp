#coding=utf8

from enum import Enum

class RoomState(Enum):
    wait = 0
    call = 1
    play = 2

class PlayState(Enum):
	Normal = 0
	LastCard = 1
	GameOver = 2