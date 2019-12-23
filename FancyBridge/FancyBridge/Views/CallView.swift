//
//  CallView.swift
//  FancyBridge
//
//  Created by Talka_Ying on 2018/2/10.
//  Copyright © 2018年 Talka_Ying. All rights reserved.
//

import UIKit

class CallView: UIView, PokerManagerDelegate, StateManagerCallDelegate {
    
    // MARK: - UI Member
    var cardsView:CardsView = CardsView()
    var namesLabel:NamesLabel = NamesLabel()
    var playersCall:InfoCallView = InfoCallView()
    var callButtonsView:UIView = UIView()
    var callButtons:[UIButton] = Array<UIButton>()
    var passButton:UIButton = UIButton()
    var selectPartnerView:SelectPartnerView = SelectPartnerView()
    
    // MARK: - Member
    var pokerManager:PokerManager!
    var stateManager:StateManager!
    var isClicked = false
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        pokerManager = PokerManager.getInstance()
        stateManager = StateManager.getInstance()
        
        self.isHidden = true
        self.translatesAutoresizingMaskIntoConstraints = false
        callButtonsView.translatesAutoresizingMaskIntoConstraints = false
        passButton.translatesAutoresizingMaskIntoConstraints = false
        
    
        self.addSubview(playersCall)

        
        callButtonsView.backgroundColor = UIColor.init(red: 88.0/255, green: 199.0/255, blue: 154.0/255, alpha: 1.0)
        callButtonsView.layer.borderWidth = 1
        callButtonsView.layer.borderColor = UIColor.white.cgColor
        
        passButton.tag = -1
        passButton.addTarget(self, action: #selector(touchUpInside(_:)), for: .touchUpInside)
        passButton.setTitle("PASS", for: .normal)
        passButton.setTitleColor(UIColor.white, for: .normal)
        passButton.setTitleColor(UIColor.lightGray, for: .disabled)
        passButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        
        passButton.layer.borderWidth = 0.5
        passButton.layer.borderColor = UIColor.white.cgColor
        
        namesLabel.setFontSize(15)
        namesLabel.backgroundColor = UIColor(white: 0, alpha: 0.2)
        
        self.addSubview(namesLabel)
        self.addSubview(cardsView)
        self.addSubview(callButtonsView)
        self.addSubview(selectPartnerView)
        
        let height:CGFloat = ( UIScreen.main.bounds.size.height > 667 ) ? 50 : 30
        
        // cardsView
        addConstraint(NSLayoutConstraint(item: cardsView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: height))
        addConstraint(NSLayoutConstraint(item: cardsView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: cardsView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.95, constant: 0))
        addConstraint(NSLayoutConstraint(item: cardsView, attribute: .height, relatedBy: .equal, toItem: cardsView, attribute: .width, multiplier: 0.384, constant: 0))
        
        // namesLabel
        addConstraint(NSLayoutConstraint(item: namesLabel, attribute: .top, relatedBy: .equal, toItem: cardsView, attribute: .bottom, multiplier: 1.0, constant: 15))
        addConstraint(NSLayoutConstraint(item: namesLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 12))
        addConstraint(NSLayoutConstraint(item: namesLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -12))
        addConstraint(NSLayoutConstraint(item: namesLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 36))
    
        addConstraint(NSLayoutConstraint(item: playersCall, attribute: .top, relatedBy: .equal, toItem: namesLabel, attribute: .bottom, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersCall, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier:1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersCall, attribute: .width, relatedBy: .equal, toItem: namesLabel, attribute: .width, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersCall, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 116))
        
        // callButtonsView
        addConstraint(NSLayoutConstraint(item: callButtonsView, attribute: .top, relatedBy: .equal, toItem: playersCall, attribute: .bottom, multiplier: 1.0, constant: 14))
        addConstraint(NSLayoutConstraint(item: callButtonsView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 12))
        addConstraint(NSLayoutConstraint(item: callButtonsView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -12))
        addConstraint(NSLayoutConstraint(item: callButtonsView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -42))
        
        // selectPartnerView
        addConstraint(NSLayoutConstraint(item: selectPartnerView, attribute: .top, relatedBy: .equal, toItem: callButtonsView, attribute: .top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: selectPartnerView, attribute: .left, relatedBy: .equal, toItem: callButtonsView, attribute: .left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: selectPartnerView, attribute: .right, relatedBy: .equal, toItem: callButtonsView, attribute: .right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: selectPartnerView, attribute: .bottom, relatedBy: .equal, toItem: callButtonsView, attribute: .bottom, multiplier: 1.0, constant: 0))
        
        for i in 0..<49 {
            let callButton = UIButton()
            var flowerIndex = i%7-2
            callButton.tag = i
            callButton.translatesAutoresizingMaskIntoConstraints = false
            callButton.layer.borderWidth = 0.5
            callButton.layer.borderColor = UIColor.white.cgColor
            
            let attrString = NSMutableAttributedString(string:String(format: "%d", i/7+1), attributes:[NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17, weight: .medium)])
            
            if flowerIndex >= 0 && flowerIndex < 4 {
                
                if flowerIndex == 0 {
                    flowerIndex=1
                }
                else if flowerIndex == 1 {
                    flowerIndex=0
                }
                
                callButton.titleLabel?.textAlignment = .center
                callButton.setImage(UIImage(named:PokerManager.Flowers[flowerIndex]), for: .normal)
                callButton.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
                callButton.imageView?.translatesAutoresizingMaskIntoConstraints = false
                
                callButton.addConstraint(NSLayoutConstraint(item: callButton.titleLabel!, attribute: .left, relatedBy: .equal, toItem: callButton, attribute: .left, multiplier: 1.0, constant: 0))
                callButton.addConstraint(NSLayoutConstraint(item: callButton.titleLabel!, attribute: .centerY, relatedBy: .equal, toItem: callButton, attribute: .centerY, multiplier: 1.0, constant: 0))
                callButton.addConstraint(NSLayoutConstraint(item: callButton.titleLabel!, attribute: .width, relatedBy: .equal, toItem: callButton, attribute: .width, multiplier: 0.5, constant: 0))
                callButton.addConstraint(NSLayoutConstraint(item: callButton.titleLabel!, attribute: .height, relatedBy: .equal, toItem: callButton, attribute: .height, multiplier: 1.0, constant: 0))
                
                callButton.addConstraint(NSLayoutConstraint(item: callButton.imageView!, attribute: .right, relatedBy: .equal, toItem: callButton, attribute: .right, multiplier: 1.0, constant: -5))
                callButton.addConstraint(NSLayoutConstraint(item: callButton.imageView!, attribute: .centerY, relatedBy: .equal, toItem: callButton, attribute: .centerY, multiplier: 1.0, constant: 0))
                callButton.addConstraint(NSLayoutConstraint(item: callButton.imageView!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 19))
                callButton.addConstraint(NSLayoutConstraint(item: callButton.imageView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 19))
            }
            else {
                var str = " "
                
                if(i%7==0) {
                    str += "SM"
                }
                else if(i%7==1) {
                    str += "MD"
                }
                else if(i%7==6) {
                    str += "NT"
                }
                
                attrString.append(NSMutableAttributedString(string: str,attributes:[NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15, weight: .medium)]))
            }
            let grayAttrString = NSMutableAttributedString(string:attrString.string, attributes:[NSAttributedString.Key.foregroundColor:UIColor(white: 1.0, alpha: 0.5),NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17, weight: .medium)])
            
            callButton.setAttributedTitle(attrString, for: .normal)
            callButton.setAttributedTitle(grayAttrString, for: .disabled)
            callButton.setAttributedTitle(grayAttrString, for: .highlighted)
            callButtonsView.addSubview(callButton)
            
            if i%7==0 {
                if i==0 {
                    addConstraint(NSLayoutConstraint(item: callButton, attribute: .top, relatedBy: .equal, toItem: callButtonsView, attribute: .top, multiplier: 1.0, constant: 0))
                }
                else {
                    addConstraint(NSLayoutConstraint(item: callButton, attribute: .top, relatedBy: .equal, toItem: callButtons[(i/7-1)*7], attribute: .bottom, multiplier: 1.0, constant: 0))
                }
                addConstraint(NSLayoutConstraint(item: callButton, attribute: .left, relatedBy: .equal, toItem: callButtonsView, attribute: .left, multiplier: 1.0, constant: 0))
            }
            else {
                addConstraint(NSLayoutConstraint(item: callButton, attribute: .top, relatedBy: .equal, toItem: callButtons[i/7*7], attribute: .top, multiplier: 1.0, constant: 0))
                addConstraint(NSLayoutConstraint(item: callButton, attribute: .left, relatedBy: .equal, toItem: callButtons[i-1], attribute: .right, multiplier: 1.0, constant: 0))
            }
            
            addConstraint(NSLayoutConstraint(item: callButton, attribute: .width, relatedBy: .equal, toItem: callButtonsView, attribute: .width, multiplier: 0.1428, constant: 0))
            addConstraint(NSLayoutConstraint(item: callButton, attribute: .height, relatedBy: .equal, toItem: callButtonsView, attribute: .height, multiplier: 0.125, constant: 0))
            
            callButtons.append(callButton)
            callButton.addTarget(self, action: #selector(self.touchUpInside(_:)), for: .touchUpInside)
        }
        callButtonsView.addSubview(passButton)
        
        // passButton
        addConstraint(NSLayoutConstraint(item: passButton, attribute: .height, relatedBy: .equal, toItem: callButtonsView, attribute: .height, multiplier: 0.125, constant: 0))
        addConstraint(NSLayoutConstraint(item: passButton, attribute: .left, relatedBy: .equal, toItem: callButtonsView, attribute: .left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: passButton, attribute: .right, relatedBy: .equal, toItem: callButtonsView, attribute: .right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: passButton, attribute: .bottom, relatedBy: .equal, toItem: callButtonsView, attribute: .bottom, multiplier: 1.0, constant: 0))
        
        cardsView.setEnable(false)
        pokerManager.delegate = self
        stateManager.callDelegate = self
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
            selectPartnerView.isHidden = true
            callButtonsView.isHidden = false
            
            if !setHidden {
                playersCall.reloadData()
                namesLabel.setPlayersName(stateManager.players)
                isClicked = false
                
                for callButton in callButtons {
                    callButton.isEnabled = true
                }
                
                pokerManager.delegate = self
                
                if pokerManager.turnIndex == stateManager.playInfo.turnIndex {
                    callButtonsView.alpha = 1.0
                }
                else {
                    callButtonsView.alpha = 0.5
                }
                
                if stateManager.playInfo.turnIndex == pokerManager.turnIndex {
                    AlertView.showViewSetText("You call first")
                }
            }
        }
    }
    
    // MARK: - Functions
    func setCardsForUI(_ cardArray: [String]) {
        cardsView.setHandCards(cardArray)
    }
    
    // MARK: - Action
    @objc func touchUpInside(_ sender:UIButton) {
        
        if pokerManager.turnIndex == stateManager.playInfo.turnIndex && !isClicked {
            if sender.tag == -1 {
                pokerManager.callTrump(sender.tag)
                isClicked = true
            }
            else {
                AlertView.showView(sender.tag)
            }
        }
    }
    
    // MARK: - StateManagerCallDelegate
    func updateCallingUI(_ index:Int) {
        for i in 0..<index+1 {
            callButtons[i].isEnabled = false
        }
        isClicked = false
        playersCall.reloadData()
        
        if pokerManager.turnIndex == stateManager.playInfo.turnIndex {
            callButtonsView.alpha = 1.0
        }
        else {
            callButtonsView.alpha = 0.5
        }
    }
    
    func showThreeModeUI(_ index:Int) {
        if index == stateManager.playInfo.turnIndex {
            selectPartnerView.isHidden = false
            callButtonsView.isHidden = true
        }
        else {
            LoadingView.StartLoading()
        }
    }
}
