//
//  StateManager.swift
//  FancyBridge
//
//  Created by Talka_Ying on 2018/1/24.
//  Copyright © 2018年 Talka_Ying. All rights reserved.
//

import UIKit

enum GameState:Int {
    case Wait = 0
    case Call
    case Play
}

enum ConnectState:String {
    case GameState = "S"
    case Message = "M"
    case Names = "N"
    case Hand = "H"
    case Call = "C"
    case Play = "P"
}

enum PlayState:Int {
    case Normal = 0
    case LastCard
    case GameOver
}

struct PlayerInfo {
    var name:String
    var turnIndex:Int
}

protocol StateManagerDelegate:class {
    func updateWaitingUI(_ text:String)
    func changeStateUI(_ state:GameState)
}

protocol StateManagerCallDelegate:class {
    func updateCallingUI(_ index:Int)
}

protocol StateManagerPlayDelegate:class {
    func updatePlayingUI(_ poker:Int,_ type:Int,_ lastUser:Int)
}

class StateManager: NSObject, StreamManagerDelegate {

    static var instance:StateManager!
    //MARK: - Member
    weak var delegate:StateManagerDelegate!
    weak var callDelegate:StateManagerCallDelegate!
    weak var playDelegate:StateManagerPlayDelegate!
    var streamManager:StreamManager!
    var playInfo:PlayerInfo = PlayerInfo(name: "", turnIndex: -1)
    var players:[String] = [String]()
    var gameState:GameState = .Wait
    var isGameOver:Bool = false
    
    //MARK: - Init
    static func getInstance() -> StateManager {
        
        if instance == nil {
            instance = StateManager()
        }
        return instance
    }
    
    override init() {
        super.init()
        streamManager = StreamManager.getInstance()
        streamManager.delegate = self
    }
    
    //MARK: - Functions
    func reset() {
        players = [String]()
        gameState = .Wait
        isGameOver = false
        if (self.delegate != nil) {
            self.delegate.changeStateUI(gameState)
        }
    }
    
    func connectServer() {
        streamManager.connect()
    }
    
    func interruptConnect() {
        streamManager.disconnect()
    }
    
    func test(_ text:String) {
        streamManager.sendMessage(text)
    }
    
    func getData(_ data: String) {
//        print(data)
        let pokerManager = PokerManager.getInstance()
        let connectState:ConnectState? = ConnectState(rawValue: String(data.first!))
        let info = String(data.dropFirst(1))
        
        if connectState == nil {
            return
        }
        
        switch connectState! {
        case .GameState:
            let splitArray = info.components(separatedBy: ",")
            let tempState = GameState(rawValue: Int(splitArray.first!)!)
            
            if tempState == nil {
                return
            }
            
            gameState = tempState!
            
            switch gameState {
            case .Wait:
                playInfo.turnIndex = Int(splitArray.last!)!
                streamManager.sendMessage("N"+playInfo.name)
                break
            case .Call:
                pokerManager.turnIndex = Int(splitArray.last!)!
                break
            case .Play:
                let lastUser = Int(splitArray.last!)!
                pokerManager.trump = Int(splitArray[1])!
                pokerManager.turnIndex = Int(splitArray[2])!
                
                if (lastUser==playInfo.turnIndex||lastUser==(playInfo.turnIndex+2)%4) {
                    pokerManager.winNumber = PokerManager.totalSum-(pokerManager.trump/7+7)
                }
                else {
                    pokerManager.winNumber = (pokerManager.trump/7+7)
                }
                
                break
            }
            
            if (self.delegate != nil) {
                self.delegate.changeStateUI(gameState)
            }
            
            break
        case .Message:
            if (self.delegate != nil) {
                self.delegate.updateWaitingUI(info)
            }
            break
        case .Names:
            players = info.components(separatedBy: ",")
            break
        case .Hand:
            pokerManager.setCards(info.components(separatedBy: ","))
            break
        case .Call:
            let splitArray = info.components(separatedBy: ",")
            let nowTurn = Int(splitArray[1])!
            let trump = Int(splitArray.last!)!
            let lastTurn = Int(splitArray.first!)!
            var tempStr:String!
            
            pokerManager.turnIndex = nowTurn
            if playInfo.turnIndex == nowTurn {
                UIAlertController.showAlert(title: "", message: "Your Turn")
            }
            
            let updateRecord:String = pokerManager.callsRecord[lastTurn]
            if trump != -1 {
                tempStr = String(format:"%d %@\n",(trump/7)+1,PokerManager.flowers[trump%7])
            }
            else {
                tempStr = "Pass\n"
            }
            pokerManager.callsRecord[lastTurn] = updateRecord + tempStr
            
            if (splitArray.last != nil) {
                if (self.callDelegate != nil) {
                    self.callDelegate.updateCallingUI(trump)
                }
            }
            break
        case .Play:
            let splitArray = info.components(separatedBy: ",")
            let nextTurn = Int(splitArray.last!)!
            let lastTurn = (nextTurn+4-1)%4;
            let poker = Int(splitArray.first!)!
            var tempStr:String!
            let playState = PlayState(rawValue: Int(splitArray[1])!)!
            
            pokerManager.turnIndex = nextTurn
            
            switch playState {
            case .Normal:
                if poker != 0 {
                    if pokerManager.currentFlower == -1 {
                        pokerManager.currentFlower=(poker-1)/13;
                    }
                    
                    let updateRecord:String = pokerManager.playsRecord[lastTurn]
                    let flower = Int((poker-1)/13)
                    tempStr = String(format:"%@",CardView.showPokerStr(poker: poker))
                    
                    pokerManager.playsRecord[lastTurn] = updateRecord + tempStr
                    pokerManager.flowerCountRecord[flower] += 1;
                }
                break
            case .LastCard:
                let updateRecord:String = pokerManager.playsRecord[lastTurn]
                let flower = Int((poker-1)/13)
                tempStr = String(format:"%@",CardView.showPokerStr(poker: poker))
                
                pokerManager.playsRecord[lastTurn] = updateRecord + tempStr
                pokerManager.flowerCountRecord[flower] += 1;
                
                if playInfo.turnIndex == 3 {
                    DispatchQueue.global().async {
                        sleep(2)
                        self.streamManager.sendMessage("P-1,0")
                    }
                }
                
                pokerManager.currentFlower = -1
                pokerManager.turnIndex = -1
                
                break
            case .GameOver:
                isGameOver = true
                break
            }
            
            if (self.playDelegate != nil) {
                self.playDelegate.updatePlayingUI(poker, playState.rawValue, lastTurn)
            }
            
            break
        }
        
    }
}
