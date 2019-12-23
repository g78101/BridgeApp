//
//  RecordView.swift
//  FancyBridge
//
//  Created by Talka_Ying on 2019/12/19.
//  Copyright © 2019 Talka_Ying. All rights reserved.
//

import UIKit

class RecordView: UIView {
    
    var numberLabel:UILabel = UILabel()
    var otherCallLabel:UILabel = UILabel()
    var flowerImageView:UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        otherCallLabel.translatesAutoresizingMaskIntoConstraints = false
        flowerImageView.translatesAutoresizingMaskIntoConstraints = false
        
        numberLabel.textColor = UIColor(white: 51.0/255, alpha: 1.0)
        otherCallLabel.textColor = UIColor(white: 51.0/255, alpha: 1.0)
        
        self.addSubview(numberLabel)
        self.addSubview(otherCallLabel)
        self.addSubview(flowerImageView)
        
        numberLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        numberLabel.textColor = UIColor.white
        numberLabel.textAlignment = .center
        
        otherCallLabel.textColor = UIColor.white
        otherCallLabel.textAlignment = .center
        
        addConstraint(NSLayoutConstraint(item: numberLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: -2))
        addConstraint(NSLayoutConstraint(item: numberLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: numberLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.9, constant: 0))
        addConstraint(NSLayoutConstraint(item: numberLabel, attribute: .width, relatedBy: .equal, toItem: numberLabel, attribute: .height, multiplier: 1.2, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: flowerImageView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 2))
        addConstraint(NSLayoutConstraint(item: flowerImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: flowerImageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.9, constant: 0))
        addConstraint(NSLayoutConstraint(item: flowerImageView, attribute: .width, relatedBy: .equal, toItem: flowerImageView, attribute: .height, multiplier: 1.0, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: otherCallLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: otherCallLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: otherCallLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: otherCallLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset() {
        numberLabel.isHidden = true
        otherCallLabel.isHidden = true
        flowerImageView.isHidden = true
    }
    
    func setTrump(_ trump:Int) {
        
        if trump%7 >= 2 && trump%7 < 6 {
            self.setImageTrump(trump)
        }
        else {
            var trumpText = ""
            
            if(trump == 99) {
                trumpText = "-"
            }
            else if(trump == -1) {
                trumpText = "Pass"
            }
            else if(trump%7==0) {
                trumpText = "SM"
            }
            else if(trump%7==1) {
                trumpText = "MD"
            }
            else if(trump%7==6) {
                trumpText = "NT"
            }
            
            self.setTextTrump(trump,trumpText)
        }
    }
    
    func setImageTrump(_ trump:Int) {
        
        var flowerIndex = trump%7-2
        
        if flowerIndex == 0 {
            flowerIndex=1
        }
        else if flowerIndex == 1 {
            flowerIndex=0
        }
        
        numberLabel.isHidden = false
        flowerImageView.isHidden = false
        
        numberLabel.text = String(format:"%d",trump/7+1)
        flowerImageView.image =  UIImage(named:PokerManager.Flowers[flowerIndex])
    }
    
    func setTextTrump(_ number:Int, _ trump:String) {
        
        let attrString = NSMutableAttributedString()
        
        if number == -1 || number == 99 {
            attrString.append(NSMutableAttributedString(string:trump, attributes:[NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17, weight: .medium)]))
        }
        else {
            
            attrString.append(NSMutableAttributedString(string:String(format:"%d ",number/7+1), attributes:[NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17, weight: .medium)]))
            
            attrString.append(NSMutableAttributedString(string: trump, attributes:[NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15, weight: .medium)]))
        }
        otherCallLabel.attributedText = attrString
        otherCallLabel.isHidden = false
    }
    
    func setRecord(_ card:Int) {
        
        let numberIndex = (card-1)%13
        let flowerIndex = (card-1)/13
        
        numberLabel.text = PokerManager.Numbers[numberIndex]
        flowerImageView.image = UIImage(named:PokerManager.Flowers[flowerIndex])
        numberLabel.isHidden = false
        flowerImageView.isHidden = false
    }
}
