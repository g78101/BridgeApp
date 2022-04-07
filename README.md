# Introduction

The FancyBridge is a game of poker.

1. It add two trump (Small, Middle) from bridge.</br>
The trunp:</br>
&nbsp;&nbsp;**Small < Middle < Club < Diamond < Heart < Spades < No Trump**

2. I add three players mode.</br>
&nbsp;&nbsp;Each person bids respectively. Declarer can choose teammate ( other player or Space )

# How to play

### Server Side:

* 	From Container:  
    1. docker pull g78101/bridge-server
    2. docker run --name bridge-server -p 3344:3344 -p 8888:8888 -d g78101/bridge-server

* 	From Code:
    1. in terminal: **cd {Server}**
    2. in terminal: **python Server.py**
     	</br>*( sample of observer html at info/ )*

### iOS Side:
1. open **FancyBridge.xcodeproj**
2. in xcode: **run**
	</br>*( change ServerURL at StreamManager.swif )*
	
### Android Side:
1. using **Android Studio** open **Android/**
2. in Android Studio: **run**
	</br>*( change ServerURL at StreamManager.java )*

P.S. The game will begin when four players connected or three players clicked **Three player mode**

# Game Screenshots

The Screenshots of WaitState
![alt text](https://raw.githubusercontent.com/g78101/BridgeApp/master/GameScreenshots/Wait2.jpg)

The Screenshots of CallState
![alt text](https://raw.githubusercontent.com/g78101/BridgeApp/master/GameScreenshots/Call2.jpg)

The Screenshots PlayState
![alt text](https://raw.githubusercontent.com/g78101/BridgeApp/master/GameScreenshots/Play3.jpg)

# Reference
* 	PokerBridge-Qt:</br>
&nbsp;&nbsp;https://github.com/g78101/PokerBridge-Qt</br>
* 	g78101/bridge-server:</br>
&nbsp;&nbsp;https://hub.docker.com/r/g78101/bridge-server</br>