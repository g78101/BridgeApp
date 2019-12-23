//
//  InfoTableViewCell.swift
//  FancyBridge
//
//  Created by Talka_Ying on 2019/12/19.
//  Copyright © 2019 Talka_Ying. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {
    
    var recordViews:[RecordView] = Array<RecordView>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        for i in 0..<4 {
            let recordView:RecordView = RecordView()
            recordView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(recordView)
            recordView.numberLabel.textColor = UIColor(white: 51.0/255, alpha: 1.0)
            recordView.otherCallLabel.textColor = UIColor(white: 51.0/255, alpha: 1.0)
            
            addConstraint(NSLayoutConstraint(item: recordView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
            if i == 0 {
                addConstraint(NSLayoutConstraint(item: recordView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0))
            }
            else {
                addConstraint(NSLayoutConstraint(item: recordView, attribute: .left, relatedBy: .equal, toItem: recordViews[i-1], attribute: .right, multiplier: 1.0, constant: 0))
            }
            addConstraint(NSLayoutConstraint(item: recordView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.25, constant: 0))
            addConstraint(NSLayoutConstraint(item: recordView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
            
            recordViews.append(recordView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset() {
        for i in 0..<4 {
            recordViews[i].reset()
        }
    }
    
    func clearRecordsBG() {
        for i in 0..<4 {
            recordViews[i].backgroundColor = UIColor.clear
        }
    }
    
    func setWinRecord(_ index:Int) {
        recordViews[index].backgroundColor = UIColor(white: 0, alpha: 0.2)
    }
    
    func setCallRecords(_ callValues:[Int]) {
        
        for i in 0..<4 {
            let trump = callValues[i]
            if (trump == -2) {
                continue
            }
            recordViews[i].setTrump(trump)
        }
    }
    
    func setPlayRecords(_ playValues:[Int]) {
        for i in 0..<4 {
            let card = playValues[i]
            if (card == -1) {
                continue
            }
            recordViews[i].setRecord(card)
        }
    }
}
