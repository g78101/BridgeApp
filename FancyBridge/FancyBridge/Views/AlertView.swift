//
//  AlertView.swift
//  FancyBridge
//
//  Created by Talka_Ying on 2019/12/22.
//  Copyright © 2019 Talka_Ying. All rights reserved.
//

import UIKit

class AlertView: UIView {
    
    // MARK: - UI Member
    var backgroundButton:UIButton = UIButton()
    var okButton:UIButton = UIButton()
    var main:UIView = UIView()
    var textLabel:UILabel = UILabel()
    var numberLabel:UILabel = UILabel()
    var flowerImageView:UIImageView = UIImageView()
    var notDo = false
    var trump = -1
    
    static func getTopViewController() -> UIViewController? {
        if let window = UIApplication.shared.delegate?.window {
            if let viewController = window?.rootViewController {
                return viewController
            }
        }
        return nil
    }
    
    static func showView(_ trump:Int) {
        if let vc = getTopViewController() {
            let alerView = AlertView()
            alerView.setTrump(trump)
            vc.view.addSubview(alerView)
        }
    }
    
    static func showViewSetText(_ text:String) {
        if let vc = getTopViewController() {
            let alerView = AlertView()
            alerView.notDo = true
            alerView.setTextTrump(99,text)
            vc.view.addSubview(alerView)
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame:UIScreen.main.bounds)
        
        self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        flowerImageView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundButton.addTarget(self, action: #selector(closeClicked(_:)), for: .touchUpInside)
        backgroundButton.translatesAutoresizingMaskIntoConstraints = false
        
        okButton.addTarget(self, action: #selector(okClicked(_:)), for: .touchUpInside)
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.setTitle("OK", for: .normal)
        okButton.setTitleColor(UIColor.white, for: .normal)
        okButton.setBackgroundColor(UIColor(red: 1.0, green: 86.0/255, blue: 79.0/255, alpha: 1.0), for: .normal)
        
        main.layer.cornerRadius = 6.0
        main.layer.masksToBounds = true
        main.backgroundColor = UIColor.white
        main.translatesAutoresizingMaskIntoConstraints = false
        
        numberLabel.textAlignment = .center
        numberLabel.font = UIFont.systemFont(ofSize: 36, weight: .medium)
        numberLabel.tintColor = UIColor(white: 51.0/255, alpha: 1.0)
        
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 20.0)
        textLabel.tintColor = UIColor(white: 51.0/255, alpha: 1.0)
        textLabel.numberOfLines = 0
        
        self.addSubview(backgroundButton)
        self.addSubview(main)
        main.addSubview(textLabel)
        main.addSubview(numberLabel)
        main.addSubview(flowerImageView)
        main.addSubview(okButton)
        
        // backgroundButton
        addConstraint(NSLayoutConstraint(item: backgroundButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: backgroundButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: backgroundButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: backgroundButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0))
        
        // main
        addConstraint(NSLayoutConstraint(item: main, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: main, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: -37))
        addConstraint(NSLayoutConstraint(item: main, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 220))
        addConstraint(NSLayoutConstraint(item: main, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 163))
        
        // numberLabel
        addConstraint(NSLayoutConstraint(item: numberLabel, attribute: .top, relatedBy: .equal, toItem: main, attribute: .top, multiplier: 1.0, constant: 27))
        addConstraint(NSLayoutConstraint(item: numberLabel, attribute: .left, relatedBy: .equal, toItem: main, attribute: .centerX, multiplier: 1.0, constant: -29))
        addConstraint(NSLayoutConstraint(item: numberLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 22))
        addConstraint(NSLayoutConstraint(item: numberLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50))
        
        // flowerImageView
        addConstraint(NSLayoutConstraint(item: flowerImageView, attribute: .centerY, relatedBy: .equal, toItem: numberLabel, attribute: .centerY, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: flowerImageView, attribute: .right, relatedBy: .equal, toItem: main, attribute: .centerX, multiplier: 1.0, constant: 29))
        addConstraint(NSLayoutConstraint(item: flowerImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30))
        addConstraint(NSLayoutConstraint(item: flowerImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30))
        
        // textLabel
        addConstraint(NSLayoutConstraint(item: textLabel, attribute: .top, relatedBy: .equal, toItem: main, attribute: .top, multiplier: 1.0, constant: 10))
        addConstraint(NSLayoutConstraint(item: textLabel, attribute: .left, relatedBy: .equal, toItem: main, attribute: .left, multiplier: 1.0, constant: 10))
        addConstraint(NSLayoutConstraint(item: textLabel, attribute: .right, relatedBy: .equal, toItem: main, attribute: .right, multiplier: 1.0, constant: -10))
        addConstraint(NSLayoutConstraint(item: textLabel, attribute: .bottom, relatedBy: .equal, toItem: okButton, attribute: .top, multiplier: 1.0, constant: -10))
        
        // okButton
        addConstraint(NSLayoutConstraint(item: okButton, attribute: .bottom, relatedBy: .equal, toItem: main, attribute: .bottom, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: okButton, attribute: .left, relatedBy: .equal, toItem: main, attribute: .left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: okButton, attribute: .width, relatedBy: .equal, toItem: main, attribute: .width, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: okButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 60))
        
        numberLabel.isHidden = false
        flowerImageView.isHidden = false
        textLabel.isHidden = false
//        textLabel.backgroundColor = UIColor.red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    func setTrump(_ setTrump:Int) {
        
        trump = setTrump
        if trump%7 >= 2 && trump%7 < 6 {
            self.setImageTrump(trump)
        }
        else {
            var trumpText = ""
            
            if(trump == 99) {
                notDo = true
                trumpText = "Your turn"
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
            attrString.append(NSMutableAttributedString(string:trump, attributes:[NSAttributedString.Key.foregroundColor:UIColor(white: 51.0/255, alpha: 1.0),NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20, weight: .regular)]))
        }
        else {
            attrString.append(NSMutableAttributedString(string:String(format:"%d ",number/7+1), attributes:[NSAttributedString.Key.foregroundColor:UIColor(white: 51.0/255, alpha: 1.0),NSAttributedString.Key.font:UIFont.systemFont(ofSize: 36, weight: .medium)]))
            
            attrString.append(NSMutableAttributedString(string: trump, attributes:[NSAttributedString.Key.foregroundColor:UIColor(white: 51.0/255, alpha: 1.0),NSAttributedString.Key.font:UIFont.systemFont(ofSize: 30, weight: .medium)]))
        }
        textLabel.attributedText = attrString
        textLabel.isHidden = false
    }
    
    // MARK: - Action
    @objc func okClicked(_ sender:UIButton) {
        if !notDo {
            PokerManager.getInstance().callTrump(trump)
        }
        
        self.removeFromSuperview()
    }
    
    @objc func closeClicked(_ sender:UIButton) {
        if !notDo {
            self.removeFromSuperview()
        }
    }
}
