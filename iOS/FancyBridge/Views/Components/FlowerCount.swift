//
//  FlowerCount.swift
//  FancyBridge
//
//  Created by Talka_Ying on 2019/12/20.
//  Copyright © 2019 Talka_Ying. All rights reserved.
//

import UIKit

class FlowerCount: UIView {
    
    var flowerImageView:UIImageView = UIImageView()
    var textLabel:UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        flowerImageView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        textLabel.textColor = UIColor(white: 51.0/255, alpha: 1.0)
        textLabel.font = UIFont.systemFont(ofSize: 17)
        textLabel.textColor = UIColor(white: 51.0/255, alpha: 1.0)
        textLabel.textAlignment = .left
        
        self.addSubview(flowerImageView)
        self.addSubview(textLabel)
        
        addConstraint(NSLayoutConstraint(item: flowerImageView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: -8))
        addConstraint(NSLayoutConstraint(item: flowerImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: flowerImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: flowerImageView, attribute: .width, relatedBy: .equal, toItem: flowerImageView, attribute: .height, multiplier: 1.0, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: textLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: -4))
        addConstraint(NSLayoutConstraint(item: textLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: textLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 24))
        addConstraint(NSLayoutConstraint(item: textLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 35))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setValue(_ imageName:String,_ number:Int) {
        
        flowerImageView.image = UIImage(named: imageName)
        textLabel.text = String(format:"X %d",number)
    }
}
