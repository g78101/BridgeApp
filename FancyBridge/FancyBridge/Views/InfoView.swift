//
//  InfoView.swift
//  FastRailway
//
//  Created by Talka_Ying on 2017/10/7.
//  Copyright © 2017年 Talka_Ying. All rights reserved.
//

import UIKit

class InfoView: UIView {
    // MARK: - UI Member
    var closeButton:UIButton = UIButton()
    var backgroundButton:UIButton = UIButton()
    var main:UIView = UIView()
    
    var playersName:[UILabel] = Array<UILabel>()
    var playersCall:[UITextView] = Array<UITextView>()
    var playersPlay:[UITextView] = Array<UITextView>()
    var flowerCount:[UILabel] = Array<UILabel>()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame:UIScreen.main.bounds)
        
        self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        
        closeButton.addTarget(self, action: #selector(InfoView.closeClicked(_:)), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(named: "dialogCloseBtn"), for: .normal)
        
        backgroundButton.addTarget(self, action: #selector(InfoView.closeClicked(_:)), for: .touchUpInside)
        backgroundButton.translatesAutoresizingMaskIntoConstraints = false
        
        main.layer.borderWidth = 0.2
        main.layer.cornerRadius = 5.0
        main.layer.shadowColor=UIColor.gray.cgColor
        main.layer.shadowOffset = CGSize(width: 2, height: 2)
        main.layer.shadowOpacity=1
        main.backgroundColor = UIColor.white
        main.translatesAutoresizingMaskIntoConstraints = false
        
        for i in 0..<4 {
            
            let name = UILabel()
            let call = UITextView()
            let play = UITextView()
            let flower = UILabel()
            
            name.translatesAutoresizingMaskIntoConstraints = false
            call.translatesAutoresizingMaskIntoConstraints = false
            play.translatesAutoresizingMaskIntoConstraints = false
            flower.translatesAutoresizingMaskIntoConstraints = false
            name.textAlignment = .center
            flower.textAlignment = .center
            flower.font = UIFont.systemFont(ofSize: 12)
            
            call.isSelectable = false
            call.isEditable = false
            call.textAlignment = .center
            call.layer.borderWidth = 1.0
            
            play.isSelectable = false
            play.isEditable = false
            play.textAlignment = .center
            play.layer.borderWidth = 1.0
            
            playersName.append(name)
            playersCall.append(call)
            playersPlay.append(play)
            flowerCount.append(flower)
            
            main.addSubview(name)
            main.addSubview(call)
            main.addSubview(play)
            main.addSubview(flower)
        }
        
        self.addSubview(backgroundButton)
        self.addSubview(main)
        self.addSubview(closeButton)
        
        let metrics = ["verticalSpace": 50,
                       "horizontalSpace": 15]
        
        let views:[String : Any] = ["main" : main,"backgroundButton" : backgroundButton]
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundButton]|", options:.alignAllCenterY, metrics: metrics, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[backgroundButton]|", options: .alignAllCenterX, metrics: metrics, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-verticalSpace-[main]-verticalSpace-|", options:.alignAllCenterY, metrics: metrics, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-horizontalSpace-[main]-horizontalSpace-|", options: .alignAllCenterX, metrics: metrics, views: views)
        
        //closeButton
        self.addConstraint(NSLayoutConstraint(item: closeButton, attribute: .right, relatedBy: .equal, toItem: main, attribute: .right, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: closeButton, attribute: .top, relatedBy: .equal, toItem: main, attribute: .top, multiplier: 1.0, constant: 0))
        closeButton.addConstraint(NSLayoutConstraint(item: closeButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 46))
        closeButton.addConstraint(NSLayoutConstraint(item: closeButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 46))
        
        self.addConstraints(constraints)
        
        // playersName0
        addConstraint(NSLayoutConstraint(item: playersName[0], attribute: .top, relatedBy: .equal, toItem: main, attribute: .top, multiplier: 1.0, constant: 35))
        addConstraint(NSLayoutConstraint(item: playersName[0], attribute: .centerX, relatedBy: .equal, toItem: main, attribute: .centerX, multiplier: 0.4, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[0], attribute: .width, relatedBy: .equal, toItem: main, attribute: .width, multiplier: 0.25, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[0], attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30))
        
        // playersName1
        addConstraint(NSLayoutConstraint(item: playersName[1], attribute: .top, relatedBy: .equal, toItem: playersName[0], attribute: .top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[1], attribute: .centerX, relatedBy: .equal, toItem: main, attribute: .centerX, multiplier: 0.8, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[1], attribute: .width, relatedBy: .equal, toItem: main, attribute: .width, multiplier: 0.25, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[1], attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30))
        
        // playersName2
        addConstraint(NSLayoutConstraint(item: playersName[2], attribute: .top, relatedBy: .equal, toItem: playersName[0], attribute: .top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[2], attribute: .centerX, relatedBy: .equal, toItem: main, attribute: .centerX, multiplier: 1.2, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[2], attribute: .width, relatedBy: .equal, toItem: main, attribute: .width, multiplier: 0.25, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[2], attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30))
        
        // playersName3
        addConstraint(NSLayoutConstraint(item: playersName[3], attribute: .top, relatedBy: .equal, toItem: playersName[0], attribute: .top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[3], attribute: .centerX, relatedBy: .equal, toItem: main, attribute: .centerX, multiplier: 1.6, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[3], attribute: .width, relatedBy: .equal, toItem: main, attribute: .width, multiplier: 0.25, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName[3], attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30))
        
        // playersCalls
        // playersPlays
        for i in 0..<4 {
            addConstraint(NSLayoutConstraint(item: playersCall[i], attribute: .top, relatedBy: .equal, toItem: playersName[i], attribute: .bottom, multiplier: 1.0, constant: 0))
            addConstraint(NSLayoutConstraint(item: playersCall[i], attribute: .centerX, relatedBy: .equal, toItem: playersName[i], attribute: .centerX, multiplier: 1.0, constant: 0))
            addConstraint(NSLayoutConstraint(item: playersCall[i], attribute: .width, relatedBy: .equal, toItem: playersName[i], attribute: .width, multiplier: 1.0, constant: 0))
            addConstraint(NSLayoutConstraint(item: playersCall[i], attribute: .height, relatedBy: .equal, toItem: main, attribute: .height, multiplier: 0.3, constant: 0))
            
            addConstraint(NSLayoutConstraint(item: playersPlay[i], attribute: .top, relatedBy: .equal, toItem: playersCall[i], attribute: .bottom, multiplier: 1.0, constant: 10))
            addConstraint(NSLayoutConstraint(item: playersPlay[i], attribute: .centerX, relatedBy: .equal, toItem: playersCall[i], attribute: .centerX, multiplier: 1.0, constant: 0))
            addConstraint(NSLayoutConstraint(item: playersPlay[i], attribute: .width, relatedBy: .equal, toItem: playersCall[i], attribute: .width, multiplier: 1.0, constant: 0))
            addConstraint(NSLayoutConstraint(item: playersPlay[i], attribute: .bottom, relatedBy: .equal, toItem: flowerCount[i], attribute: .top, multiplier: 1.0, constant: 0))
            
            addConstraint(NSLayoutConstraint(item: flowerCount[i], attribute: .bottom, relatedBy: .equal, toItem: main, attribute: .bottom, multiplier: 1.0, constant: -10))
            addConstraint(NSLayoutConstraint(item: flowerCount[i], attribute: .centerX, relatedBy: .equal, toItem: playersCall[i], attribute: .centerX, multiplier: 1.0, constant: 0))
            addConstraint(NSLayoutConstraint(item: flowerCount[i], attribute: .width, relatedBy: .equal, toItem: playersCall[i], attribute: .width, multiplier: 1.0, constant: 0))
            addConstraint(NSLayoutConstraint(item: flowerCount[i], attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30))
            
            playersName[i].text = StateManager.getInstance().players[i]
            playersCall[i].text = PokerManager.getInstance().callsRecord[i]
            playersPlay[i].text = PokerManager.getInstance().playsRecord[i]
            flowerCount[i].text = String(format:"%@:%d",CardView.Flowers[i],PokerManager.getInstance().flowerCountRecord[i])
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    func getTopViewController() -> UIViewController? {
        if let window = UIApplication.shared.delegate?.window {
            if let viewController = window?.rootViewController {
                return viewController
            }
        }
        return nil
    }
    
    func addToTopView() {
        if let vc = getTopViewController() {
            vc.view.addSubview(self)
        }
    }
    
    // MARK: - Action
    @objc func closeClicked(_ sender:UIButton) {
        self.removeFromSuperview()
    }
}
