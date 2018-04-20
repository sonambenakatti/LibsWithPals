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
    var words: Dictionary<String, Bool> = [:]
    var userSentences: [String] = []
    var userWords: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // get the types of words inputed by player one
    func getTypesOfWords(){
        var ordered: Dictionary<Int, String> = [:]
        for (word, _) in self.words {
            // need to make sure that word is not identified as sentence and not other data sent over server
            if(word != "doneEnteringSentences"
                && word != "enterWordsClicked"
                && word != "chooseSentencesClicked"
                && word != "doneEnteringWords") {
                // get rid of identifier on word
                var newWord = word
                let lastChar = newWord.removeLast()
                let val = Int(String(lastChar))
                ordered[val!] = newWord
            }
        }
        // Ensure the words are in order because words is a dictionary and therefore order is not guaranteed
        for i in 0...ordered.count - 1 {
            if i % 2 == 0 {
                userWords.append(ordered[i]!)
            } else {
                userSentences.append(ordered[i]!)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TwoPlayerChooseWordsEmbed",
            let destination = segue.destination as? TwoPlayerWordsFormViewController {
            getTypesOfWords()
            print("User sentences \(userSentences)")
            destination.delegate = self
            container = destination
            self.container?.userEnteredWords = userWords
        } else if segue.identifier == "TwoPlayerWordsFinalStorylineSegue",
            let destination = segue.destination as? TwoPlayerFinalStorylineViewController {
            destination.passedWords = (container?.words)!
            destination.sentences = userSentences
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
            words = [:]
            processEnteredSentences()
            setNeededValuesInJson(dataToSend: &words, Vals: [false, false, false, true])
            sendDataOverServer(dataToSend: words)
            self.performSegue(withIdentifier: "TwoPlayerWordsFinalStorylineSegue", sender: AnyClass.self)
        } else {
            let alert = UIAlertController(title: "Looks like you missed some words!", message: "You must fill out all the fields.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    // Ensure the story is in order because words is a dictionary and therefore order is not guaranteed
    func processEnteredSentences() {
        var orderWords = 0
        for i in 0...(container?.words.count)! - 1 {
            var newWord = container?.words[String(i)]!! as! String
            // concat a number at the end of the string to specify an order to put it in
            let orderS = String(orderWords)
            newWord = newWord + orderS
            orderWords = orderWords + 1
            words[newWord] = true
        }
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
            let messageData = try JSONSerialization.data(withJSONObject: dataToSend, options: JSONSerialization.WritingOptions.prettyPrinted)
            try appDelegate.mpcHandler.session.send(messageData, toPeers: appDelegate.mpcHandler.session.connectedPeers, with: MCSessionSendDataMode.reliable)
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
}

