//
//  ViewController.swift
//  Socket
//
//  Created by Talka_Ying on 2018/1/18.
//  Copyright © 2018年 Talka_Ying. All rights reserved.
//

import UIKit

class ViewController: UIViewController, StateManagerDelegate, UITextFieldDelegate {
    
    // MARK: - UI Member
    @IBOutlet weak var waitView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var versionLabel: UILabel!

    var callView:CallView = CallView()
    var playView:PlayView = PlayView()
    
    // MARK: - Member
    var stateManager:StateManager!
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addSubview(callView)
        view.addSubview(playView)
        
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // versionLabel
        view.addConstraint(NSLayoutConstraint(item: versionLabel, attribute: .top, relatedBy: .equal, toItem: textLabel, attribute: .bottom, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: versionLabel, attribute: .right, relatedBy: .equal, toItem: textLabel, attribute: .right, multiplier: 1.0, constant: 0))
        versionLabel.addConstraint(NSLayoutConstraint(item: versionLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20))
        versionLabel.addConstraint(NSLayoutConstraint(item: versionLabel, attribute: .width,relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 77))
        
        // callView
        view.addConstraint(NSLayoutConstraint(item: callView, attribute: .height, relatedBy: .equal, toItem: waitView, attribute: .height, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: callView, attribute: .bottom, relatedBy: .equal, toItem: waitView, attribute: .bottom, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: callView, attribute: .left, relatedBy: .equal, toItem: waitView, attribute: .left, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: callView, attribute: .right,relatedBy: .equal, toItem: waitView, attribute: .right, multiplier: 1.0, constant: 0))
        
        // playView
        view.addConstraint(NSLayoutConstraint(item: playView, attribute: .height, relatedBy: .equal, toItem: waitView, attribute: .height, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: playView, attribute: .bottom, relatedBy: .equal, toItem: waitView, attribute: .bottom, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: playView, attribute: .left, relatedBy: .equal, toItem: waitView, attribute: .left, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: playView, attribute: .right,relatedBy: .equal, toItem: waitView, attribute: .right, multiplier: 1.0, constant: 0))
        
        textLabel.adjustsFontSizeToFitWidth = true
        
        stateManager = StateManager.getInstance()
        stateManager.delegate = self
        textField.delegate = self
        
        confirmButton.setTitleColor(UIColor.gray, for: .disabled)
        confirmButton.isEnabled = false
        
        confirmButton.addTarget(self, action: #selector(confirmClicked(_:)), for: .touchUpInside)
        
        let versionStr:String = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
        versionLabel.text = versionStr
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Action
    @objc func confirmClicked(_ sender: UIButton) {
        
        if textField.text! != "" {
            stateManager.playInfo.name = textField.text!
            stateManager.connectServer()
            
            confirmButton.isEnabled = false
            textField.becomeFirstResponder()
            textField.isEnabled = false
        }
        else {
            UIAlertController.showAlert(title: "Warning", message: "Please enter name")
        }
    }
    
    // MARK: - StateManagerDelegate
    func changeStateUI(_ state: GameState) {
        
        switch state {
        case .Wait:
            textLabel.text = ""
            waitView.isHidden = false
            callView.isHidden = true
            playView.isHidden = true
            break
        case .Call:
            waitView.isHidden = true
            callView.isHidden = false
            playView.isHidden = true
            break
        case .Play:
            waitView.isHidden = true
            callView.isHidden = true
            playView.isHidden = false
            break
        }
    }
    
    func updateWaitingUI(_ text: String) {
        textLabel.text = textLabel.text! + text + "\n"
    }
 
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        confirmButton.isEnabled = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        confirmClicked(confirmButton)
        return true
    }
    
}

