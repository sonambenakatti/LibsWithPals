//
//  startTwoPlayerGameViewController.swift
//  Libs With Pals
//
//  Created by Rethi, Jennifer L on 3/31/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit

class startTwoPlayerGameViewController: UIViewController {
   
    @IBOutlet weak var enterWordsButton: UIButton!
    @IBOutlet weak var chooseSentencesButton: UIButton!
    
    @IBAction func chooseSentencesClicked(_ sender: Any) {
        chooseSentencesButton.isEnabled = false
    }
    
    @IBAction func enterWordsClicked(_ sender: Any) {
        enterWordsButton.isEnabled = false
    }
    
    
    
}
