//
//  StateManager.swift
//  FancyBridge
//
//  Created by Talka_Ying on 2018/1/24.
//  Copyright © 2018年 Talka_Ying. All rights reserved.
//

import UIKit

enum GameState:Int {
    case Connected = -1
    case Wait
    case Call
    case CallChoosePartner
    case Play
}

enum ConnectState:String {
    case GameState = "S"
    case Message = "M"
    case Wait = "W"
    case ThreeMode = "T"
    case Names = "N"
    case Hand = "H"
    case Call = "C"
    case Play = "P"
    case Disconnect = "D"
    case Recover = "R"
}

enum RecoverState:String {
    case cards = "1"
    case names = "2"
    case callRecord = "3"
    case playRecord = "4"
    case boutsWin = "5"
    case done = "6"
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
    func updateWaitingUI(_ normalCount:Int, _ threeModeCount:Int)
    func changeStateUI(_ state:GameState)
}

protocol StateManagerCallDelegate:class {
    func updateCallingUI(_ index:Int)
    func showThreeModeUI(_ index:Int)
}

protocol StateManagerPlayDelegate:class {
    func updatePlayingUI(_ poker:Int,_ type:Int,_ lastUser:Int)
    func recoverPlayingUI()
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
    var threeModePlayers:[String] = [String]()
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
    
    func joinThreeMode() {
        streamManager.sendMessage("W")
    }
    
    func choosedPartner(_ choosedIndex:Int) {
        streamManager.sendMessage(String(format:"T%d",choosedIndex))
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
            case .Connected:
                let DEVICE_UUID:String = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
                streamManager.sendMessage("N"+playInfo.name+",I-"+DEVICE_UUID)
                break
            case .Wait:
                playInfo.turnIndex = Int(splitArray.last!)!
                break
            case .Call:
                let threeModeInt = Int(splitArray[2])!
                pokerManager.turnIndex = Int(splitArray[1])!
                pokerManager.threeMode = (threeModeInt==1 ? true : false)
                
                break
            case .CallChoosePartner:
                break
            case .Play:
                var lastUser = Int(splitArray.last!)!
                pokerManager.trump = Int(splitArray[1])!
                pokerManager.turnIndex = Int(splitArray[2])!
                pokerManager.callsRecord[lastUser].append(-1)
                
                if pokerManager.threeMode {
                    lastUser = 1
                }
                
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
//            if (self.delegate != nil) {
//                self.delegate.updateWaitingUI(info)
//            }
            break
        case .Wait:
            let splitArray = info.components(separatedBy: ",")
            let normalCount = Int(splitArray.first!)!
            let threeModeCount = Int(splitArray.last!)!
            
            if (self.delegate != nil) {
                self.delegate.updateWaitingUI(normalCount,threeModeCount)
            }
            break
        case .ThreeMode:
            let calledIndex = Int(info)!
            gameState = .CallChoosePartner
            pokerManager.turnIndex = calledIndex
            if (self.delegate != nil) {
                self.callDelegate.showThreeModeUI(calledIndex)
            }
            break
        case .Names:
            if !pokerManager.threeMode {
                players = info.components(separatedBy: ",")
            }
            else {
                threeModePlayers = info.components(separatedBy: ",")

                for i in 0..<4 {
                    if threeModePlayers[i] == playInfo.name {
                        playInfo.turnIndex = i
                        AlertView.showViewSetText(String(format:"You are player %d",i+1))
                        break
                    }
                }
                pokerManager.comIndex = threeModePlayers.index(of: "-")!
            }
            break
        case .Hand:
            if !pokerManager.threeMode {
                pokerManager.setCards(info.components(separatedBy: ","))
            }
            else {
                pokerManager.setOtherCards(info.components(separatedBy: ","))
            }
            break
        case .Call:
            let splitArray = info.components(separatedBy: ",")
            let nowTurn = Int(splitArray[1])!
            let trump = Int(splitArray.last!)!
            let lastTurn = Int(splitArray.first!)!
            
            pokerManager.turnIndex = nowTurn
            if playInfo.turnIndex == nowTurn {
                AlertView.showViewSetText("Your Turn")
            }
            
            pokerManager.callsRecord[lastTurn].append(trump)
            
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
            let playState = PlayState(rawValue: Int(splitArray[1])!)!
            
            pokerManager.turnIndex = nextTurn
            
            switch playState {
            case .Normal:
                if poker != 0 {
                    if pokerManager.currentFlower == -1 {
                        pokerManager.currentFlower=(poker-1)/13;
                    }
                    
                    let flower = Int((poker-1)/13)
                    pokerManager.playsRecord[lastTurn].append(poker)
                    pokerManager.flowerCountRecord[flower] += 1;
                }
                else {
                    pokerManager.boutsWinRecord.append(nextTurn)
                }
                break
            case .LastCard:
               
                let flower = Int((poker-1)/13)
                pokerManager.playsRecord[lastTurn].append(poker)
                pokerManager.flowerCountRecord[flower] += 1;
                
                if playInfo.turnIndex == 0 {
                    DispatchQueue.global().async {
                        sleep(2)
                        self.streamManager.sendMessage("P-1,0")
                    }
                }
                
                pokerManager.currentFlower = -1
                pokerManager.turnIndex = -1
                
                break
            case .GameOver:
                pokerManager.boutsWinRecord.append(nextTurn)
                isGameOver = true
                break
            }
            
            if (self.playDelegate != nil) {
                self.playDelegate.updatePlayingUI(poker, playState.rawValue, lastTurn)
            }
            
            break
        case .Disconnect:
            if StateManager.getInstance().isGameOver {
                return
            }
            
            if info == "0" {
                UIAlertController.showAlert(title: "Server Message", message: "Someone Disconnect")
                LoadingView.StartLoading()
            }
            else if info == "1" {
                if (gameState == .CallChoosePartner && pokerManager.turnIndex == playInfo.turnIndex)
                    || gameState != .CallChoosePartner {
                    LoadingView.StopLoading()
                }
            }
            else {
                closeConnectAlert("close connect")
            }
            
            break
        case .Recover:
            let recoverState:RecoverState? = RecoverState(rawValue: String(info.first!))
            let recoverInfo = String(info.dropFirst(2))
            
            switch recoverState {
            case .cards:
                let splitArray = recoverInfo.components(separatedBy: "^")
                let cards = splitArray[0]
                pokerManager.setCards(cards.components(separatedBy: ","))
                if splitArray.count > 1 {
                    let otherCards = splitArray[1]
                    pokerManager.setOtherCards(otherCards.components(separatedBy: ","))
                    pokerManager.threeMode = true
                }
                break
            case .names:
                let splitArray = recoverInfo.components(separatedBy: "^")
                let turnIndex = Int(splitArray[0])!
                let names = splitArray[1]
                
                players = names.components(separatedBy: ",")
                playInfo.name = players[turnIndex]
                playInfo.turnIndex = turnIndex
                if splitArray.count > 2 {
                    let threeNames = splitArray[2]
                    threeModePlayers = threeNames.components(separatedBy: ",")
                    
                    for i in 0..<4 {
                        if threeModePlayers[i] == playInfo.name {
                            playInfo.turnIndex = i
                            AlertView.showViewSetText(String(format:"You are player %d",i+1))
                            break
                        }
                    }
                    pokerManager.comIndex = threeModePlayers.index(of: "-")!
                }
                break
            case .callRecord:
                let splitArray = recoverInfo.components(separatedBy: "|")

                for i in 0..<4 {
                    let player = splitArray[i]
                    if player == "" {
                        continue
                    }
                    let records = player.components(separatedBy: "^")
                    for card in records {
                        if card != "" {
                            pokerManager.callsRecord[i].append(Int(card)!)
                        }
                    }
                }
                break
            case .playRecord:
                let splitArray = recoverInfo.components(separatedBy: "|")

                for i in 0..<4 {
                    let player = splitArray[i]
                    if player == "" {
                        continue
                    }
                    let records = player.components(separatedBy: "^")
                    for card in records {
                        if card != "" {
                            let poker = Int(card)!
                            let flower = Int((poker-1)/13)
                            pokerManager.playsRecord[i].append(poker)
                            pokerManager.flowerCountRecord[flower] += 1;
                        }
                    }
                }
                break
            case .boutsWin:
                let splitArray = recoverInfo.components(separatedBy: "|")
                var lastWinIndex = -1
                for bouts in splitArray {
                    if bouts != "" {
                        let winIndex = Int(bouts)!
                        lastWinIndex = winIndex
                        pokerManager.boutsWinRecord.append(winIndex)
                        if (winIndex==playInfo.turnIndex||winIndex==(playInfo.turnIndex+2)%4) {
                            pokerManager.ourScroe += 1
                        }
                        else {
                            pokerManager.enemyScroe += 1
                        }
                    }
                }
                if lastWinIndex != -1 && pokerManager.boutsWinRecord.count < pokerManager.playsRecord[lastWinIndex].count {
                    pokerManager.currentFlower=((pokerManager.playsRecord[lastWinIndex].last!)-1)/13;
                }
                
                break
            case .done:
                let splitArray = recoverInfo.components(separatedBy: "^")
                let tempState = GameState(rawValue: Int(splitArray[0])!)!
                gameState = tempState
                pokerManager.turnIndex = Int(splitArray[1])!
                pokerManager.trump = Int(splitArray[2])!
                let callLast = Int(splitArray[3])!
                
                if pokerManager.turnIndex == -1 && playInfo.turnIndex == 0 {
                    DispatchQueue.global().async {
                        sleep(1)
                        self.streamManager.sendMessage("P-1,0")
                    }
                }
                
                if (!pokerManager.threeMode) {
                    if (callLast==playInfo.turnIndex||callLast==(playInfo.turnIndex+2)%4) {
                        pokerManager.winNumber = PokerManager.totalSum-(pokerManager.trump/7+7)
                    }
                    else {
                        pokerManager.winNumber = (pokerManager.trump/7+7)
                    }
                }
                else {
                    if ( playInfo.turnIndex==0 || playInfo.turnIndex==2) {
                        pokerManager.winNumber = (pokerManager.trump / 7 + 7);
                    }
                    else {
                        pokerManager.winNumber = PokerManager.totalSum - (pokerManager.trump / 7 + 7);
                    }
                }
                
                if (self.delegate != nil) {
                    self.delegate.changeStateUI(gameState)
                }
                
                if gameState == .Call {
                    if (self.callDelegate != nil) {
                        self.callDelegate.updateCallingUI(pokerManager.trump)
                    }
                }
                else if gameState == .CallChoosePartner {
                    if (self.callDelegate != nil) {
                        self.callDelegate.showThreeModeUI(pokerManager.turnIndex)
                    }
                }
                else if gameState == .Play {
                    if (self.playDelegate != nil) {
                        self.playDelegate.recoverPlayingUI()
                    }
                }

                break
            case .none:
                break
            }
            
            break
        }
    }
    
    func connectInterrupt() {
        if StateManager.getInstance().isGameOver {
            return
        }
        
        if gameState == .Connected || gameState == .Wait {
            closeConnectAlert("Someone Leave")
        }
        else {
            let cancelAction:UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                exit(1)
                })
            UIAlertController.showAlert(title: "Server Message",message: "Someone Disconnect",actions: [cancelAction])
        }
    }
    
    func closeConnectAlert(_ message:String) {
        let cancelAction:UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                exit(1)
            })
        
        UIAlertController.showAlert(title: "Server Message",message: message,actions: [cancelAction])
    }
}
