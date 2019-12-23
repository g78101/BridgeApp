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
    static let TrumpType = ["border-small","border-middle","border-clubs","border-diamand","border-heart","border-spade","border-notrump"]
    static let TeamInfoText = "Our Team: %d/%d\nEnemy Team: %d/%d"
    static let TunrArray = [0,CGFloat(90.0 * Float.pi / 180.0),CGFloat(180 * Float.pi / 180.0),CGFloat(270.0 * Float.pi / 180.0)]
    
    // MARK: - UI Member
    var cardsView:CardsView = CardsView()
    var rightCardsView:CardsView = CardsView()
    var leftCardsView:CardsView = CardsView()
    var topCardsView:CardsView = CardsView()
    var turnView:UIImageView = UIImageView()
    var tableIndex:[UILabel] = Array<UILabel>()
    var tablePokers:[CardView] = Array<CardView>()
    var titleView:UIView = UIView()
    var teamInfo:UILabel = UILabel()
    var trumpNumber:UILabel = UILabel()
    var trumpType:UIImageView = UIImageView()
    var lineView:UIView = UIView()
    var history:UIButton = UIButton()
    var finishView:FinishView = FinishView()
    
    var judgeTimer:Timer?
    var animationIndex:Int = -1
    
    // MARK: - Member
    var pokerManager:PokerManager!
    var stateManager:StateManager!
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        pokerManager = PokerManager.getInstance()
        stateManager = StateManager.getInstance()
        
        self.isHidden = true
        
        self.translatesAutoresizingMaskIntoConstraints = false
        turnView.translatesAutoresizingMaskIntoConstraints = false
        titleView.translatesAutoresizingMaskIntoConstraints = false
        teamInfo.translatesAutoresizingMaskIntoConstraints = false
        trumpNumber.translatesAutoresizingMaskIntoConstraints = false
        trumpType.translatesAutoresizingMaskIntoConstraints = false
        history.translatesAutoresizingMaskIntoConstraints = false
        lineView.translatesAutoresizingMaskIntoConstraints = false
        finishView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(cardsView)
        self.addSubview(leftCardsView)
        self.addSubview(topCardsView)
        self.addSubview(rightCardsView)
        self.addSubview(turnView)
        self.addSubview(history)
        
        self.addSubview(titleView)
        titleView.addSubview(trumpNumber)
        titleView.addSubview(trumpType)
        titleView.addSubview(lineView)
        titleView.addSubview(teamInfo)
        
        for _ in 0..<4 {
            let cardView:CardView = CardView()
            cardView.translatesAutoresizingMaskIntoConstraints = false
            cardView.setEnable(false)
            tablePokers.append(cardView)
            self.addSubview(cardView)
            
            let indexText:UILabel = UILabel()
            indexText.translatesAutoresizingMaskIntoConstraints = false
            indexText.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            indexText.textColor = UIColor.white
            indexText.textAlignment = .center
            
            tableIndex.append(indexText)
            self.addSubview(indexText)
        }
        self.addSubview(finishView)
        
        history.addTarget(self, action: #selector(self.touchUpInside(_:)), for: .touchUpInside)
        
        leftCardsView.otherPlayer()
        leftCardsView.setSmallFont()
        leftCardsView.setEnable(false)
        rightCardsView.otherPlayer()
        rightCardsView.setSmallFont()
        rightCardsView.setEnable(false)
        topCardsView.setSmallFont()
        topCardsView.setEnable(false)
        turnView.image = UIImage(named: "turn")
        
        trumpNumber.textAlignment = .center
        trumpNumber.font = UIFont.systemFont(ofSize: 40, weight: .medium)
        trumpNumber.textColor = UIColor.white
        
        lineView.backgroundColor = UIColor(red: 53.0/255, green: 182.0/255, blue: 128.0/255, alpha: 1.0)
        
        teamInfo.numberOfLines = 0
        teamInfo.adjustsFontSizeToFitWidth = true
        teamInfo.textColor = UIColor.white
        teamInfo.font = UIFont.systemFont(ofSize: 17)
        
        finishView.isHidden = true
        
        titleView.backgroundColor = UIColor(red: 0, green: 146.0/255, blue: 87.0/255, alpha: 1.0)
        history.setBackgroundImage(UIImage(named: "history-btn"), for: .normal)
        
        // cardsView
        addConstraint(NSLayoutConstraint(item: cardsView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -15))
        addConstraint(NSLayoutConstraint(item: cardsView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: cardsView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.95, constant: 0))
        addConstraint(NSLayoutConstraint(item: cardsView, attribute: .height, relatedBy: .equal, toItem: cardsView, attribute: .width, multiplier: 0.129 * 3, constant: 0))
        
        // finishView
        addConstraint(NSLayoutConstraint(item: finishView, attribute: .centerX, relatedBy: .equal, toItem: turnView, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: finishView, attribute: .centerY, relatedBy: .equal, toItem: turnView, attribute: .centerY, multiplier: 1.0, constant: -13))
        addConstraint(NSLayoutConstraint(item: finishView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 300))
        addConstraint(NSLayoutConstraint(item: finishView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 421))
        
        let move:CGFloat = ( UIScreen.main.bounds.size.height > 568 ) ? 145 : 125
        
        // leftCardsView
        addConstraint(NSLayoutConstraint(item: leftCardsView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 20))
        addConstraint(NSLayoutConstraint(item: leftCardsView, attribute: .centerX, relatedBy: .equal, toItem: turnView, attribute: .centerX, multiplier: 1.0, constant: -1 * move))
        addConstraint(NSLayoutConstraint(item: leftCardsView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 0))
        addConstraint(NSLayoutConstraint(item: leftCardsView, attribute: .height, relatedBy: .equal, toItem: cardsView, attribute: .width, multiplier: 0.129 * 1.5, constant: 0))
        leftCardsView.transform = CGAffineTransform(rotationAngle: CGFloat(90.0 * Float.pi / 180.0) )
        
        // topCardsView
        addConstraint(NSLayoutConstraint(item: topCardsView, attribute: .top, relatedBy: .equal, toItem: titleView, attribute: .bottom, multiplier: 1.0, constant: 35))
        addConstraint(NSLayoutConstraint(item: topCardsView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: topCardsView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 0))
        addConstraint(NSLayoutConstraint(item: topCardsView, attribute: .height, relatedBy: .equal, toItem: cardsView, attribute: .width, multiplier: 0.129 * 1.5, constant: 0))
        
        // rightCardsView
        addConstraint(NSLayoutConstraint(item: rightCardsView, attribute: .centerY, relatedBy: .equal, toItem: turnView, attribute: .centerY, multiplier: 1.0, constant: -20))
        addConstraint(NSLayoutConstraint(item: rightCardsView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: move))
        addConstraint(NSLayoutConstraint(item: rightCardsView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 0))
        addConstraint(NSLayoutConstraint(item: rightCardsView, attribute: .height, relatedBy: .equal, toItem: cardsView, attribute: .width, multiplier: 0.129 * 1.5, constant: 0))
        rightCardsView.transform = CGAffineTransform(rotationAngle: CGFloat(270.0 * Float.pi / 180.0) )
        
        // turnView
        addConstraint(NSLayoutConstraint(item: turnView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 35))
        addConstraint(NSLayoutConstraint(item: turnView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        turnView.addConstraint(NSLayoutConstraint(item: turnView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 70))
        turnView.addConstraint(NSLayoutConstraint(item: turnView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 70))
        
        // tableIndex[0]
        addConstraint(NSLayoutConstraint(item: tableIndex[0], attribute: .top, relatedBy: .equal, toItem: turnView, attribute: .centerY, multiplier: 1.0, constant: 13))
        addConstraint(NSLayoutConstraint(item: tableIndex[0], attribute: .centerX, relatedBy: .equal, toItem: turnView, attribute: .centerX, multiplier: 1.0, constant: 0))
        tableIndex[0].addConstraint(NSLayoutConstraint(item: tableIndex[0], attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 10))
        tableIndex[0].addConstraint(NSLayoutConstraint(item: tableIndex[0], attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 16))
        // tableIndex[1]
        addConstraint(NSLayoutConstraint(item: tableIndex[1], attribute: .centerY, relatedBy: .equal, toItem: turnView, attribute: .centerY, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: tableIndex[1], attribute: .right, relatedBy: .equal, toItem: turnView, attribute: .centerX, multiplier: 1.0, constant: -14))
        tableIndex[1].addConstraint(NSLayoutConstraint(item: tableIndex[1], attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 10))
        tableIndex[1].addConstraint(NSLayoutConstraint(item: tableIndex[1], attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 16))
        
        // tableIndex[2]
        addConstraint(NSLayoutConstraint(item: tableIndex[2], attribute: .bottom, relatedBy: .equal, toItem: turnView, attribute: .centerY, multiplier: 1.0, constant: -13))
        addConstraint(NSLayoutConstraint(item: tableIndex[2], attribute: .centerX, relatedBy: .equal, toItem: turnView, attribute: .centerX, multiplier: 1.0, constant: 0))
        tableIndex[2].addConstraint(NSLayoutConstraint(item: tableIndex[2], attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 10))
        tableIndex[2].addConstraint(NSLayoutConstraint(item: tableIndex[2], attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 16))
        
        // tableIndex[3]
        addConstraint(NSLayoutConstraint(item: tableIndex[3], attribute: .centerY, relatedBy: .equal, toItem: turnView, attribute: .centerY, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: tableIndex[3], attribute: .left, relatedBy: .equal, toItem: turnView, attribute: .centerX, multiplier: 1.0, constant: 14))
        tableIndex[3].addConstraint(NSLayoutConstraint(item: tableIndex[3], attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 10))
        tableIndex[3].addConstraint(NSLayoutConstraint(item: tableIndex[3], attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 16))
        
        // tablePokers[0]
        addConstraint(NSLayoutConstraint(item: tablePokers[0], attribute: .top, relatedBy: .equal, toItem: turnView, attribute: .centerY, multiplier: 1.0, constant: 40))
        addConstraint(NSLayoutConstraint(item: tablePokers[0], attribute: .centerX, relatedBy: .equal, toItem: turnView, attribute: .centerX, multiplier: 1.0, constant: 0))
        tablePokers[0].addConstraint(NSLayoutConstraint(item: tablePokers[0], attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 46))
        tablePokers[0].addConstraint(NSLayoutConstraint(item: tablePokers[0], attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 70))
        
        // tablePokers[1]
        addConstraint(NSLayoutConstraint(item: tablePokers[1], attribute: .centerY, relatedBy: .equal, toItem: turnView, attribute: .centerY, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: tablePokers[1], attribute: .right, relatedBy: .equal, toItem: turnView, attribute: .centerX, multiplier: 1.0, constant: -40))
        tablePokers[1].addConstraint(NSLayoutConstraint(item: tablePokers[1], attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 46))
        tablePokers[1].addConstraint(NSLayoutConstraint(item: tablePokers[1], attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 70))
        
        // tablePokers[2]
        addConstraint(NSLayoutConstraint(item: tablePokers[2], attribute: .bottom, relatedBy: .equal, toItem: turnView, attribute: .centerY, multiplier: 1.0, constant: -40))
        addConstraint(NSLayoutConstraint(item: tablePokers[2], attribute: .centerX, relatedBy: .equal, toItem: turnView, attribute: .centerX, multiplier: 1.0, constant: 0))
        tablePokers[2].addConstraint(NSLayoutConstraint(item: tablePokers[2], attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 46))
        tablePokers[2].addConstraint(NSLayoutConstraint(item: tablePokers[2], attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 70))
        
        // tablePokers[3]
        addConstraint(NSLayoutConstraint(item: tablePokers[3], attribute: .centerY, relatedBy: .equal, toItem: turnView, attribute: .centerY, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: tablePokers[3], attribute: .left, relatedBy: .equal, toItem: turnView, attribute: .centerX, multiplier: 1.0, constant: 40))
        tablePokers[3].addConstraint(NSLayoutConstraint(item: tablePokers[3], attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 46))
        tablePokers[3].addConstraint(NSLayoutConstraint(item: tablePokers[3], attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 70))
        
        // history
        addConstraint(NSLayoutConstraint(item: history, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -5))
        addConstraint(NSLayoutConstraint(item: history, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -10))
        addConstraint(NSLayoutConstraint(item: history, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40))
        addConstraint(NSLayoutConstraint(item: history, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40))
        
        // titleView
        addConstraint(NSLayoutConstraint(item: titleView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: titleView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: titleView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: titleView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 95))
        
        // lineView
        titleView.addConstraint(NSLayoutConstraint(item: lineView, attribute: .centerX, relatedBy: .equal, toItem: titleView, attribute: .centerX, multiplier: 1.0, constant: 0))
        titleView.addConstraint(NSLayoutConstraint(item: lineView, attribute: .top, relatedBy: .equal, toItem: titleView, attribute: .top, multiplier: 1.0, constant: 42))
        titleView.addConstraint(NSLayoutConstraint(item: lineView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1))
        titleView.addConstraint(NSLayoutConstraint(item: lineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 33))
        
        // trumpNumber
        titleView.addConstraint(NSLayoutConstraint(item: trumpNumber, attribute: .centerY, relatedBy: .equal, toItem: lineView, attribute: .centerY, multiplier: 1.0, constant: 0))
        titleView.addConstraint(NSLayoutConstraint(item: trumpNumber, attribute: .right, relatedBy: .equal, toItem: trumpType, attribute: .left, multiplier: 1.0, constant: -3))
        titleView.addConstraint(NSLayoutConstraint(item: trumpNumber, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 25))
        titleView.addConstraint(NSLayoutConstraint(item: trumpNumber, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 48))
        
        // trumpType
        titleView.addConstraint(NSLayoutConstraint(item: trumpType, attribute: .centerY, relatedBy: .equal, toItem: lineView, attribute: .centerY, multiplier: 1.0, constant: 0))
        titleView.addConstraint(NSLayoutConstraint(item: trumpType, attribute: .right, relatedBy: .equal, toItem: lineView, attribute: .left, multiplier: 1.0, constant: -39))
        titleView.addConstraint(NSLayoutConstraint(item: trumpType, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50))
        titleView.addConstraint(NSLayoutConstraint(item: trumpNumber, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 32))
        
        // teamInfo
        titleView.addConstraint(NSLayoutConstraint(item: teamInfo, attribute: .centerY, relatedBy: .equal, toItem: lineView, attribute: .centerY, multiplier: 1.0, constant: 0))
        titleView.addConstraint(NSLayoutConstraint(item: teamInfo, attribute: .centerX, relatedBy: .equal, toItem: lineView, attribute: .centerX, multiplier: 1.55, constant: 0))
        titleView.addConstraint(NSLayoutConstraint(item: teamInfo, attribute: .width, relatedBy: .equal, toItem: titleView, attribute: .width, multiplier: 0.45, constant: 0))
        titleView.addConstraint(NSLayoutConstraint(item: teamInfo, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50))
        
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
            LoadingView.StopLoading()
            InfoView.clear()
            if !setHidden {
                cardsView.setHandCards(pokerManager.cards)
                cardsView.tag = stateManager.playInfo.turnIndex
                leftCardsView.tag = (stateManager.playInfo.turnIndex+1)%4
                topCardsView.tag = (stateManager.playInfo.turnIndex+2)%4
                rightCardsView.tag = (stateManager.playInfo.turnIndex+3)%4
                
                cardsView.resetCard()
                leftCardsView.resetCard()
                topCardsView.resetCard()
                rightCardsView.resetCard()
                
                // Three Mode
                if pokerManager.threeMode && pokerManager.twoCardsPlay() {
                    topCardsView.setHandCards(pokerManager.otherCards)
                    topCardsView.transform = CGAffineTransform.init(scaleX: 1.6, y: 1.6)
                }
                else {
                    topCardsView.otherPlayer()
                    topCardsView.transform = CGAffineTransform(rotationAngle: CGFloat(180.0 * Float.pi / 180.0) )
                }
                
                cardsView.checkCardsPlay()
                topCardsView.checkCardsPlay()

                if pokerManager.comIndex == leftCardsView.tag {
                    leftCardsView.setHandCards(pokerManager.otherCards)
                }
                else {
                    leftCardsView.otherPlayer()
                }
                if pokerManager.comIndex == rightCardsView.tag {
                    rightCardsView.setHandCards(pokerManager.otherCards)
                }
                else {
                    rightCardsView.otherPlayer()
                }
                
                updateTitleView()
                updateScoreView()
                updateTurnView(-1)
                
                var k = stateManager.playInfo.turnIndex
                for i in 0..<4 {
                    tableIndex[i].text = String(format:"%d",k+1)
                    k=(k+1)%4
                }
            }
        }
    }
    
    // MARK: - Functions
    func updateTitleView() {
        trumpNumber.text = String(format:"%d",pokerManager.trump/7+1)
        trumpType.image = UIImage(named: PlayView.TrumpType[pokerManager.trump%7])
    }
    
    func updateScoreView() {
        teamInfo.text = String(format:PlayView.TeamInfoText,pokerManager.ourScroe,pokerManager.winNumber,pokerManager.enemyScroe,PokerManager.totalSum-pokerManager.winNumber)
    }
    
    func updateTurnView(_ type:Int) {
        
        if (judgeTimer != nil) {
            judgeTimer?.invalidate()
            judgeTimer = nil
        }
        
        for i in 0..<4 {
            tableIndex[i].textColor = UIColor.white
        }
        
        if type == -1 || type == PlayState.Normal.rawValue {
            var k = stateManager.playInfo.turnIndex
            for i in 0..<4 {
                if k==pokerManager.turnIndex {
                    turnView.transform = CGAffineTransform(rotationAngle:PlayView.TunrArray[i] )
                    tableIndex[i].textColor = UIColor.black
                    break
                }
                k=(k+1)%4
            }
            animationIndex = (pokerManager.turnIndex+1)%4
        }
        else {
            judgeTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.turnViewAnimation), userInfo: nil, repeats: true)
        }
    }
    
    @objc func turnViewAnimation() {
        turnView.transform = CGAffineTransform(rotationAngle:PlayView.TunrArray[animationIndex] )
        for i in 0..<4 {
            tableIndex[i].textColor = UIColor.white
        }
        tableIndex[animationIndex].textColor = UIColor.black
        animationIndex = (animationIndex+1)%4
    }
    
    
    // MARK: - Action
    @objc func touchUpInside(_ sender:UIButton) {
        InfoView.show()
    }
    
    // MARK: - StateManagerPlayDelegate
    func updatePlayingUI(_ poker: Int, _ type: Int, _ lastUser: Int) {
        
        let myTurnIndex = stateManager.playInfo.turnIndex
        cardsView.checkCardsPlay()
        
        if pokerManager.twoCardsPlay() {
            topCardsView.checkCardsPlay()
        }
        
        var k = myTurnIndex
        for i in 0..<4 {
            if poker == 0 {
                tablePokers[i].setCard(-1)
            }
            else if k==lastUser {
                tablePokers[i].setCard(poker)
                break
            }
            k=(k+1)%4
        }
        
        if lastUser != myTurnIndex && poker != 0 {
            if (myTurnIndex+1)%4 == lastUser {
                if pokerManager.comIndex == leftCardsView.tag {
                    leftCardsView.setCardHidden(poker)
                }
                else {
                    leftCardsView.playingCard()
                }
            }
            else if (myTurnIndex+2)%4 == lastUser {
                if !pokerManager.twoCardsPlay() {
                    topCardsView.playingCard()
                }
            }
            else {
                if pokerManager.comIndex == rightCardsView.tag {
                    rightCardsView.setCardHidden(poker)
                }
                else {
                    rightCardsView.playingCard()
                }
            }
        }
        
        updateTurnView(type)
        
        if poker == 0 {
            cardsView.checkCardsPlay()
            topCardsView.checkCardsPlay()
            if (lastUser==myTurnIndex||lastUser==(myTurnIndex+2)%4) {
                pokerManager.enemyScroe += 1
            }
            else {
                pokerManager.ourScroe += 1
            }
            
            updateScoreView()
            
            if (stateManager.isGameOver) {
                stateManager.interruptConnect()
                finishView.isHidden = false
                finishView.setInfo(pokerManager.ourScroe < pokerManager.winNumber)
            }
        }
    }
}
