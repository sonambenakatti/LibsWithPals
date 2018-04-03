//
//  TwoPlayerCreateStoryViewController.swift
//  Libs With Pals
//
//  Created by Sonam Benakatti on 4/1/18.
//  Copyright © 2018 Group8. All rights reserved.
//

// For the ViewController that allows a player to create sentences for another player to fill words into

import UIKit
import MultipeerConnectivity


class TwoPlayerCreateStoryViewController: UIViewController, passEnteredWordsToPlayer2Delegate {
    
    var container: TwoPlayerWriteStorylineViewController?
    var words: Dictionary<String, Any?> = [:]
    var appDelegate: AppDelegate!
    
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
    
    func passEnteredWords(words: Dictionary<String, Any?>) {
        self.words = words
    }
    
    // get the types of words inputed by player one
    func getTypesOfWords() -> Array<String>{
        var userWords: Array<String> = []
        for (index, word) in self.words {
            let i = Int(index)
            // if an odd index, than the value in the dictionary is a type of word
            if i! % 2 != 0 {
                userWords.append(word as! String)
            }
        }
        return userWords
    }
    
    func checkUserInputtedAllNeededWords() {
        if (self.container?.checkIfAllRowsFilled())! == false {
            let alert = UIAlertController(title: "Looks like you missed some words!", message: "You must fill out all the fields.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // check that player one inputted all types
    @IBAction func onDoneButtonPressed(_ sender: Any) {
        checkUserInputtedAllNeededWords()
        notifyPlayer2DoneEnteringSentences()
        passDataToPlayer2()
        self.performSegue(withIdentifier: "enteringWordsSegue", sender: AnyClass.self)
    }
    
    func notifyPlayer2DoneEnteringSentences() {
        var actionDict: [String: Bool] = [:]
        //  list to send words to player 2
        // send message to other player that this player is done entering sentences 
        actionDict["doneEnteringSentences"] = true
        actionDict["enterWordsClicked"] = false
        actionDict["chooseSentencesClicked"] = false
        actionDict["doneEnteringWords"] = false
        // notify player two that player 1 is done entering sentences
        do {
            let messageData = try JSONSerialization.data(withJSONObject: actionDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            try appDelegate.mpcHandler.session.send(messageData, toPeers: appDelegate.mpcHandler.session.connectedPeers, with: MCSessionSendDataMode.reliable)
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func passDataToPlayer2() {
        var actionDict: [String: Array<String>] = [:]
        //  list to send words to player 2
        actionDict["typesOfWords"] = getTypesOfWords()
        // send types of words to player 2
        do {
            let encoder = JSONEncoder()
            let messageJSON = try encoder.encode(actionDict)
            let messageData = try JSONSerialization.data(withJSONObject: messageJSON, options: JSONSerialization.WritingOptions.prettyPrinted)
            try appDelegate.mpcHandler.session.send(messageData, toPeers: appDelegate.mpcHandler.session.connectedPeers, with: MCSessionSendDataMode.reliable)
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
}

