//
//  PlayView.swift
//  FancyBridge
//
//  Created by Talka_Ying on 2019/2/18.
//  Copyright © 2019 Talka_Ying. All rights reserved.
//

import UIKit

class PlayView: UIView, StateManagerPlayDelegate {
    // MARK: - Const
    static let TrumpText = "%d%@!!!"
    static let TeamInfoText = "  Our Team\n\t\t\t\t\t%d / %d\n  Enemy Team\n\t\t\t\t\t%d / %d"
    static let TunrArray = ["↓","←","↑","→"]
    
    // MARK: - UI Member
    var cardsView:CardsView = CardsView()
    var rightCardsView:CardsView = CardsView()
    var leftCardsView:CardsView = CardsView()
    var topCardsView:CardsView = CardsView()
    var turnView:UILabel = UILabel()
    var tablePokers:[UIImageView] = Array<UIImageView>()
    var titleView:UIView = UIView()
    var teamInfo:UILabel = UILabel()
    var trump:UILabel = UILabel()
    var history:UIButton = UIButton()
    var again:UIButton = UIButton()
    
    // MARK: - Member
    var pokerManager:PokerManager!
    var stateManager:StateManager!
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        pokerManager = PokerManager.getInstance()
        stateManager = StateManager.getInstance()
        
        self.isHidden = true
        self.backgroundColor = UIColor.green
        
        self.translatesAutoresizingMaskIntoConstraints = false
        turnView.translatesAutoresizingMaskIntoConstraints = false
        titleView.translatesAutoresizingMaskIntoConstraints = false
        teamInfo.translatesAutoresizingMaskIntoConstraints = false
        trump.translatesAutoresizingMaskIntoConstraints = false
        history.translatesAutoresizingMaskIntoConstraints = false
        again.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(cardsView)
        self.addSubview(leftCardsView)
        self.addSubview(topCardsView)
        self.addSubview(rightCardsView)
        self.addSubview(turnView)
        self.addSubview(again)
        
        self.addSubview(titleView)
        titleView.addSubview(trump)
        titleView.addSubview(history)
        titleView.addSubview(teamInfo)
        
        for _ in 0..<4 {
            let imageView:UIImageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
//            imageView.layer.borderWidth = 1.0
            
            tablePokers.append(imageView)
            self.addSubview(imageView)
        }
        
        history.addTarget(self, action: #selector(self.touchUpInside(_:)), for: .touchUpInside)
        
        leftCardsView.otherPlayer()
        topCardsView.otherPlayer()
        rightCardsView.otherPlayer()
        turnView.text = ""
        
        trump.textAlignment = .center
        trump.font = UIFont.boldSystemFont(ofSize: 17)
        
        teamInfo.numberOfLines = 0
        teamInfo.adjustsFontSizeToFitWidth = true
        
        history.setTitle("History", for: .normal)
        history.setTitleColor(UIColor.black, for: .normal)
        
        again.setTitle("Play Again", for: .normal)
        again.setBackgroundColor(UIColor(red: 1.0, green: 250.0/255, blue: 201.0/255, alpha: 1.0), for: .normal)
        again.setTitleColor(UIColor.black, for: .normal)
        again.isHidden = true
        again.addTarget(self, action: #selector(reconnect(_:)), for: .touchUpInside)
        again.layer.cornerRadius = 10.0
        again.layer.masksToBounds = true
        
        trump.layer.borderWidth = 1.0
        trump.layer.cornerRadius = 10.0
        history.layer.borderWidth = 1.0
        history.layer.cornerRadius = 10.0
        teamInfo.layer.borderWidth = 1.0
        teamInfo.layer.cornerRadius = 10.0
        
        titleView.backgroundColor = UIColor(white: 241.0/255, alpha: 1.0)
        history.setBackgroundColor( UIColor.lightGray, for: .normal)
        history.setTitleColor(UIColor.lightText, for: .highlighted)
        history.layer.masksToBounds = true
        
        // cardsView
        addConstraint(NSLayoutConstraint(item: cardsView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -50))
        addConstraint(NSLayoutConstraint(item: cardsView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: cardsView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.95, constant: 0))
        addConstraint(NSLayoutConstraint(item: cardsView, attribute: .height, relatedBy: .equal, toItem: cardsView, attribute: .width, multiplier: 0.129 * 3, constant: 0))
        
        // again
        addConstraint(NSLayoutConstraint(item: again, attribute: .bottom, relatedBy: .equal, toItem: cardsView, attribute: .top, multiplier: 1.0, constant: 20))
        addConstraint(NSLayoutConstraint(item: again, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        again.addConstraint(NSLayoutConstraint(item: again, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100))
        again.addConstraint(NSLayoutConstraint(item: again, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0 * 3, constant: 40))
        
        // leftCardsView
        addConstraint(NSLayoutConstraint(item: leftCardsView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: leftCardsView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: -125))
        addConstraint(NSLayoutConstraint(item: leftCardsView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 0))
        addConstraint(NSLayoutConstraint(item: leftCardsView, attribute: .height, relatedBy: .equal, toItem: cardsView, attribute: .width, multiplier: 0.129 * 1.5, constant: 0))
        leftCardsView.transform = CGAffineTransform(rotationAngle: CGFloat(90.0 * Float.pi / 180.0) )
        
        // topCardsView
        addConstraint(NSLayoutConstraint(item: topCardsView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: -125))
        addConstraint(NSLayoutConstraint(item: topCardsView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: topCardsView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 0))
        addConstraint(NSLayoutConstraint(item: topCardsView, attribute: .height, relatedBy: .equal, toItem: cardsView, attribute: .width, multiplier: 0.129 * 1.5, constant: 0))
        topCardsView.transform = CGAffineTransform(rotationAngle: CGFloat(180.0 * Float.pi / 180.0) )

        // rightCardsView
        addConstraint(NSLayoutConstraint(item: rightCardsView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: rightCardsView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 125))
        addConstraint(NSLayoutConstraint(item: rightCardsView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 0))
        addConstraint(NSLayoutConstraint(item: rightCardsView, attribute: .height, relatedBy: .equal, toItem: cardsView, attribute: .width, multiplier: 0.129 * 1.5, constant: 0))
        rightCardsView.transform = CGAffineTransform(rotationAngle: CGFloat(270.0 * Float.pi / 180.0) )
        
        // turnView
        addConstraint(NSLayoutConstraint(item: turnView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: turnView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        turnView.addConstraint(NSLayoutConstraint(item: turnView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20))
        turnView.addConstraint(NSLayoutConstraint(item: turnView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20))
        
        // tablePokers[0]
        addConstraint(NSLayoutConstraint(item: tablePokers[0], attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 40))
        addConstraint(NSLayoutConstraint(item: tablePokers[0], attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        tablePokers[0].addConstraint(NSLayoutConstraint(item: tablePokers[0], attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 35))
        tablePokers[0].addConstraint(NSLayoutConstraint(item: tablePokers[0], attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 60))
        
        // tablePokers[1]
        addConstraint(NSLayoutConstraint(item: tablePokers[1], attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: tablePokers[1], attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: -35))
        tablePokers[1].addConstraint(NSLayoutConstraint(item: tablePokers[1], attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 35))
        tablePokers[1].addConstraint(NSLayoutConstraint(item: tablePokers[1], attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 60))
        
        // tablePokers[2]
        addConstraint(NSLayoutConstraint(item: tablePokers[2], attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: -40))
        addConstraint(NSLayoutConstraint(item: tablePokers[2], attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        tablePokers[2].addConstraint(NSLayoutConstraint(item: tablePokers[2], attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 35))
        tablePokers[2].addConstraint(NSLayoutConstraint(item: tablePokers[2], attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 60))
        
        // tablePokers[3]
        addConstraint(NSLayoutConstraint(item: tablePokers[3], attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: tablePokers[3], attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 35))
        tablePokers[3].addConstraint(NSLayoutConstraint(item: tablePokers[3], attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 35))
        tablePokers[3].addConstraint(NSLayoutConstraint(item: tablePokers[3], attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 60))
        
        // titleView
        addConstraint(NSLayoutConstraint(item: titleView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: titleView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: titleView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: titleView, attribute: .bottom, relatedBy: .equal, toItem: topCardsView, attribute: .top, multiplier: 1.0, constant: -20))
        
        // trump
        titleView.addConstraint(NSLayoutConstraint(item: trump, attribute: .top, relatedBy: .equal, toItem: titleView, attribute: .top, multiplier: 1.0, constant: 40))
        titleView.addConstraint(NSLayoutConstraint(item: trump, attribute: .left, relatedBy: .equal, toItem: titleView, attribute: .left, multiplier: 1.0, constant: 10))
        titleView.addConstraint(NSLayoutConstraint(item: trump, attribute: .width, relatedBy: .equal, toItem: titleView, attribute: .width, multiplier: 0.3333, constant: 0))
        trump.addConstraint(NSLayoutConstraint(item: trump, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30))
        
        // history
        titleView.addConstraint(NSLayoutConstraint(item: history, attribute: .top, relatedBy: .equal, toItem: trump, attribute: .bottom, multiplier: 1.0, constant: 10))
        titleView.addConstraint(NSLayoutConstraint(item: history, attribute: .left, relatedBy: .equal, toItem: trump, attribute: .left, multiplier: 1.0, constant: 10))
        titleView.addConstraint(NSLayoutConstraint(item: history, attribute: .right, relatedBy: .equal, toItem: trump, attribute: .right, multiplier: 1.0, constant: -10))
        titleView.addConstraint(NSLayoutConstraint(item: history, attribute: .bottom, relatedBy: .equal, toItem: titleView, attribute: .bottom, multiplier: 1.0, constant: -5))
        
        // teamInfo
        titleView.addConstraint(NSLayoutConstraint(item: teamInfo, attribute: .top, relatedBy: .equal, toItem: trump, attribute: .top, multiplier: 1.0, constant: 0))
        titleView.addConstraint(NSLayoutConstraint(item: teamInfo, attribute: .left, relatedBy: .equal, toItem: trump, attribute: .right, multiplier: 1.0, constant: 10))
        titleView.addConstraint(NSLayoutConstraint(item: teamInfo, attribute: .right, relatedBy: .equal, toItem: titleView, attribute: .right, multiplier: 1.0, constant: -10))
        titleView.addConstraint(NSLayoutConstraint(item: teamInfo, attribute: .bottom, relatedBy: .equal, toItem: history, attribute: .bottom, multiplier: 1.0, constant: 0))
        
        cardsView.setEnable(false)
        stateManager.playDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override
    override var isHidden: Bool {
        get {
            return super.isHidden
        }
        set (setHidden) {
            super.isHidden = setHidden
            
            if !setHidden {
                cardsView.setHandCards(pokerManager.cards)
                
                if stateManager.playInfo.turnIndex == pokerManager.turnIndex {
                    cardsView.setEnable(true)
                }
                cardsView.resetCard()
                leftCardsView.resetCard()
                topCardsView.resetCard()
                rightCardsView.resetCard()
                
                updateTitleView()
                updateScoreView()
                updateTurnView(-1)
            }
        }
    }
    
    // MARK: - Functions
    func updateTitleView() {
        trump.text = String(format:PlayView.TrumpText,pokerManager.trump/7+1,PokerManager.flowers[pokerManager.trump%7])
    }
    
    func updateScoreView() {
        teamInfo.text = String(format:PlayView.TeamInfoText,pokerManager.ourScroe,pokerManager.winNumber,pokerManager.enemyScroe,PokerManager.totalSum-pokerManager.winNumber)
    }
    
    func updateTurnView(_ type:Int) {
        
        if type == -1 || type == PlayState.Normal.rawValue {
            var k = stateManager.playInfo.turnIndex
            for i in 0..<4 {
                if k==pokerManager.turnIndex {
                    turnView.text = PlayView.TunrArray[i]
                    break
                }
                k=(k+1)%4
            }
        }
        else {
            turnView.text = "⊕"
        }
    }

    // MARK: - Action
    @objc func touchUpInside(_ sender:UIButton) {
        
        let infoView = InfoView()
        
        infoView.addToTopView()
    }
    
    @objc func reconnect(_ sender:UIButton) {
        again.isHidden = true
        pokerManager.reset()
        stateManager.reset()
        stateManager.connectServer()
    }
    
    // MARK: - StateManagerPlayDelegate
    func updatePlayingUI(_ poker: Int, _ type: Int, _ lastUser: Int) {
        
        let myTurnIndex = stateManager.playInfo.turnIndex
        cardsView.setEnable(myTurnIndex == pokerManager.turnIndex)
        
        var k = myTurnIndex
        for i in 0..<4 {
            if poker == 0 {
                tablePokers[i].image = nil
            }
            else if k==lastUser {
                tablePokers[i].image = UIImage(named:String(format:"Card%d",poker))
                break
            }
            k=(k+1)%4
        }
        
        if lastUser != myTurnIndex && poker != 0 {
            if (myTurnIndex+1)%4 == lastUser {
                leftCardsView.playingCard()
            }
            else if (myTurnIndex+2)%4 == lastUser {
                topCardsView.playingCard()
            }
            else {
                rightCardsView.playingCard()
            }
        }
        
        updateTurnView(type)
        
        if poker == 0 {
            
            if (lastUser==myTurnIndex||lastUser==(myTurnIndex+2)%4) {
                pokerManager.enemyScroe += 1
            }
            else {
                pokerManager.ourScroe += 1
            }
            
            updateScoreView()
            
            if (stateManager.isGameOver) {
                stateManager.interruptConnect()
                again.isHidden = false
                var message = "You Win ~~~"
                if pokerManager.ourScroe < pokerManager.winNumber {
                    message = " You Lose ..."
                }
                
                UIAlertController.showAlert(title: "Game Finish", message: message)
            }
        }
    }
}
