//
//  ViewController.swift
//  Socket
//
//  Created by Talka_Ying on 2018/1/18.
//  Copyright © 2018年 Talka_Ying. All rights reserved.
//

import UIKit

class ViewController: UIViewController, StateManagerDelegate, UITextFieldDelegate {
    
    static let comfirmText = "Join (%d/4)"
    static let threeModeText = "Three player mode(%d/3)"
    // MARK: - UI Member
    @IBOutlet weak var waitView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var threeModeButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var versionLabel: UILabel!
    let bottomView:UIView = UIView()
    
    var callView:CallView = CallView()
    var playView:PlayView = PlayView()
    
    // MARK: - Member
    var stateManager:StateManager!
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        // Do any additional setup after loading the view, typically from a nib.
        view.addSubview(callView)
        view.addSubview(playView)
        
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.textField.attributedPlaceholder = NSAttributedString(string:
            "Your nickname", attributes:[NSAttributedString.Key.foregroundColor:UIColor(white: 1.0, alpha: 0.5)])
        self.textField.layer.cornerRadius=5.3
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.textField.frame.height))
        self.textField.leftView = paddingView
        self.textField.leftViewMode = UITextField.ViewMode.always
        
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
        
        stateManager = StateManager.getInstance()
        stateManager.delegate = self
        textField.delegate = self
        
        confirmButton.setTitleColor(UIColor(red: 26.0/255, green: 110.0/255.0, blue: 76.0/255, alpha: 1.0), for: .disabled)
        confirmButton.setBackgroundColor(UIColor(red: 1.0, green: 248.0/255.0, blue: 0.0, alpha: 1.0), for: .highlighted)
        confirmButton.isEnabled = false
        confirmButton.addTarget(self, action: #selector(confirmClicked(_:)), for: .touchUpInside)
        
        threeModeButton.setTitle(" ", for: .normal)
        threeModeButton.addTarget(self, action: #selector(threeModeClicked(_:)), for: .touchUpInside)
        threeModeButton.isHidden = true
        
        let versionStr:String = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
        versionLabel.text = versionStr
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.backgroundColor = UIColor.white
        
        view.addSubview(bottomView)
        view.addConstraint(NSLayoutConstraint(item: bottomView, attribute: .top, relatedBy: .equal, toItem: waitView, attribute: .bottom, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bottomView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bottomView, attribute: .left, relatedBy: .equal, toItem: waitView, attribute: .left, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bottomView, attribute: .right,relatedBy: .equal, toItem: waitView, attribute: .right, multiplier: 1.0, constant: 0))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action
    @objc func confirmClicked(_ sender: UIButton) {
        
        let textSize = NSString(string: textField.text!).size(withAttributes: [NSAttributedString.Key.font:textField.font!])
        
        if !NetworkManager.isConnectedToNetwork() {
            AlertView.showViewSetText("No Internet")
        }
        else if textSize.width > 100 {
            AlertView.showViewSetText("Please enter less length name")
        }
        else if textField.text! != "" {
            stateManager.playInfo.name = textField.text!
            stateManager.connectServer()
            
            confirmButton.isEnabled = false
            textField.becomeFirstResponder()
            textField.isEnabled = false
        }
        else {
            AlertView.showViewSetText("Please enter name")
        }
    }
    
    // MARK: - Action
    @objc func threeModeClicked(_ sender: UIButton) {
        threeModeButton.isEnabled = false
        stateManager.joinThreeMode()
    }
    
    // MARK: - StateManagerDelegate
    func changeStateUI(_ state: GameState) {
        
        switch state {
        case .Connected: break
        case .Wait:
            threeModeButton.isEnabled = true
            waitView.isHidden = false
            bottomView.isHidden = false
            callView.isHidden = true
            playView.isHidden = true
            break
        case .Call:
            waitView.isHidden = true
            bottomView.isHidden = true
            callView.isHidden = false
            playView.isHidden = true
            break
        case .CallChoosePartner:
            waitView.isHidden = true
            bottomView.isHidden = true
            callView.isHidden = false
            playView.isHidden = true
            break
        case .Play:
            waitView.isHidden = true
            bottomView.isHidden = true
            callView.isHidden = true
            playView.isHidden = false
            break
        }
    }
    
    func updateWaitingUI(_ normalCount:Int, _ threeModeCount:Int) {
        confirmButton.setTitle(String(format:ViewController.comfirmText,normalCount), for: .normal)
        let yourAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: UIColor.white,
            .underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributeString = NSMutableAttributedString(string:String(format:ViewController.threeModeText,threeModeCount),
                                                                      attributes: yourAttributes)
        threeModeButton.setAttributedTitle(attributeString, for: .normal)
        threeModeButton.isHidden = false
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
