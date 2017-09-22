//
//  RootViewController.swift
//  CatJumpGame
//
//  Created by Isabel  Lee on 26/05/2017.
//  Copyright © 2017 isabeljlee. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func resetButton(_ sender: UIButton) {
        UserData.shared.reset()
    }
    
    
    @IBAction func coinsButton(_ sender: UIButton) {
        UserData.shared.addCoins()
    }

    @IBAction func unwindToRoot(_ sender: UIStoryboardSegue) {
        
    }
}
