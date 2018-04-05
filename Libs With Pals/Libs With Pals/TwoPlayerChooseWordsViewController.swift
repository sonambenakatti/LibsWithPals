//
//  ChooseWordsPlayer2ViewController.swift
//  Libs With Pals
//
//  Created by Rethi, Jennifer L on 4/2/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class TwoPlayerChooseWordsViewController: UIViewController{
    
    var container: TwoPlayerWordsFormViewController?
    var appDelegate: AppDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TwoPlayerChooseWordsEmbed",
            let destination = segue.destination as? TwoPlayerWordsFormViewController {
            //destination.storyline = storyline
            destination.delegate = self
            container = destination
        } else if segue.identifier == "TwoPlayerWordsFinalStorylineSegue",
            let destination = segue.destination as? TwoPlayerFinalStorylineViewController {
        }
    }
    
    // Return home but first warn the user they will lose their progress
    @IBAction func onHomeButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure?", message: "If you return home you will lose your mad lib.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
            self.performSegue(withIdentifier: "TwoPlayerChooseWordsToHome", sender: AnyClass.self)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Take user to final storyline if all fields are filled out
    @IBAction func onMakeMyMadLibPressed(_ sender: Any) {
        if (self.container?.checkIfAllRowsFilled())! {
            var actionDict: [String: Bool] = [:]
            // send message to other player that the enter words button has been pressed
            actionDict["doneEnteringSentences"] = false
            actionDict["enterWordsClicked"] = false
            actionDict["chooseSentencesClicked"] = false
            actionDict["doneEnteringWords"] = true
            do {
                let messageData = try JSONSerialization.data(withJSONObject: actionDict, options: JSONSerialization.WritingOptions.prettyPrinted)
                try appDelegate.mpcHandler.session.send(messageData, toPeers: appDelegate.mpcHandler.session.connectedPeers, with: MCSessionSendDataMode.reliable)
            } catch let error as NSError {
                print("error: \(error.localizedDescription)")
            }
            self.performSegue(withIdentifier: "TwoPlayerWordsFinalStorylineSegue", sender: AnyClass.self)
        } else {
            let alert = UIAlertController(title: "Looks like you missed some words!", message: "You must fill out all the fields.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
}
