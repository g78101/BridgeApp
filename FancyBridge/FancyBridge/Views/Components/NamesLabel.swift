//
//  NamesLabel.swift
//  FancyBridge
//
//  Created by Talka_Ying on 2019/12/19.
//  Copyright © 2019 Talka_Ying. All rights reserved.
//

import UIKit

class NamesLabel: UIView {
    
    var playersName:[UILabel] = Array<UILabel>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        for _ in 0..<4 {
            
            let name = UILabel()
            
            name.translatesAutoresizingMaskIntoConstraints = false
            
            name.textAlignment = .center
            name.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            name.textColor = UIColor.white
            
            playersName.append(name)
            
            self.addSubview(name)
        }
        
        // playersName0
        addConstraint(NSLayoutConstraint(item: playersName[0], attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[0], attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[0], attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.25, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[0], attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0))
        
        // playersName1
        addConstraint(NSLayoutConstraint(item: playersName[1], attribute: .top, relatedBy: .equal, toItem: playersName[0], attribute: .top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[1], attribute: .left, relatedBy: .equal, toItem: playersName[0], attribute: .right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[1], attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.25, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[1], attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0))
        
        // playersName2
        addConstraint(NSLayoutConstraint(item: playersName[2], attribute: .top, relatedBy: .equal, toItem: playersName[0], attribute: .top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[2], attribute: .left, relatedBy: .equal, toItem: playersName[1], attribute: .right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[2], attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.25, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[2], attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0))
        
        // playersName3
        addConstraint(NSLayoutConstraint(item: playersName[3], attribute: .top, relatedBy: .equal, toItem: playersName[0], attribute: .top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[3], attribute: .left, relatedBy: .equal, toItem: playersName[2], attribute: .right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[3], attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.25, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[3], attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFontSize(_ size:CGFloat) {
        for i in 0..<4 {
            playersName[i].font = UIFont.systemFont(ofSize: size, weight: .medium)
        }
    }
    
    func setPlayersName(_ players:[String]) {
        for i in 0..<4 {
            playersName[i].text = players[i]
        }
    }
}
