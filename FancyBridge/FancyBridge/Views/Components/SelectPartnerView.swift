//
//  SelectPartnerView.swift
//  FancyBridge
//
//  Created by Talka_Ying on 2019/12/17.
//  Copyright © 2019 Talka_Ying. All rights reserved.
//

import UIKit

class SelectPartnerView: UIView {
    
    var titleLabel = UILabel()
    var chooseButtons:[UIButton] = Array<UIButton>()
    var okButton = UIButton()
    var selectIndex = -1
    var indexTable:[Int] = Array<Int>()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 6.0
        self.layer.masksToBounds = true
        
        self.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        okButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(titleLabel)
        self.addSubview(okButton)
        
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.text = "Choosing Your Partner"
        
        okButton.setTitleColor(UIColor(white: 51.0/255, alpha: 1.0), for: .normal)
        okButton.setTitle("OK", for: .normal)
        okButton.setBackgroundColor(UIColor(red: 1.0, green: 248.0/255, blue: 0, alpha: 1.0), for: .normal)
        okButton.layer.masksToBounds = true
        okButton.addTarget(self, action: #selector(okClicked(_:)), for: .touchUpInside)
        
        let height:CGFloat = ( UIScreen.main.bounds.size.height > 568 ) ? 8 : 0
        
        for i in 0..<3 {
            
            let chooseButton = UIButton()
            
            chooseButton.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(chooseButton)
            
            chooseButton.setTitleColor(UIColor.white, for: .normal)

            chooseButton.layer.masksToBounds = true
            chooseButton.layer.borderWidth = 1.0
            chooseButton.layer.borderColor = UIColor.white.cgColor
            chooseButton.tag = i
            chooseButton.addTarget(self, action: #selector(selectedPlayer(_:)), for: .touchUpInside)
            
            addConstraint(NSLayoutConstraint(item: chooseButton, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0))
            addConstraint(NSLayoutConstraint(item: chooseButton, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0))
            addConstraint(NSLayoutConstraint(item: chooseButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.169, constant: 0))
            
            chooseButtons.append(chooseButton)
        }
        
        addConstraint(NSLayoutConstraint(item: chooseButtons[0], attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 0.6, constant: 0))
        
         addConstraint(NSLayoutConstraint(item: chooseButtons[1], attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
         
        addConstraint(NSLayoutConstraint(item: chooseButtons[2], attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.4, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: height))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 28))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.75, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: okButton, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: okButton, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: okButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: okButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.169, constant: 0))
    }
    
    required init?(coder: NSCoder) {
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
                
                var buttonIndex = 0
                indexTable.removeAll()
                
                for button in chooseButtons {
                    button.layer.cornerRadius = button.frame.size.height/2
                }
                okButton.layer.cornerRadius = okButton.frame.size.height/2
                
                for i in 0..<4 {
                    
                    if ( i == StateManager.getInstance().playInfo.turnIndex ) {
                        continue
                    }
                    
                    indexTable.append(i)
                    chooseButtons[buttonIndex].setTitle(StateManager.getInstance().players[i], for: .normal)
                    buttonIndex+=1
                }
            }
        }
    }
    
    // MARK: - Action
    @objc func selectedPlayer(_ sender:UIButton) {
        for button in chooseButtons {
            button.setBackgroundColor(UIColor
            .clear, for: .normal)
        }
        
        sender.setBackgroundColor(UIColor(white: 1, alpha: 0.25), for: .normal)
        sender.isSelected = true
        selectIndex = sender.tag
    }
    
    @objc func okClicked(_ sender:UIButton) {
        
        if selectIndex == -1 {
            AlertView.showViewSetText("Please choose one")
        }
        else {
            StateManager.getInstance().choosedPartner(self.indexTable[self.selectIndex])
        }
    }
}
