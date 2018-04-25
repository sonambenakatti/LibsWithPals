//
//  startTwoPlayerGameViewController.swift
//  Libs With Pals
//
//  Created by Rethi, Jennifer L on 3/31/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class TwoPlayerStartGameViewController: UIViewController {
    
    @IBOutlet weak var enterWordsButton: UIButton!
    @IBOutlet weak var chooseSentencesButton: UIButton!
    var appDelegate: AppDelegate!
    @IBOutlet weak var navBar: UINavigationBar!
    var enterWordsClicked: Bool = false
    
    //  dictionary to display disabled button to other player
    var messageDict: [String:Bool] = [:]
    
    override func viewDidLoad() {
        navBar.topItem?.title = "Connected"
        // add observer to be notified when data is recieved over the server
        NotificationCenter.default.addObserver(self, selector: #selector(handleRecieveDataWithNotification(notification:)) , name: NSNotification.Name(rawValue: "MPC_DidRecieveDataNotification"), object: nil)
    }
    
    // function when the player wants to choose the sentences 
    @IBAction func chooseSentencesClicked(_ sender: Any) {
        // send message to other player that the chooseSentences button has been pressed over server
        var actionDict: [String: Bool] = [:]
        setNeededValuesInJson(dataToSend: &actionDict, Vals: [false, false, true, false, true, true, false])
        sendDataOverServer(dataToSend: actionDict)
        self.performSegue(withIdentifier: "TwoPlayerWriteStorySegue", sender: AnyClass.self)
    }
    
    @IBAction func enterWordsClicked(_ sender: Any) {
        // send message to other player that the enter words button has been pressed over server
        var actionDict: [String: Bool] = [:]
        setNeededValuesInJson(dataToSend: &actionDict, Vals: [false, true, false, false, true, true, false])
        sendDataOverServer(dataToSend: actionDict)
        enterWordsClicked = true
        self.performSegue(withIdentifier: "TwoPlayerEnterWordsSegue", sender: AnyClass.self)
    }
    
    // function to handle the recieved data between players
    @objc func handleRecieveDataWithNotification(notification:NSNotification){
        let userInfo = notification.userInfo! as Dictionary
        let recievedData:Data = userInfo["data"] as! Data
        do {
            let message = try JSONSerialization.jsonObject(with: recievedData, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary<String, Bool>
            if message["connected"]! == false {
                lostConnection()
            } else {
                // don't let other player click enter words
                if message["enterWordsClicked"]! {
                    enterWordsClicked = true
                    disableWordsButton()
                    // don't let other player click choose sentences
                } else if message["chooseSentencesClicked"]! {
                    disableSentencesButton()
                }
                if !message["responding"]! {
                    playerNotResponding()
                }
            }
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func playerNotResponding() {
        var actionDict: Dictionary<String, Bool> = [:]
        let alert = UIAlertController(title: "Please respond to other player", message: "Please press 'Enter Words' to conintue the game, or go home to end session", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Enter words", style: UIAlertActionStyle.default, handler: { action in
            self.setNeededValuesInJson(dataToSend: &actionDict, Vals: [false, true, false, false, true, true, true])
            self.sendDataOverServer(dataToSend: actionDict)
            self.performSegue(withIdentifier: "TwoPlayerEnterWordsSegue", sender: AnyClass.self)
        }))
        alert.addAction(UIAlertAction(title: "Go Home", style: UIAlertActionStyle.default, handler: { action in
            var actionDict: Dictionary<String, Bool> = [:]
            self.setNeededValuesInJson(dataToSend: &actionDict, Vals: [false, false, false, false, false, true, false])
            self.sendDataOverServer(dataToSend: actionDict)
            self.performSegue(withIdentifier: "TwoPlayerStartGameToHome", sender: AnyClass.self)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func disableWordsButton() {
        enterWordsButton?.isUserInteractionEnabled = false
        enterWordsButton?.isEnabled = false
        self.view.reloadInputViews()
    }
    
    func disableSentencesButton() {
        chooseSentencesButton?.isUserInteractionEnabled = false
        chooseSentencesButton?.isEnabled = false
        self.view.reloadInputViews()
    }
    
    func lostConnection() {
        navBar.topItem?.title = "Disconnected"
        let alert = UIAlertController(title: "The other player has left the session", message: "Please return home to connect another player or play in one player mode.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Go home", style: UIAlertActionStyle.default, handler: { action in
            self.performSegue(withIdentifier: "TwoPlayerStartGameToHome", sender: AnyClass.self)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        disableWordsButton()
        disableSentencesButton()
    }
    
    @IBAction func onHomePressed(_ sender: Any) {
        var actionDict: Dictionary<String, Bool> = [:]
        setNeededValuesInJson(dataToSend: &actionDict, Vals: [false, false, false, false, false, true, false])
        sendDataOverServer(dataToSend: actionDict)
        self.performSegue(withIdentifier: "TwoPlayerStartGameToHome", sender: AnyClass.self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TwoPlayerWriteStorySegue" {
            let vc: TwoPlayerCreateStoryViewController = segue.destination as! TwoPlayerCreateStoryViewController
            vc.appDelegate = self.appDelegate
            print("Enter Words Clicked value, \(enterWordsClicked)")
            vc.enterWordsClicked = self.enterWordsClicked
        } else if segue.identifier == "TwoPlayerEnterWordsSegue" {
            let vc: TwoPlayerLoadingSentencesViewController = segue.destination as! TwoPlayerLoadingSentencesViewController
            vc.appDelegate = self.appDelegate
        }
    }
}

