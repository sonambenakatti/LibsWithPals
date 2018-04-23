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

// class to enable player to create their sentences
class TwoPlayerCreateStoryViewController: UIViewController, passEnteredWordsToPlayer2Delegate {
    
    // container delegate
    var container: TwoPlayerWriteStorylineViewController?
    // user words
    var words: Dictionary<String, Any?> = [:]
    var appDelegate: AppDelegate!
    var wordsOrdered = [String]()
    var sentencesOrdered = [String]()
    var userWordTypes: Dictionary<String, Bool> = [:]
    var userSentences: Dictionary<String, Bool> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func passEnteredWords(words: Dictionary<String, Any?>) {
        self.words = words
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onDonePressed(_ sender: Any) {
        let containerRowsAllFilled = self.container?.checkIfAllRowsFilled()
        if containerRowsAllFilled! {
            processEnteredSentences()
            setNeededValuesInJson(dataToSend: &userWordTypes, Vals: [true, false, false, false, true])
            concatDicts(left: &userWordTypes, right: userSentences)
            sendDataOverServer(dataToSend: userWordTypes)
            self.performSegue(withIdentifier: "TwoPlayerLoadingWordsSegue", sender: AnyClass.self)
        } else {
            let alert = UIAlertController(title: "Looks like you missed some words!", message: "You must fill out all the fields.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // Ensure the story is in order because words is a dictionary and therefore order is not guaranteed
    func processEnteredSentences() {
        var orderWords = 0
        var orderSentences = 1
        for i in 0...words.count - 1 {
            // if an odd index, than the value in the dictionary is a type of word
            if i % 2 != 0 {
                var newWord = words[String(i)]!! as! String
                // concat a number at the end of the string to specify an order to put it in
                let orderS = String(orderWords)
                newWord = newWord + orderS
                orderWords = orderWords + 2
                userWordTypes[newWord] = true
            } else {
                var newSentence = words[String(i)]!! as! String
                sentencesOrdered.append(newSentence)
                // concat an order on end of sentence to specify which order it is in
                let orderS = String(orderSentences)
                newSentence = newSentence + orderS
                orderSentences = orderSentences + 2
                userSentences[newSentence] = true
            }
        }
    }
    
    // function to set all needed values sent over server
    func setNeededValuesInJson(dataToSend: inout Dictionary<String, Bool>, Vals: Array<Bool>) {
        // let player know done enter sentences
        dataToSend["doneEnteringSentences"] = Vals[0]
        dataToSend["enterWordsClicked"] = Vals[1]
        dataToSend["chooseSentencesClicked"] = Vals[2]
        dataToSend["doneEnteringWords"] = Vals[3]
        dataToSend["connected"] = Vals[4]
    }
    
    // function to send data over the server
    func sendDataOverServer(dataToSend: Dictionary<String, Bool>) {
        do {
            let messageData = try JSONSerialization.data(withJSONObject: dataToSend, options: JSONSerialization.WritingOptions.prettyPrinted)
            try appDelegate.mpcHandler.session.send(messageData, toPeers: appDelegate.mpcHandler.session.connectedPeers, with: MCSessionSendDataMode.reliable)
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
    // concat 2 dicitonaies
    func concatDicts <K, V> (left: inout [K:V], right: [K:V]) {
        for (k, v) in right {
            left[k] = v
        }
    }
    
    @IBAction func onHomePressed(_ sender: Any) {
        var actionDict: Dictionary<String, Bool> = [:]
        setNeededValuesInJson(dataToSend: &actionDict, Vals: [false, false, false, false, false])
        sendDataOverServer(dataToSend: actionDict)
        self.performSegue(withIdentifier: "TwoPlayerCreateStoryToHome", sender: AnyClass.self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TwoPlayerWriteStorylineFormSegue",
            let destination = segue.destination as? TwoPlayerWriteStorylineViewController {
            container = destination
            destination.delegate = self
            destination.passWordsDelegate = self
        }
        if segue.identifier == "TwoPlayerLoadingWordsSegue",
            let destination = segue.destination as? TwoPlayerLoadingWordsViewController {
            destination.appDelegate = self.appDelegate
            destination.sentences = self.sentencesOrdered
        }
    }
    
}

