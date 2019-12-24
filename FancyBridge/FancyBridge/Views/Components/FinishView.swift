//
//  FinishView.swift
//  FancyBridge
//
//  Created by Talka_Ying on 2019/12/20.
//  Copyright © 2019 Talka_Ying. All rights reserved.
//

import UIKit

class FinishView: UIView {
    
    var textLabel:UILabel = UILabel()
    var imageView:UIImageView = UIImageView()
    var button:UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        textLabel.textColor = UIColor.white
        
        button.setBackgroundColor(UIColor(red: 1.0, green: 248.0/255, blue: 0, alpha: 1.0), for: .normal)
        button.setAttributedTitle(NSAttributedString(string:"Play Again", attributes:[NSAttributedString.Key.foregroundColor:UIColor(white: 51.0/255, alpha: 1.0),NSAttributedString.Key.font:UIFont.systemFont(ofSize: 22, weight: .regular)]), for: .normal)
        button.layer.cornerRadius = 26
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(touchUpInside(_:)), for: .touchUpInside)
        
        self.addSubview(textLabel)
        self.addSubview(imageView)
        self.addSubview(button)
        
        // textLabel
        addConstraint(NSLayoutConstraint(item: textLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: textLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: textLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 250))
        addConstraint(NSLayoutConstraint(item: textLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 39))
        
        // imageView
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: textLabel, attribute: .bottom, multiplier: 1.0, constant: 15))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 300))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 299))
        
        // button
        addConstraint(NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 140))
        addConstraint(NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 52))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setInfo(_ lose:Bool) {
        textLabel.text = ( lose ? "You Lose..." : "You Win!")
        imageView.image = UIImage(named: lose ? "ying-cry" : "ying-happy" )
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat(10 * Float.pi / 180.0))
        }, completion: nil)
    }
    
    @objc func touchUpInside(_ sender:UIButton) {
        self.isHidden = true
        imageView.layer.removeAllAnimations()
        imageView.layer.transform = CATransform3DIdentity
        PokerManager.getInstance().reset()
        StateManager.getInstance().reset()
        StateManager.getInstance().connectServer()
    }
}
