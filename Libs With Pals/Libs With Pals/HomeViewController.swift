//
//  HomeViewController.swift
//  Libs With Pals
//
//  Created by Sonam Benakatti on 3/15/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var greetingLabel: UILabel!
    let prefs:UserDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize the screen to greet the user with their name
        let name = String(describing: prefs.value(forKey: "name")!)
        greetingLabel.text = "Hi, " +  name + "!"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onNewGameButtonPressed(_ sender: Any) {
        let twoPlayer = prefs.bool(forKey: "twoPlayer")
        if(twoPlayer) {
            self.performSegue(withIdentifier: "homeToTwoPlayerSegue", sender: AnyClass.self)
        } else {
            self.performSegue(withIdentifier: "homeToOnePlayerSegue", sender: AnyClass.self)

        }
        
    }
    

}
