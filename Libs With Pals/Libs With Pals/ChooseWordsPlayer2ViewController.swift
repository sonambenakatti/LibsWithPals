//
//  ChooseWordsPlayer2ViewController.swift
//  Libs With Pals
//
//  Created by Rethi, Jennifer L on 4/2/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit

class ChooseWordsPlayer2ViewController: UIViewController{
    
    //TODO: change this class to work for 2 player
    
    var container: WordsFormViewControllerPlayer2?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChooseWordsPlayer2Embed",
            let destination = segue.destination as? WordsFormViewControllerPlayer2 {
            destination.delegate? = self
            container = destination
        } else if segue.identifier == "Player2DoneEnteringWordsSegue",
            let destination = segue.destination as? FinalStorylineViewController {
            destination.words = (container?.words)!
            destination.name = (container?.name)!
            //destination.storyline = storyline
        }
    }
    
    // Return home but first warn the user they will lose their progress
    @IBAction func onHomeButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure?", message: "If you return home you will lose your mad lib.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
            self.performSegue(withIdentifier: "Player2DoneEnteringWordsSegue", sender: AnyClass.self)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Take user to final storyline if all fields are filled out
    @IBAction func onMakeMyMadLibPressed(_ sender: Any) {
        if (self.container?.checkIfAllRowsFilled())! {
            var message = Message(actionDict: [:], enteredWords: [])
            // send message to other player that the enter words button has been pressed
            message.actionDict["chooseSentencesClicked"] = false
            message.actionDict["enterWordsClicked"] = false
            message.actionDict["doneEnteringSentences"] = false
            message.actionDict["doneEnteringWords"] = true
            message.enteredWords = []
            self.performSegue(withIdentifier: "ChooseWordsToFinalStorySegue", sender: AnyClass.self)
        } else {
            let alert = UIAlertController(title: "Looks like you missed some words!", message: "You must fill out all the fields.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
}
