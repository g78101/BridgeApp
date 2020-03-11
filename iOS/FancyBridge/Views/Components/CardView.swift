//
//  CardView.swift
//  FancyBridge
//
//  Created by Talka_Ying on 2018/2/8.
//  Copyright © 2018年 Talka_Ying. All rights reserved.
//

import UIKit

protocol CardViewDelegate:class {
    func confirmPoker(_ index:Int)
}

class CardView: UIView, PlayCardViewDelegate {
    
    // MARK: - UI Member
    var button:UIButton = UIButton()
    var bgImageView:UIImageView = UIImageView()
    var numberLabel:UILabel = UILabel()
    var flowerImageView:UIImageView = UIImageView()
    // MARK: - Member
    var value:Int = 0
    var pokerManager:PokerManager!
    weak var delegate:CardViewDelegate!
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius=3.5
        pokerManager = PokerManager.getInstance()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        flowerImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(bgImageView)
        self.addSubview(numberLabel)
        self.addSubview(flowerImageView)
        self.addSubview(button)
        
        addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.68, constant: 0))
        
        numberLabel.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        numberLabel.textAlignment = .center
        
        button.addTarget(self, action: #selector(self.touchUpInside(_:)), for: .touchUpInside)
        
        addConstraint(NSLayoutConstraint(item: bgImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: bgImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: bgImageView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: bgImageView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: numberLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 3))
        addConstraint(NSLayoutConstraint(item: numberLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: numberLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.9, constant: 0))
        addConstraint(NSLayoutConstraint(item: numberLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.543, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: (flowerImageView), attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -5))
        addConstraint(NSLayoutConstraint(item: (flowerImageView), attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: (flowerImageView), attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 0))
        addConstraint(NSLayoutConstraint(item: (flowerImageView), attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.371, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    func setCard(_ card:Int) {
        value = card
        if (card == -1) {
            bgImageView.image = nil
            numberLabel.text = ""
            flowerImageView.image = nil
        }
        else if(card==0) {
            bgImageView.image = UIImage(named:"card-back")
            numberLabel.text = ""
            flowerImageView.image = nil
        }
        else {
            let numberIndex = (card-1)%13
            let flowerIndex = (card-1)/13
            
            bgImageView.image = UIImage(named:"card-bg")
            numberLabel.text = PokerManager.Numbers[numberIndex]
            numberLabel.textColor = PokerManager.Colors[flowerIndex%2]
            flowerImageView.image = UIImage(named:PokerManager.Flowers[flowerIndex])
        }
    }
    
    func setSmallFont() {
        numberLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        if UIScreen.main.bounds.size.height <= 568 {
            for constraint in constraints {
                if constraint.firstItem?.classForCoder == UIImageView.classForCoder() &&
                    constraint.firstAttribute == .bottom {
                    constraint.constant = -1
                }
            }
        }
    }
    
    func setEnable(_ flag:Bool) {
        button.isEnabled = flag
    }
    
    func setCanPlayShow(_ flag:Bool) {
        
        let alpha:CGFloat = flag ? 1.0 : 0.5
        
        numberLabel.alpha = alpha
        flowerImageView.alpha = alpha
        
        setEnable(flag)
    }
    
    func checkCardCanPlay(_ haveFlower:Bool, _ cardsIndex:Int) {
        
        if haveFlower && (value-1)/13 != pokerManager.currentFlower {
            self.setCanPlayShow(false)
        }
        else {
            self.setCanPlayShow(true)
        }
    }
    
    @objc func touchUpInside(_ sender:UIButton) {
        
        let myTurn:Bool = pokerManager.turnIndex == StateManager.getInstance().playInfo.turnIndex
        let poker = Int( myTurn ? pokerManager.cards[self.tag] : pokerManager.otherCards[self.tag] )!
        
        let playCardView = PlayCardView()
        playCardView.delegate = self
        playCardView.addToTopView(poker)
    }
    
    func confirmPoker(_ index: Int) {
        value = 0
        if (self.delegate != nil) {
            self.delegate.confirmPoker(self.tag)
        }
    }
}
