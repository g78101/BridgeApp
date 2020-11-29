//
//  CardsView.swift
//  FancyBridge
//
//  Created by Talka_Ying on 2019/2/11.
//  Copyright © 2019 Talka_Ying. All rights reserved.
//

import UIKit

class CardsView: UIView, CardViewDelegate {
    // MARK: - UI Member
    var cards:[CardView] = [CardView]()
    var cardsArray:[Int] = Array<Int>()
    var otherPlayerFlag = true
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        for i in 0..<HandCardsCount {
            
            let cardView = CardView()
            self.addSubview(cardView)
            cardView.delegate = self
            cards.append(cardView)
            
            addConstraint(NSLayoutConstraint(item: cardView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.1428, constant: -2))
            addConstraint(NSLayoutConstraint(item: cardView, attribute: .height, relatedBy: .equal, toItem: cardView, attribute: .width, multiplier: 1.52, constant: 0))
            
            if i == 0 || i == HandCardsCount/2 + 1 {
                addConstraint(NSLayoutConstraint(item: cardView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 5))
            }
            else {
                addConstraint(NSLayoutConstraint(item: cardView, attribute: .left, relatedBy: .equal, toItem: cards[i-1], attribute: .right, multiplier: 1.0, constant: 2))
            }
            
            addConstraint(NSLayoutConstraint(item: cardView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: (i <= HandCardsCount/2) ? 0.5 : 1.5, constant: 0 ))
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    func setSmallFont() {
        for i in 0..<HandCardsCount {
            cards[i].setSmallFont()
        }
    }
    
    func setHandCards(_ cardsText:[String]) {
        cardsArray.removeAll()
        for i in 0..<HandCardsCount {
            cards[i].tag = i
            cardsArray.append(Int(cardsText[i])!)
            cards[i].setCard(cardsArray[i])
        }
        if !cardsText.contains("0") {
            otherPlayerFlag = false
        }
    }
    
    func setEnable(_ isEnable:Bool) {
        for cardView in cards {
            cardView.setEnable(isEnable)
        }
    }
    
    func setCardHidden(_ card:Int) {
        for i in 0..<13 {
            if cardsArray[i] == card {
                cards[i].isHidden = true
                break
            }
        }
    }
    
    func setCanPlayShow(_ isEnable:Bool) {
        for cardView in cards {
            cardView.setCanPlayShow(isEnable)
        }
    }
    
    func resetCard() {
        for cardView in cards {
            cardView.isHidden = false
        }
        setHandCards(["0","0","0","0","0","0","0","0","0","0","0","0","0"])
        setEnable(false)
        otherPlayerFlag = true
        for constraint in constraints {
            if constraint.firstItem?.classForCoder == CardView.classForCoder() &&
                constraint.firstAttribute == .left &&
                constraint.secondAttribute == .right {
                constraint.constant = 2
            }
        }
    }
    
    func recoverCard() {
        if otherPlayerFlag {
            return
        }
        
        let pokerManager = PokerManager.getInstance()
        
        for i in 0..<pokerManager.playsRecord[self.tag].count {
            let poker = pokerManager.playsRecord[self.tag][i]
            let index = cardsArray.index(of: poker)!
            cardsArray[index] = 0
            cards[index].isHidden = true
            setEnable(false)
        }
    }
    
    func checkCardsPlay() {
        let pokerManager = PokerManager.getInstance()
        var haveFlower:Bool = false
        
        self.setCanPlayShow(false)
        
        if(pokerManager.currentFlower != -1) {
            if PokerManager.getInstance().turnIndex == self.tag {
                for i in 0..<13 {
                    let poker = cardsArray[i]
                    
                    if(poker != 0 && (poker-1)/13==pokerManager.currentFlower)
                    {
                        haveFlower = true
                        break
                    }
                }
                for i in 0..<13 {
                    cards[i].checkCardCanPlay(haveFlower,self.tag)
                }
            }
        }
        else if PokerManager.getInstance().turnIndex == self.tag {
            self.setCanPlayShow(true)
        }
    }
    
    func playingCard() {
        for cardView in cards.reversed() {
            if !cardView.isHidden {
                cardView.isHidden = true
                break
            }
        }
    }
    
    func otherPlayer() {
        setHandCards(["0","0","0","0","0","0","0","0","0","0","0","0","0"])
        setEnable(false)
        
        for constraint in constraints {
            if constraint.firstItem?.classForCoder == CardView.classForCoder() &&
                constraint.firstAttribute == .left &&
                constraint.secondAttribute == .right {
                constraint.constant = -3
            }
        }
    }
    
    // MARK: - CardViewDelegate
    func confirmPoker(_ index:Int) {
        if PokerManager.getInstance().turnIndex == self.tag {
            
            PokerManager.getInstance().playPoker(cardsArray[index])
            cardsArray[index] = 0
            cards[index].isHidden = true
            setEnable(false)
        }
    }
}
