//
//  PokerManager.swift
//  FancyBridge
//
//  Created by Talka_Ying on 2018/1/25.
//  Copyright © 2018年 Talka_Ying. All rights reserved.
//

import UIKit

let HandCardsCount = 13

protocol PokerManagerDelegate:class {
    func setCardsForUI(_ cardArray:[String])
}

class PokerManager: NSObject {
    
    static var instatnce:PokerManager!
    //MARK: - Const
    static let flowers = [" SA"," MD"," C"," D"," H"," S"," NT"]
    static let totalSum = 14
    //MARK: - Member
    weak var delegate:PokerManagerDelegate!
    var streamManager:StreamManager!
    var stateManager:StateManager!
    var cards:[String] = [String]()
    var callsRecord:[String] = ["","","",""]
    var playsRecord:[String] = ["","","",""]
    var flowerCountRecord:[Int] = [0,0,0,0]
    var turnIndex:Int = -1
    var trump:Int = -1
    var currentFlower = -1
    var winNumber:Int = -1
    var ourScroe:Int = 0
    var enemyScroe:Int = 0
    
    //MARK: - Init
    static func getInstance() -> PokerManager {
        
        if instatnce == nil {
            instatnce = PokerManager()
        }
        return instatnce
    }
    
    override init() {
        super.init()
        streamManager = StreamManager.getInstance()
        stateManager = StateManager.getInstance()
    }
    
    //MARK: - Function
    func reset() {
        cards.removeAll()
        callsRecord = ["","","",""]
        playsRecord = ["","","",""]
        flowerCountRecord = [0,0,0,0]
        turnIndex = -1
        trump = -1
        currentFlower = -1
        winNumber = -1
        ourScroe = 0
        enemyScroe = 0
    }
    
    func setCards(_ cardArray:[String]) {
        cards = cardArray
        if (self.delegate != nil) {
            self.delegate.setCardsForUI(cards)
        }
    }
    
    func callTrump(_ index:Int) {
        streamManager.sendMessage(String(format:"C%d,%d",stateManager.playInfo.turnIndex,index))
    }
    
    func playPoker(_ index:Int) {
        streamManager.sendMessage(String(format:"P%d,%d",stateManager.playInfo.turnIndex,Int(cards[index])!))
        cards[index] = "0"
    }
}
