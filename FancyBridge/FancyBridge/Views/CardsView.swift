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
            addConstraint(NSLayoutConstraint(item: cardView, attribute: .height, relatedBy: .equal, toItem: cardView, attribute: .width, multiplier: 1.68, constant: 0))
            
            if i == 0 || i == HandCardsCount/2 + 1 {
                addConstraint(NSLayoutConstraint(item: cardView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0))
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
    func setHandCards(_ cardsText:[String]) {
        for i in 0..<HandCardsCount {
            cards[i].tag = i
            cards[i].setCard(Int(cardsText[i])!)
        }
    }
    
    func setEnable(_ isEnable:Bool) {
        for cardView in cards {
            cardView.setEnable(isEnable)
        }
    }
    
    func resetCard() {
        for cardView in cards {
            cardView.isHidden = false
            cardView.resetPosition()
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
    }
    
    // MARK: - CardViewDelegate
    func confirmPoker(_ index:Int) {
        PokerManager.getInstance().playPoker(index)
        cards[index].isHidden = true
        setEnable(false)
    }

}
