//
//  InfoPlayView.swift
//  FancyBridge
//
//  Created by Talka_Ying on 2019/12/19.
//  Copyright © 2019 Talka_Ying. All rights reserved.
//

import UIKit

class InfoPlayView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    static var Colors = [UIColor(red: 0/255, green: 200.0/255, blue: 136.0/255, alpha: 0.2),UIColor.white]
    
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
        return 13
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.separatorStyle = .none
        let cell = self.dequeueReusableCell(withIdentifier: "InfoTableViewCell", for: indexPath) as! InfoTableViewCell
        cell.isUserInteractionEnabled = false
        cell.backgroundColor = InfoPlayView.Colors[indexPath.row%2]
        cell.clearRecordsBG()
        cell.reset()
        
        if indexPath.row < PokerManager.getInstance().findMaxPlayCount() {
            var playValues:[Int] = Array<Int>()
            for i in 0..<4 {
                var value = -1
                if indexPath.row < PokerManager.getInstance().playsRecord[i].count {
                    value = PokerManager.getInstance().playsRecord[i][indexPath.row]
                }
                playValues.append(value)
            }
            cell.setPlayRecords(playValues)
            
            if indexPath.row < PokerManager.getInstance().boutsWinRecord.count {
                cell.setWinRecord(PokerManager.getInstance().boutsWinRecord[indexPath.row])
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 22
    }
}
