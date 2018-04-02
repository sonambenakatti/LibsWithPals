//
//  TwoPlayerCreateStoryViewController.swift
//  Libs With Pals
//
//  Created by Sonam Benakatti on 4/1/18.
//  Copyright © 2018 Group8. All rights reserved.
//

// For the ViewController that allows a player to create sentences for another player to fill words into

import UIKit

class TwoPlayerCreateStoryViewController: UIViewController {
    
    var container: TwoPlayerWriteStorylineViewController?


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TwoPlayerWriteStorylineFormSegue",
            let destination = segue.destination as? TwoPlayerWriteStorylineViewController {
                    container = destination
                    destination.delegate = self
            }
    }
    
    @IBAction func onDoneButtonPressed(_ sender: Any) {
        //Transfer data here
    }

}
