//
//  SettingsViewController.swift
//  Libs With Pals
//
//  Created by Sonam Benakatti on 3/15/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let prefs: UserDefaults = UserDefaults.standard
    @IBOutlet weak var twoPlayerSwitch: UISwitch!
    @IBOutlet weak var saveLibsSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        // Ensure switches are set to what the user last set them to
        let twoPlayer = prefs.bool(forKey: "twoPlayer")
        let saveLibs = prefs.bool(forKey: "saveLibs")
        if (twoPlayer) {
            twoPlayerSwitch.setOn(true, animated: false)
        }
        if (saveLibs) {
            saveLibsSwitch.setOn(true, animated: false)
        }
        
        super.viewDidLoad()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Save the settings in UserDefaults
        // 1. One player or two player
        // 2. Save the libs you create or don't save
        prefs.set(twoPlayerSwitch.isOn, forKey: "twoPlayer")
        prefs.set(saveLibsSwitch.isOn, forKey: "saveLibs")
        prefs.synchronize()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TODO: Link to delete account button and implement with an alert that asks user if they're sure (with options yes and no)
    // if no: do nothing
    // if yes: delete account information
    func deleteAccount() {
        
    }
    
}
