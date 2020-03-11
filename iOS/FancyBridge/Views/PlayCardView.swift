//
//  PlayCardView.swift
//  FancyBridge
//
//  Created by Talka_Ying on 2019/12/19.
//  Copyright © 2019 Talka_Ying. All rights reserved.
//

import UIKit

protocol PlayCardViewDelegate:class {
    func confirmPoker(_ index:Int)
}

class PlayCardView: UIView {
    
    // MARK: - UI Member
    var backgroundButton:UIButton = UIButton()
    var playButton:UIButton = UIButton()
    var main:UIView = UIView()
    var numberLabel:UILabel = UILabel()
    var flowerImageView:UIImageView = UIImageView()
    
    weak var delegate:PlayCardViewDelegate!
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame:UIScreen.main.bounds)
        
        self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        flowerImageView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundButton.addTarget(self, action: #selector(closeClicked(_:)), for: .touchUpInside)
        backgroundButton.translatesAutoresizingMaskIntoConstraints = false
        
        playButton.addTarget(self, action: #selector(playCard(_:)), for: .touchUpInside)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.layer.cornerRadius = 21
        playButton.layer.masksToBounds = true
        playButton.setTitle("Play", for: .normal)
        playButton.setTitleColor(UIColor(white: 51.0/255, alpha: 1.0), for: .normal)
        playButton.setBackgroundColor(UIColor(red: 1.0, green: 248.0/255, blue: 0.0, alpha: 1.0), for: .normal)
        
        main.layer.cornerRadius = 6.0
        main.layer.masksToBounds = true
        main.backgroundColor = UIColor.white
        main.translatesAutoresizingMaskIntoConstraints = false
        
        numberLabel.textAlignment = .center
        numberLabel.font = UIFont.systemFont(ofSize: 70, weight: .medium)
        
        self.addSubview(backgroundButton)
        self.addSubview(playButton)
        self.addSubview(main)
        main.addSubview(numberLabel)
        main.addSubview(flowerImageView)
        
        // backgroundButton
        addConstraint(NSLayoutConstraint(item: backgroundButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: backgroundButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: backgroundButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: backgroundButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0))
        
        // main
        addConstraint(NSLayoutConstraint(item: main, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: main, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: -37))
        addConstraint(NSLayoutConstraint(item: main, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100))
        addConstraint(NSLayoutConstraint(item: main, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 152))
        
        // numberLabel
        addConstraint(NSLayoutConstraint(item: numberLabel, attribute: .top, relatedBy: .equal, toItem: main, attribute: .top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: numberLabel, attribute: .left, relatedBy: .equal, toItem: main, attribute: .left, multiplier: 1.0, constant: 10))
        addConstraint(NSLayoutConstraint(item: numberLabel, attribute: .right, relatedBy: .equal, toItem: main, attribute: .right, multiplier: 1.0, constant: -10))
        addConstraint(NSLayoutConstraint(item: numberLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 83))
        
        // flowerImageView
        addConstraint(NSLayoutConstraint(item: flowerImageView, attribute: .centerX, relatedBy: .equal, toItem: main, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: flowerImageView, attribute: .bottom, relatedBy: .equal, toItem: main, attribute: .bottom, multiplier: 1.0, constant: -8))
        addConstraint(NSLayoutConstraint(item: flowerImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 64))
        addConstraint(NSLayoutConstraint(item: flowerImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 64))
        
        // playButton
        addConstraint(NSLayoutConstraint(item: playButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: playButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 78))
        addConstraint(NSLayoutConstraint(item: playButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 132))
        addConstraint(NSLayoutConstraint(item: playButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 42))

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    func setCard(_ card:Int) {
        let numberIndex = (card-1)%13
        let flowerIndex = (card-1)/13
        tag = card
        
        if(card==0) {
            numberLabel.text = ""
            flowerImageView.image = nil
        }
        else {
            numberLabel.text = PokerManager.Numbers[numberIndex]
            numberLabel.textColor = PokerManager.Colors[flowerIndex%2]
            flowerImageView.image = UIImage(named:PokerManager.Flowers[flowerIndex])
        }
    }
    
    func getTopViewController() -> UIViewController? {
        if let window = UIApplication.shared.delegate?.window {
            if let viewController = window?.rootViewController {
                return viewController
            }
        }
        return nil
    }
    
    func addToTopView(_ card:Int) {
        if let vc = getTopViewController() {
            self.setCard(card)
            vc.view.addSubview(self)
        }
    }
    
    // MARK: - Action
    @objc func playCard(_ sender:UIButton) {
        delegate.confirmPoker(tag)
        self.removeFromSuperview()
    }
    
    @objc func closeClicked(_ sender:UIButton) {
        self.removeFromSuperview()
    }
}
