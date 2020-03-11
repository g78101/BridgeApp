//
//  UIAlertController.swift
//  FancyBridge
//
//  Created by Talka_Ying on 2018/12/13.
//  Copyright © 2018 Talka_Ying. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    static func showAlert(title:String, message:String) {
    
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
        if let viewController = UIApplication.shared.windows.first?.rootViewController as UIViewController? {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    static func showAlert(title:String, message:String, actions:[UIAlertAction]) {
        
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        if let viewController = UIApplication.shared.windows.first?.rootViewController as UIViewController? {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
