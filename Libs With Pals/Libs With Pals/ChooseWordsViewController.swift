//
//  ChooseWordsViewController.swift
//  Libs With Pals
//
//  Created by Sonam Benakatti on 3/27/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit
import Eureka

class ChooseWordsViewController: UIViewController {
    
    var storyline: Storyline? = nil
    var container: WordsFormViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChooseWordsToFormSegue",
            let destination = segue.destination as? WordsFormViewController {
                destination.storyline = storyline
                destination.delegate = self
                container = destination
        } else if segue.identifier == "ChooseWordsToFinalStorySegue",
            let destination = segue.destination as? FinalStorylineViewController {
            destination.words = (container?.words)!
            destination.storyline = storyline?.getStory()
        }
    }

    // Return home but first warn the user they will lose their progrress
    @IBAction func onHomeButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Are you sure?", message: "If you return home you will lose your mad lib.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
            self.performSegue(withIdentifier: "chooseWordsToHomeSegue", sender: AnyClass.self)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Take user to final storyline if all fields are filled out
    @IBAction func onMakeMyMadLibPressed(_ sender: Any) {

        if (self.container?.checkIfAllRowsFilled())! {
            self.performSegue(withIdentifier: "ChooseWordsToFinalStorySegue", sender: AnyClass.self)
        }
        
        // TODO: Add an alert that lets the user know they need to fill out all fields
    }
}
