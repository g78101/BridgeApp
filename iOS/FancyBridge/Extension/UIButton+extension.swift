//
//  UIButton+extension.swift
//  FastRailway
//
//  Created by Talka_Ying on 2017/12/12.
//  Copyright © 2017年 Talka_Ying. All rights reserved.
//

import UIKit

public extension UIButton {
    
    public func setBackgroundColor(_ color:UIColor, for state: UIControl.State) {
        
        let rect:CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(image, for: .normal)
    }
}
