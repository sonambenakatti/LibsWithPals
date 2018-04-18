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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // get the types of words inputed by player one
    func getTypesOfWords() -> Array<String>{
        var userWords: Array<String> = []
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
            userWords.append(ordered[i]!)
        }
        return userWords
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TwoPlayerChooseWordsEmbed",
            let destination = segue.destination as? TwoPlayerWordsFormViewController {
            destination.delegate = self
            container = destination
            self.container?.userEnteredWords = getTypesOfWords()
        } //else if segue.identifier == "TwoPlayerWordsFinalStorylineSegue",
            //let destination = segue.destination as? TwoPlayerFinalStorylineViewController {
            //destination.words = userWords
            
        //}
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
            // send entered words to next player so they can see their final mad lib
            setNeededValuesInJson(dataToSend: &actionDict, Vals: [false, false, false, true])
            sendDataOverServer(dataToSend: actionDict)
            self.performSegue(withIdentifier: "TwoPlayerWordsFinalStorylineSegue", sender: AnyClass.self)
        } else {
            let alert = UIAlertController(title: "Looks like you missed some words!", message: "You must fill out all the fields.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
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
