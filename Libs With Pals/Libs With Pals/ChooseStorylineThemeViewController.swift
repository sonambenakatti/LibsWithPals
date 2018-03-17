//
//  ChooseStorylineThemeViewController.swift
//  Libs With Pals
//
//  Created by Sonam Benakatti on 3/17/18.
//  Copyright © 2018 Group8. All rights reserved.
//

// When the game is in single player mode, the player chooses a storyline theme

import UIKit

class ChooseStorylineThemeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onHomePressed(_ sender: Any) {
        self.performSegue(withIdentifier: "storylineThemeToHomeSegue", sender: AnyClass.self)
    }
}
