//
//  SettingsViewController.swift
//  Chiyao
//
//  Created by Andy Uyeda on 10/24/19.
//  Copyright © 2019 AndyUyeda. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var englishSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let state = UserDefaults.standard.bool(forKey: "english_switch")
        
        englishSwitch.setOn(state, animated: true)
    }
    
    @IBAction func englishSwitch(_ sender: Any) {
        UserDefaults.standard.set(englishSwitch.isOn, forKey: "english_switch")
    }
    
}
