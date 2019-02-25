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
    var playersName:[UILabel] = Array<UILabel>()
    var playersCall:[UITextView] = Array<UITextView>()
    var callButtonsView:UIView = UIView()
    var callButtons:[UIButton] = Array<UIButton>()
    var passButton:UIButton = UIButton()
    
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
        callButtonsView.translatesAutoresizingMaskIntoConstraints = false
        callButtonsView.backgroundColor = UIColor.lightGray // test
        passButton.translatesAutoresizingMaskIntoConstraints = false
        
        for _ in 0..<4 {
            
            let name = UILabel()
            let call = UITextView()
            
            name.translatesAutoresizingMaskIntoConstraints = false
            call.translatesAutoresizingMaskIntoConstraints = false
            
            name.textAlignment = .center
            
            call.isSelectable = false
            call.isEditable = false
            call.textAlignment = .center
            call.layer.borderWidth = 1.0
            
            playersName.append(name)
            playersCall.append(call)
            
            self.addSubview(name)
            self.addSubview(call)
        }
        
        passButton.tag = -1
        passButton.addTarget(self, action: #selector(touchUpInside(_:)), for: .touchUpInside)
        passButton.setTitle("PASS", for: .normal)
        passButton.setBackgroundColor(UIColor.white, for: .normal)
        passButton.setTitleColor(UIColor.black, for: .normal)
        passButton.layer.borderWidth = 1.0
        passButton.layer.cornerRadius = 5.0
        
        self.addSubview(cardsView)
        self.addSubview(callButtonsView)
        self.addSubview(passButton)
        
        // cardsView
        addConstraint(NSLayoutConstraint(item: cardsView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 50))
        addConstraint(NSLayoutConstraint(item: cardsView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: cardsView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.95, constant: 0))
        addConstraint(NSLayoutConstraint(item: cardsView, attribute: .height, relatedBy: .equal, toItem: cardsView, attribute: .width, multiplier: 0.129 * 3, constant: 0))
        
        // playersName0
        addConstraint(NSLayoutConstraint(item: playersName[0], attribute: .top, relatedBy: .equal, toItem: cardsView, attribute: .bottom, multiplier: 1.0, constant: 5))
        addConstraint(NSLayoutConstraint(item: playersName[0], attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 0.25, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[0], attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.2, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[0], attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30))
        
        // playersName1
        addConstraint(NSLayoutConstraint(item: playersName[1], attribute: .top, relatedBy: .equal, toItem: playersName[0], attribute: .top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[1], attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 0.75, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[1], attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.2, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[1], attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30))
        
        // playersName2
        addConstraint(NSLayoutConstraint(item: playersName[2], attribute: .top, relatedBy: .equal, toItem: playersName[0], attribute: .top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[2], attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.25, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[2], attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.2, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[2], attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30))
        
        // playersName3
        addConstraint(NSLayoutConstraint(item: playersName[3], attribute: .top, relatedBy: .equal, toItem: playersName[0], attribute: .top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[3], attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.75, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[3], attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.2, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[3], attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30))
        
        // playersCalls
        for i in 0..<4 {
            addConstraint(NSLayoutConstraint(item: playersCall[i], attribute: .top, relatedBy: .equal, toItem: playersName[i], attribute: .bottom, multiplier: 1.0, constant: 0))
            addConstraint(NSLayoutConstraint(item: playersCall[i], attribute: .centerX, relatedBy: .equal, toItem: playersName[i], attribute: .centerX, multiplier: 1.0, constant: 0))
            addConstraint(NSLayoutConstraint(item: playersCall[i], attribute: .width, relatedBy: .equal, toItem: playersName[i], attribute: .width, multiplier: 1.0, constant: 0))
            addConstraint(NSLayoutConstraint(item: playersCall[i], attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 80))
        }
        
        // callButtonsView
        addConstraint(NSLayoutConstraint(item: callButtonsView, attribute: .top, relatedBy: .equal, toItem: playersCall[0], attribute: .bottom, multiplier: 1.0, constant: 5))
        addConstraint(NSLayoutConstraint(item: callButtonsView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 5))
        addConstraint(NSLayoutConstraint(item: callButtonsView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -5))
        addConstraint(NSLayoutConstraint(item: callButtonsView, attribute: .bottom, relatedBy: .equal, toItem: passButton, attribute: .top, multiplier: 1.0, constant: -5))
        
        // passButton
        addConstraint(NSLayoutConstraint(item: passButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.05, constant: 0))
        addConstraint(NSLayoutConstraint(item: passButton, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 5))
        addConstraint(NSLayoutConstraint(item: passButton, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -5))
        addConstraint(NSLayoutConstraint(item: passButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -5))
        
        for i in 0..<49 {
            let callButton = UIButton()
            callButton.tag = i
            callButton.translatesAutoresizingMaskIntoConstraints = false
            callButton.setImage(UIImage(named:String(format:"Call%d",i)), for: .normal)
            callButtonsView.addSubview(callButton)
            
            if i%7==0 {
                if i==0 {
                    addConstraint(NSLayoutConstraint(item: callButton, attribute: .top, relatedBy: .equal, toItem: callButtonsView, attribute: .top, multiplier: 1.0, constant: (i/7==0 ? 0 : 5)))
                }
                else {
                    addConstraint(NSLayoutConstraint(item: callButton, attribute: .top, relatedBy: .equal, toItem: callButtons[(i/7-1)*7], attribute: .bottom, multiplier: 1.0, constant: (i/7==0 ? 0 : 5)))
                }
                addConstraint(NSLayoutConstraint(item: callButton, attribute: .left, relatedBy: .equal, toItem: callButtonsView, attribute: .left, multiplier: 1.0, constant: 0))
            }
            else {
                addConstraint(NSLayoutConstraint(item: callButton, attribute: .top, relatedBy: .equal, toItem: callButtons[i/7*7], attribute: .top, multiplier: 1.0, constant: 0))
                addConstraint(NSLayoutConstraint(item: callButton, attribute: .left, relatedBy: .equal, toItem: callButtons[i-1], attribute: .right, multiplier: 1.0, constant: 5))
            }
            
            addConstraint(NSLayoutConstraint(item: callButton, attribute: .width, relatedBy: .equal, toItem: callButtonsView, attribute: .width, multiplier: 0.1428, constant: -5))
            addConstraint(NSLayoutConstraint(item: callButton, attribute: .height, relatedBy: .equal, toItem: callButtonsView, attribute: .height, multiplier: 0.1428, constant: -5))
            
            callButtons.append(callButton)
            callButton.addTarget(self, action: #selector(self.touchUpInside(_:)), for: .touchUpInside)
        }
        
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
            
            if !setHidden {
                for i in 0..<4 {
                    playersName[i].text = stateManager.players[i]
                    playersCall[i].text = ""
                }
                for callButton in callButtons {
                    callButton.isEnabled = true
                }
                
                pokerManager.delegate = self
                
                if stateManager.playInfo.turnIndex == pokerManager.turnIndex {
                    UIAlertController.showAlert(title: "", message: "You call first")
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
        
        if pokerManager.turnIndex == stateManager.playInfo.turnIndex {
            if sender.tag == -1 {
                pokerManager.callTrump(sender.tag)
            }
            else {
                let message = String(format:"You will call %d%@\n",sender.tag/7+1,PokerManager.flowers[sender.tag%7])
                
                let cancelAction:UIAlertAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (UIAlertAction) in
                    self.transform = CGAffineTransform.identity
                }
                let okAction:UIAlertAction = UIAlertAction.init(title: "Confirm", style: .default) { (UIAlertAction) in
                    self.pokerManager.callTrump(sender.tag)
                }
                
                UIAlertController.showAlert(title: "",message: message,actions: [cancelAction,okAction])
            }
        }
    }
    
    // MARK: - StateManagerCallDelegate
    func updateCallingUI(_ index:Int) {
        for i in 0..<index+1 {
            callButtons[i].isEnabled = false
        }
        
        for i in 0..<4 {
            playersCall[i].text = pokerManager.callsRecord[i]
        }
    }
}
