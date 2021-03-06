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
    
    @IBOutlet weak var navBar: UINavigationBar!
    var container: TwoPlayerWordsFormViewController?
    var appDelegate: AppDelegate!
    
    // types of words and sentences entered by player 1 when creating sentences
    var words: Dictionary<String, Bool> = [:]
    
    // sentences entered by player one
    var userSentences: [String] = []
    
    // words entered by this player
    var userWords: [String] = []
    
    // temporary dict to handle putting words in order
    var ordered: Dictionary<Int, String> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add observer to be notified when data is recieved over the server
        NotificationCenter.default.addObserver(self, selector: #selector(handleRecieveDataWithNotification(notification:)) , name: NSNotification.Name(rawValue: "MPC_DidRecieveDataNotification"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // function to handle the recieved data between players
    @objc func handleRecieveDataWithNotification(notification:NSNotification){
        let userInfo = notification.userInfo! as Dictionary
        let recievedData:Data = userInfo["data"] as! Data
        do {
            let message = try JSONSerialization.jsonObject(with: recievedData, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary<String, Bool>
            if message["connected"]! == false {
                lostConnection()
            }
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
    // handle when the other player has left the session
    func lostConnection() {
        navBar.topItem?.title = "Disconnected"
        let alert = UIAlertController(title: "The other player has left the session", message: "Please return home to connect another player or play in one player mode.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Go home", style: UIAlertActionStyle.default, handler: { action in
            self.performSegue(withIdentifier: "TwoPlayerChooseWordsToHome", sender: AnyClass.self)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // get the types of words inputed by player one
    func getTypesOfWords(){
        for (word, _) in self.words {
            // need to make sure that word is not other data sent over server
            if(word != "doneEnteringSentences"
                && word != "enterWordsClicked"
                && word != "chooseSentencesClicked"
                && word != "doneEnteringWords"
                && word != "connected"
                && word != "responding"
                && word != "doneResponding") {
                // last char is an int corresponding to the order it was entered in 
                var newWord = word
                let lastChar = newWord.removeLast()
                let val = Int(String(lastChar))
                // add to ordered dictionary
                ordered[val!] = newWord
            }
        }
    }
    
    // put all of the types of words and sentences in the correct order
    func orderWordsAndSentences() {
        for i in 0...ordered.count - 1 {
            // types of words will have even order (0, 2, 4...)
            if i % 2 == 0 {
                userWords.append(ordered[i]!)
            // sentences will have odd order (1, 3, 5 ...)
            } else {
                var sentence = ordered[i]!
                sentence.removeLast()
                userSentences.append(ordered[i]!)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // show types of words to this player
        if segue.identifier == "TwoPlayerChooseWordsEmbed",
            let destination = segue.destination as? TwoPlayerWordsFormViewController {
            getTypesOfWords()
            orderWordsAndSentences()
            destination.delegate = self
            container = destination
            self.container?.userEnteredWords = userWords
        } else if segue.identifier == "TwoPlayerWordsFinalStorylineSegue",
            let destination = segue.destination as? TwoPlayerFinalStorylineViewController {
            // pass entered words to final storyline
            destination.passedWords = (container?.words)!
            // pass entered sentences to final storyline
            destination.sentences = userSentences
        }
    }
    
    // Return home but first warn the user they will lose their progress
    @IBAction func onHomeButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure?", message: "If you return home you will lose your mad lib.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
            var actionDict: Dictionary<String, Bool> = [:]
            self.setNeededValuesInJson(dataToSend: &actionDict, Vals: [false, false, false, false, false, true, false])
            self.sendDataOverServer(dataToSend: actionDict)
            self.performSegue(withIdentifier: "TwoPlayerChooseWordsToHome", sender: AnyClass.self)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Take user to final storyline if all fields are filled out
    @IBAction func onMakeMyMadLibPressed(_ sender: Any) {
        if (self.container?.checkIfAllRowsFilled())! {
            // send entered words to other player over the server
            processEnteredWords()
            setNeededValuesInJson(dataToSend: &words, Vals: [false, false, false, true, true, true, true, false])
            sendDataOverServer(dataToSend: words)
            self.performSegue(withIdentifier: "TwoPlayerWordsFinalStorylineSegue", sender: AnyClass.self)
        } else {
            let alert = UIAlertController(title: "Looks like you missed some words!", message: "You must fill out all the fields.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // Ensure the story is in order because words is a dictionary and therefore order is not guaranteed
    func processEnteredWords() {
        // clear words dict to send entered words to other player's final storyline
        words = [:]
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
        dataToSend["connected"] = Vals[4]
        dataToSend["responding"] = Vals[5]
        dataToSend["doneResponding"] = Vals[5]
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

