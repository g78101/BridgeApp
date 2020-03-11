//
//  InfoView.swift
//  FastRailway
//
//  Created by Talka_Ying on 2017/10/7.
//  Copyright © 2017年 Talka_Ying. All rights reserved.
//

import UIKit

class InfoView: UIView {
    
    static var infoView:InfoView?
    // MARK: - UI Member
    var backgroundButton:UIButton = UIButton()
    var main:UIView = UIView()
    
    var playersName:NamesLabel = NamesLabel()
    var playersCall:InfoCallView = InfoCallView()
    var playersPlay:InfoPlayView = InfoPlayView()
    var flowerCount:[FlowerCount] = Array<FlowerCount>()
    
    static func show() {
        if infoView==nil {
            infoView = InfoView()
        }
        infoView?.updateInfo()
        infoView?.addToTopView()
    }
    
    static func clear() {
        if infoView != nil {
            infoView = nil
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame:UIScreen.main.bounds)
        
        self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        
        backgroundButton.addTarget(self, action: #selector(InfoView.closeClicked(_:)), for: .touchUpInside)
        backgroundButton.translatesAutoresizingMaskIntoConstraints = false
        
        main.layer.cornerRadius = 6.0
        main.layer.masksToBounds = true
        main.backgroundColor = UIColor.white
        main.translatesAutoresizingMaskIntoConstraints = false
        
        playersCall.isDefaultSytle = false
        
        main.addSubview(playersName)
        main.addSubview(playersCall)
        main.addSubview(playersPlay)
        
        playersName.setFontSize(15)
        playersName.backgroundColor = UIColor(red: 193.0/255, green: 28.0/255, blue: 68.0/255, alpha: 1.0)
        
        for _ in 0..<4 {
            
            let flower = FlowerCount()
            flowerCount.append(flower)
            main.addSubview(flower)
        }
        
        self.addSubview(backgroundButton)
        self.addSubview(main)
        
        // main
        addConstraint(NSLayoutConstraint(item: main, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: main, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: main, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -16))
        addConstraint(NSLayoutConstraint(item: main, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 487))
        
        // backgroundButton
        addConstraint(NSLayoutConstraint(item: backgroundButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: backgroundButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: backgroundButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: backgroundButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0))
        
        // playersName
        addConstraint(NSLayoutConstraint(item: playersName, attribute: .top, relatedBy: .equal, toItem: main, attribute: .top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName, attribute: .left, relatedBy: .equal, toItem: main, attribute: .left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName, attribute: .right, relatedBy: .equal, toItem: main, attribute: .right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersName, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 36))
        
        // playersCalls
        addConstraint(NSLayoutConstraint(item: playersCall, attribute: .top, relatedBy: .equal, toItem: playersName, attribute: .bottom, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersCall, attribute: .centerX, relatedBy: .equal, toItem: playersName, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersCall, attribute: .width, relatedBy: .equal, toItem: playersName, attribute: .width, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersCall, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 110))
        
        if PokerManager.getInstance().threeMode {
            let otherPlayersName:NamesLabel = NamesLabel()
            
            otherPlayersName.setFontSize(15)
            otherPlayersName.backgroundColor = UIColor(red: 75.0/255, green: 189.0/255, blue: 97.0/255, alpha: 1.0)
            
            main.addSubview(otherPlayersName)
            otherPlayersName.setPlayersName(StateManager.getInstance().threeModePlayers)
            
            addConstraint(NSLayoutConstraint(item: otherPlayersName, attribute: .top, relatedBy: .equal, toItem: playersCall, attribute: .bottom, multiplier: 1.0, constant: 0))
            addConstraint(NSLayoutConstraint(item: otherPlayersName, attribute: .left, relatedBy: .equal, toItem: main, attribute: .left, multiplier: 1.0, constant: 0))
            addConstraint(NSLayoutConstraint(item: otherPlayersName, attribute: .right, relatedBy: .equal, toItem: main, attribute: .right, multiplier: 1.0, constant: 0))
            addConstraint(NSLayoutConstraint(item: otherPlayersName, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 36))
            
            addConstraint(NSLayoutConstraint(item: playersPlay, attribute: .top, relatedBy: .equal, toItem: otherPlayersName, attribute: .bottom, multiplier: 1.0, constant: 0))
        }
        else {
            // playersPlays
            addConstraint(NSLayoutConstraint(item: playersPlay, attribute: .top, relatedBy: .equal, toItem: playersCall, attribute: .bottom, multiplier: 1.0, constant: 0))
        }
        addConstraint(NSLayoutConstraint(item: playersPlay, attribute: .centerX, relatedBy: .equal, toItem: playersCall, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersPlay, attribute: .width, relatedBy: .equal, toItem: playersCall, attribute: .width, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: playersPlay, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: (PokerManager.getInstance().threeMode ? 250 : 286)))
        
        for i in 0..<4 {
            addConstraint(NSLayoutConstraint(item: flowerCount[i], attribute: .bottom, relatedBy: .equal, toItem: main, attribute: .bottom, multiplier: 1.0, constant: 0))
            if i == 0 {
                addConstraint(NSLayoutConstraint(item: flowerCount[i], attribute: .left, relatedBy: .equal, toItem: main, attribute: .left, multiplier: 1.0, constant: 0))
            }
            else {
                addConstraint(NSLayoutConstraint(item: flowerCount[i], attribute: .left, relatedBy: .equal, toItem: flowerCount[i-1], attribute: .right, multiplier: 1.0, constant: 0))
            }
            addConstraint(NSLayoutConstraint(item: flowerCount[i], attribute: .width, relatedBy: .equal, toItem: main, attribute: .width, multiplier: 0.25, constant: 0))
            addConstraint(NSLayoutConstraint(item: flowerCount[i], attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 53))
            
            playersName.setPlayersName(StateManager.getInstance().players)
        }
        
        let greenLine1 = UIView()
        let greenLine2 = UIView()
        greenLine1.translatesAutoresizingMaskIntoConstraints = false
        greenLine2.translatesAutoresizingMaskIntoConstraints = false
        greenLine1.backgroundColor = UIColor(red: 75.0/255, green: 189.0/255, blue: 97.0/255, alpha: 1.0)
        greenLine2.backgroundColor = UIColor(red: 75.0/255, green: 189.0/255, blue: 97.0/255, alpha: 1.0)
        main.addSubview(greenLine1)
        main.addSubview(greenLine2)
        
        // greenLine1
        addConstraint(NSLayoutConstraint(item: greenLine1, attribute: .top, relatedBy: .equal, toItem: playersCall, attribute: .bottom, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: greenLine1, attribute: .left, relatedBy: .equal, toItem: main, attribute: .left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: greenLine1, attribute: .right, relatedBy: .equal, toItem: main, attribute: .right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: greenLine1, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 2))
        
        // greenLine2
        addConstraint(NSLayoutConstraint(item: greenLine2, attribute: .top, relatedBy: .equal, toItem: playersPlay, attribute: .bottom, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: greenLine2, attribute: .left, relatedBy: .equal, toItem: main, attribute: .left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: greenLine2, attribute: .right, relatedBy: .equal, toItem: main, attribute: .right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: greenLine2, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 2))
        
        let whiteLine1 = UIView()
        let whiteLine2 = UIView()
        let whiteLine3 = UIView()
        whiteLine1.translatesAutoresizingMaskIntoConstraints = false
        whiteLine2.translatesAutoresizingMaskIntoConstraints = false
        whiteLine3.translatesAutoresizingMaskIntoConstraints = false
        whiteLine1.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        whiteLine2.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        whiteLine3.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        main.addSubview(whiteLine1)
        main.addSubview(whiteLine2)
        main.addSubview(whiteLine3)
        
        // whiteLine1
        addConstraint(NSLayoutConstraint(item: whiteLine1, attribute: .left, relatedBy: .equal, toItem: flowerCount[0], attribute: .right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: whiteLine1, attribute: .top, relatedBy: .equal, toItem: playersName, attribute: .bottom, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: whiteLine1, attribute: .bottom, relatedBy: .equal, toItem: playersPlay, attribute: .bottom, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: whiteLine1, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1))
        
        // whiteLine2
        addConstraint(NSLayoutConstraint(item: whiteLine2, attribute: .centerX, relatedBy: .equal, toItem: main, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: whiteLine2, attribute: .top, relatedBy: .equal, toItem: playersName, attribute: .bottom, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: whiteLine2, attribute: .bottom, relatedBy: .equal, toItem: playersPlay, attribute: .bottom, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: whiteLine2, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1))
        
        // whiteLine3
        addConstraint(NSLayoutConstraint(item: whiteLine3, attribute: .right, relatedBy: .equal, toItem: flowerCount[3], attribute: .left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: whiteLine3, attribute: .top, relatedBy: .equal, toItem: playersName, attribute: .bottom, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: whiteLine3, attribute: .bottom, relatedBy: .equal, toItem: playersPlay, attribute: .bottom, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: whiteLine3, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    func updateInfo() {
        for i in 0..<4 {
            flowerCount[i].setValue(PokerManager.Flowers[i], PokerManager.getInstance().flowerCountRecord[i])
        }
        playersCall.reloadData()
        playersPlay.reloadData()
    }
    
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
