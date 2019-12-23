//
//  InfoCallView.swift
//  FancyBridge
//
//  Created by Talka_Ying on 2019/12/19.
//  Copyright © 2019 Talka_Ying. All rights reserved.
//

import UIKit

class InfoCallView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    static var Colors = [UIColor(red: 255/255, green: 232.0/255, blue: 240.0/255, alpha: 1.0),UIColor.white]
    
    var isDefaultSytle = true
    
    // MARK: - Init
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.register(InfoTableViewCell.self, forCellReuseIdentifier: "InfoTableViewCell")
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var length = (isDefaultSytle ? 4 : 5)
        
        for i in 0..<4 {
            let count = PokerManager.getInstance().callsRecord[i].count
            if count > length {
                length = count
            }
        }
        
        return length
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.dequeueReusableCell(withIdentifier: "InfoTableViewCell", for: indexPath) as! InfoTableViewCell
        
        if !isDefaultSytle {
            self.separatorStyle = .none
            cell.isUserInteractionEnabled = false
            cell.backgroundColor = InfoCallView.Colors[indexPath.row%2]
        }
        else {
            self.separatorInset = UIEdgeInsets.zero
        }
        
        cell.reset()
        
        if indexPath.row < PokerManager.getInstance().findMaxCallCount() {
            
            var callValues:[Int] = Array<Int>()
            for i in 0..<4 {
                var value = -2
                if indexPath.row < PokerManager.getInstance().callsRecord[i].count {
                    value = PokerManager.getInstance().callsRecord[i][indexPath.row]
                }
                if i==3 && PokerManager.getInstance().threeMode {
                    value = 99
                }
                callValues.append(value)
            }
            cell.setCallRecords(callValues)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  isDefaultSytle ? 29 : 22
    }
}
