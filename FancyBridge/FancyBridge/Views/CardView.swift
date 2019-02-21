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

class CardView: UIView {
    // MARK: - Const
    static var Flowers = ["♦(D)","♣(C)","♥(H)","♠(S)"]
    // MARK: - UI Member
    var button:UIButton = UIButton()
    // MARK: - Member
    var pokerManager:PokerManager!
    weak var delegate:CardViewDelegate!
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        pokerManager = PokerManager.getInstance()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(button)
        
        addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.68, constant: 0))
        
        button.addTarget(self, action: #selector(self.touchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(self.touchUpOutside(_:)), for: .touchUpOutside)
        button.addTarget(self, action: #selector(self.touchUpInside(_:)), for: .touchUpInside)
        
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
        button.setImage(UIImage(named:String(format:"Card%d",card)), for: .normal)
        button.setImage(UIImage(named:String(format:"Card%d",card)), for: .disabled)
    }
    
    func setEnable(_ flag:Bool) {
        button.isEnabled = flag
    }
    
    // MARK: - Action
    @objc func touchDown(_ sender:UIButton) {
        
        let currentPoker = Int(pokerManager.cards[self.tag])!
        var haveFlower:Bool = false
        
        if(pokerManager.currentFlower != -1) {
            for i in 0..<13 {
                let poker = Int(pokerManager.cards[i])!
                
                if(poker != 0 && (poker-1)/13==pokerManager.currentFlower)
                {
                    haveFlower = true
                    break
                }
            }
        }
        
        if haveFlower && (currentPoker-1)/13 != pokerManager.currentFlower {
            UIAlertController.showAlert(title: "", message: "Foul!!!")
        }
        else {
            self.transform = CGAffineTransform(translationX: 0, y: -self.frame.size.height/2)
        }
    }
    
    @objc func touchUpOutside(_ sender:UIButton) {
        self.transform = CGAffineTransform.identity
    }
    
    @objc func touchUpInside(_ sender:UIButton) {

        let poker = Int(pokerManager.cards[self.tag])!
        let message = String(format:"You will play %d %@\n",(poker-1)%13+1,CardView.Flowers[(poker-1)/13])
        
        let cancelAction:UIAlertAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (UIAlertAction) in
            self.transform = CGAffineTransform.identity
        }
        let okAction:UIAlertAction = UIAlertAction.init(title: "Confirm", style: .default) { (UIAlertAction) in
            if (self.delegate != nil) {
                self.delegate.confirmPoker(self.tag)
            }
        }
        
        UIAlertController.showAlert(title: "",message: message,actions: [cancelAction,okAction])
    }
}
