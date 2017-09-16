//
//  SettingsViewController.swift
//  CatJumpGame
//
//  Created by Isabel  Lee on 27/05/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//

import UIKit

enum AlertType {
    case success
    case failed
    case transfer
}

// A View Controller that manages the settings of the app

class SettingsViewController: UIViewController {
    
    var playMusic = true

    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var musicButton: UIButton!
    @IBAction func musicButtonTapped(_ sender: UIButton) {
        if playMusic {
            musicButton.setImage(UIImage(named: "switchOff"), for: .normal)
            UserDefaults.standard.set(1, forKey: "musicStatus")
        } else {
            musicButton.setImage(UIImage(named: "switchOn"), for: .normal)
            UserDefaults.standard.set(0, forKey: "musicStatus")
        }
        
        playMusic = !playMusic
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nickNameTextField.delegate = self
        nickNameTextField.text = UserData.shared.nickName
        nickNameTextField.font = UIFont(name: "BradyBunchRemastered", size: 30)
        
        let status = UserDefaults.standard.integer(forKey: "musicStatus")
        if status == 1 {
            musicButton.setImage(UIImage(named: "switchOff"), for: .normal)
            playMusic = false
        }
    }
    
    @IBAction func unwindToSettingsVC(_ sender: UIStoryboardSegue) {
        
    }

}

extension SettingsViewController : UITextFieldDelegate {

}

