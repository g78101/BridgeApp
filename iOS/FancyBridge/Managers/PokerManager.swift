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
    static var Flowers = ["card-diamand","card-clubs","card-heart","card-spade"]
    static var Numbers = ["A","2","3","4","5","6","7","8","9","10","J","Q","K"]
    static var Colors = [UIColor(red: 243.0/255, green: 77.0/255, blue: 70.0/255, alpha: 1.0),UIColor(white: 51.0/255, alpha: 1.0)]
    
    static let totalSum = 14
    //MARK: - Member
    weak var delegate:PokerManagerDelegate!
    var streamManager:StreamManager!
    var stateManager:StateManager!
    var cards:[String] = ["0","0","0","0","0","0","0","0","0","0","0","0","0"]
    var otherCards:[String] = ["0","0","0","0","0","0","0","0","0","0","0","0","0"]
    var callsRecord:[[Int]] = [[Int](),[Int](),[Int](),[Int]()]
    var playsRecord:[[Int]] = [[Int](),[Int](),[Int](),[Int]()]
    var boutsWinRecord:[Int] = Array<Int>()
    var flowerCountRecord:[Int] = [0,0,0,0]
    var turnIndex:Int = -1
    var trump:Int = -1
    var currentFlower = -1
    var winNumber:Int = -1
    var ourScroe:Int = 0
    var enemyScroe:Int = 0
    var threeMode = false
    var comIndex = -1
    
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
        otherCards.removeAll()
        callsRecord = [[Int](),[Int](),[Int](),[Int]()]
        playsRecord = [[Int](),[Int](),[Int](),[Int]()]
        boutsWinRecord.removeAll()
        flowerCountRecord = [0,0,0,0]
        
        turnIndex = -1
        trump = -1
        currentFlower = -1
        winNumber = -1
        ourScroe = 0
        enemyScroe = 0
        threeMode = false
        comIndex = -1
    }
    
    func setCards(_ cardArray:[String]) {
        cards = cardArray
        if (self.delegate != nil) {
            self.delegate.setCardsForUI(cards)
        }
    }
    
    func setOtherCards(_ cardArray:[String]) {
        otherCards = cardArray
    }
    
    func callTrump(_ index:Int) {
        streamManager.sendMessage(String(format:"C%d,%d",stateManager.playInfo.turnIndex,index))
    }
    
    func playPoker(_ poker:Int) {
        streamManager.sendMessage(String(format:"P%d,%d",turnIndex,poker))
    }
    
    func twoCardsPlay() -> Bool {
        let myTurnIndex = stateManager.playInfo.turnIndex
        return (myTurnIndex+2)%4 == comIndex
    }
    
    func canPlayCard() -> Bool {
        let myTurnIndex = stateManager.playInfo.turnIndex
        return myTurnIndex == turnIndex
    }
    
    func canPlayOtherCard() -> Bool {
        let otherTurnIndex = (stateManager.playInfo.turnIndex+2)%4
        return otherTurnIndex == turnIndex
    }
    
    func findMaxCallCount() -> Int {
        var max = 0
        for i in 0..<4 {
            let count = callsRecord[i].count
            if count > max {
                max = count
            }
        }
        return max
    }
    
    func findMaxPlayCount() -> Int {
        var max = 0
        for i in 0..<4 {
            let count = playsRecord[i].count
            if count > max {
                max = count
            }
        }
        return max
    }
}
