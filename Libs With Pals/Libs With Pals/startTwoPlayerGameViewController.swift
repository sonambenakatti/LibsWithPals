//
//  startTwoPlayerGameViewController.swift
//  Libs With Pals
//
//  Created by Rethi, Jennifer L on 3/31/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class startTwoPlayerGameViewController: UIViewController {
    
    @IBOutlet weak var enterWordsButton: UIButton!
    @IBOutlet weak var chooseSentencesButton: UIButton!
    var appDelegate: AppDelegate!
    
    //  dictionary to display disabled button to other player
    var messageDict: [String:Bool] = [:]
    
    override func viewDidLoad() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleRecieveDataWithNotification(notification:)) , name: NSNotification.Name(rawValue: "MPC_DidRecieveDataNotification"), object: nil)
    }
    
    @IBAction func chooseSentencesClicked(_ sender: Any) {
        let disableMyButton = sender as? UIButton
        disableMyButton?.isUserInteractionEnabled = false
        disableMyButton?.isEnabled = false
        self.view.reloadInputViews()
        var message = Message(actionDict: [:], enteredWords: [])
        // send message to other player that the chooseSentences button has been pressed
        message.actionDict["chooseSentencesClicked"] = true
        message.actionDict["enterWordsClicked"] = false
        message.actionDict["doneEnteringSentences"] = false
        message.actionDict["doneEnteringWords"] = false
        message.enteredWords = []
        do {
            let encoder = JSONEncoder()
            let messageJSON = try encoder.encode(message)
            let messageData = try JSONSerialization.data(withJSONObject: messageJSON, options: JSONSerialization.WritingOptions.prettyPrinted)
            try appDelegate.mpcHandler.session.send(messageData, toPeers: appDelegate.mpcHandler.session.connectedPeers, with: MCSessionSendDataMode.reliable)
            self.performSegue(withIdentifier: "createStorySegue", sender: AnyClass.self)
            print("in sentences clicked")
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
    @IBAction func enterWordsClicked(_ sender: Any) {
        var message = Message(actionDict: [:], enteredWords: [])
        // send message to other player that the enter words button has been pressed
        message.actionDict["chooseSentencesClicked"] = false
        message.actionDict["enterWordsClicked"] = true
        message.actionDict["doneEnteringSentences"] = false
        message.actionDict["doneEnteringWords"] = false
        message.enteredWords = []
        do {
            let encoder = JSONEncoder()
            let messageJSON = try encoder.encode(message)
            let messageData = try JSONSerialization.data(withJSONObject: messageJSON, options: JSONSerialization.WritingOptions.prettyPrinted)
            try appDelegate.mpcHandler.session.send(messageData, toPeers: appDelegate.mpcHandler.session.connectedPeers, with: MCSessionSendDataMode.reliable)
            self.performSegue(withIdentifier: "enterWordsSegue", sender: AnyClass.self)
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
    // function to handle the recieved data between players
    @objc func handleRecieveDataWithNotification(notification:NSNotification){
        let userInfo = notification.userInfo! as Dictionary
        let recievedData:Data = userInfo["data"] as! Data
        do {
            let message = try JSONSerialization.jsonObject(with: recievedData, options: JSONSerialization.ReadingOptions.allowFragments) as! Message
            // don't let other player click enter words
            if message.actionDict["enterWordsClicked"]! {
                enterWordsButton?.isUserInteractionEnabled = false
                enterWordsButton?.isEnabled = false
                self.view.reloadInputViews()
                // don't let other player click choose sentences
            } else if message.actionDict["chooseSentencesClicked"]! {
                chooseSentencesButton?.isUserInteractionEnabled = false
                chooseSentencesButton?.isEnabled = false
                self.view.reloadInputViews()
            }
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createStorySegue" {
            let vc: TwoPlayerCreateStoryViewController = segue.destination as! TwoPlayerCreateStoryViewController
            vc.appDelegate = self.appDelegate
        }
    }
    
}

