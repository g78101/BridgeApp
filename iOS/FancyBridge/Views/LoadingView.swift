//
//  LoadingView.swift
//  FastRailway
//
//  Created by Talka_Ying on 2017/10/5.
//  Copyright © 2017年 Talka_Ying. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    // MARK: - Member
    static var loadingView:UIView?
    static var loadingIndicator:UIActivityIndicatorView?
    static var loadingShowing:Bool = false
    // MARK: - Start
    static func StartLoading() {
        if loadingShowing {
            return
        }
        
        if loadingView==nil {
            
            let loadingBG = UIView()
            let textLabel = UILabel()
            
            loadingView = UIView(frame:UIScreen.main.bounds)
            loadingView?.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
            
            loadingBG.translatesAutoresizingMaskIntoConstraints = false
            loadingBG.layer.cornerRadius = 6
            loadingBG.backgroundColor = UIColor.white
            
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            textLabel.font = UIFont.systemFont(ofSize: 20)
            textLabel.textAlignment = .center
            textLabel.textColor = UIColor(white: 51.0/255, alpha: 1.0)
            textLabel.text = "Waiting"
            
            loadingIndicator = UIActivityIndicatorView()
            loadingIndicator?.translatesAutoresizingMaskIntoConstraints = false
            loadingIndicator?.style = .gray
            loadingIndicator?.isUserInteractionEnabled = false
            
            //loadingBG
            loadingView?.addConstraint(NSLayoutConstraint(item: loadingBG, attribute: .centerX, relatedBy: .equal, toItem: loadingView, attribute: .centerX, multiplier: 1.0, constant: 0))
            loadingView?.addConstraint(NSLayoutConstraint(item: loadingBG, attribute: .centerY, relatedBy: .equal, toItem: loadingView, attribute: .centerY, multiplier: 1.0, constant: 0))
            loadingBG.addConstraint(NSLayoutConstraint(item: loadingBG, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 220))
            loadingBG.addConstraint(NSLayoutConstraint(item: loadingBG, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 120))
            
            loadingView?.addSubview(loadingBG)
            loadingBG.addSubview(textLabel)
            loadingBG.addSubview(loadingIndicator!)
            
            //loadingView
            loadingBG.addConstraint(NSLayoutConstraint(item: loadingIndicator!, attribute: .left, relatedBy: .equal, toItem: loadingBG, attribute: .left, multiplier: 1.0, constant: 61))
            loadingBG.addConstraint(NSLayoutConstraint(item: loadingIndicator!, attribute: .centerY, relatedBy: .equal, toItem: loadingBG, attribute: .centerY, multiplier: 1.0, constant: 0))
            loadingIndicator?.addConstraint(NSLayoutConstraint(item: loadingIndicator!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20))
            loadingIndicator?.addConstraint(NSLayoutConstraint(item: loadingIndicator!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20))
            
            //textLabel
            loadingBG.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .right, relatedBy: .equal, toItem: loadingBG, attribute: .right, multiplier: 1.0, constant: -61))
            loadingBG.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .centerY, relatedBy: .equal, toItem: loadingBG, attribute: .centerY, multiplier: 1.0, constant: 0))
            textLabel.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 70))
            textLabel.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 28))
        }
        
        loadingIndicator?.startAnimating()
        
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            window.addSubview(loadingView!)
        }
        
        loadingShowing = true
    }
    // MARK: - Stop
    static func StopLoading() {
        if !loadingShowing {
            return
        }
        
        loadingView?.removeFromSuperview()
        loadingIndicator?.stopAnimating()
        
        loadingShowing = false
    }
}
