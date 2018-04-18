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
            destination.passWordsDelegate = self
        }
        if segue.identifier == "TwoPlayerLoadingWordsSegue",
            let destination = segue.destination as? TwoPlayerLoadingWordsViewController {
            destination.appDelegate = self.appDelegate
            destination.words = wordsOrdered
            destination.sentences = sentencesOrdered
        }
    }
    
    func passEnteredWords(words: Dictionary<String, Any?>) {
        self.words = words
        print(self.words)
    }
    
    // Ensure the story is in order because words is a dictionary and therefore order is not guaranteed
    func putStoryInOrder() {
        for i in 0...words.count - 1 {
            // if an odd index, than the value in the dictionary is a type of word
            if i % 2 != 0 {
                wordsOrdered.append(words[String(i)]!! as! String)
            } else {
                sentencesOrdered.append(words[String(i)]!! as! String)
            }
        }
    }

    // get the types of words inputed by player one
    func getTypesOfWords() -> Dictionary<String, Bool>{
        var userWords: Dictionary<String, Bool> = [:]
        var order = 0
        for word in self.wordsOrdered {
            var newWord = word
            // concat an order on end of word to indentify as user inputed word in what oreder they put it in
            let orderS = String(order)
            newWord = word + orderS
            order = order + 1
            userWords[newWord] = true
        }
        setNeededValuesInJson(dataToSend: &userWords, Vals: [true, false, false, false])
        return userWords
    }
    
    // function to return the created sentences made by the user
    func getSentences() -> Dictionary<String, Bool>{
        var userSentences: Dictionary<String, Bool> = [:]
        var order = 0
        for sentence in self.sentencesOrdered {
            var newSentence = sentence
            // concat an order on end of sentence to specify which order it is in
            let orderS = String(order)
            newSentence = sentence + orderS
            order = order + 1
            userSentences[newSentence] = true
        }
        setNeededValuesInJson(dataToSend: &userSentences, Vals: [true, false, false, false])
        return userSentences
    }
    
    // function to check that the user inputted all the required fields
    func checkUserInputtedAllNeededWords() {
        if (self.container?.checkIfAllRowsFilled())! == false {
            let alert = UIAlertController(title: "Looks like you missed some words!", message: "You must fill out all the fields.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func onDonePressed(_ sender: Any) {
        checkUserInputtedAllNeededWords()
        putStoryInOrder()
        let userEnteredWords = getTypesOfWords()
        let userEnteredSentences = getSentences()
        sendDataOverServer(dataToSend: userEnteredWords)
        //sendDataOverServer(dataToSend: userEnteredSentences)
    }
    
    // function to set all needed values sent over server
    func setNeededValuesInJson(dataToSend: inout Dictionary<String, Bool>, Vals: Array<Bool>) {
        // let player know done enter sentences
        dataToSend["doneEnteringSentences"] = Vals[0]
        dataToSend["enterWordsClicked"] = Vals[1]
        dataToSend["chooseSentencesClicked"] = Vals[2]
        dataToSend["doneEnteringWords"] = Vals[3]
    }
    
    // function to send data over the server
    func sendDataOverServer(dataToSend: Dictionary<String, Bool>) {
        do {
            //sending data
            print("In SendDataOverServer")
            print(dataToSend)
            let messageData = try JSONSerialization.data(withJSONObject: dataToSend, options: JSONSerialization.WritingOptions.prettyPrinted)
            try appDelegate.mpcHandler.session.send(messageData, toPeers: appDelegate.mpcHandler.session.connectedPeers, with: MCSessionSendDataMode.reliable)
            self.performSegue(withIdentifier: "TwoPlayerLoadingWordsSegue", sender: AnyClass.self)
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
    
}

