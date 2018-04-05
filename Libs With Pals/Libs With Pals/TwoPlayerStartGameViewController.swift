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
    
    //  dictionary to display disabled button to other player
    var messageDict: [String:Bool] = [:]
    
    override func viewDidLoad() {
        
        // add observer to be notified when data is recieved over the server
        NotificationCenter.default.addObserver(self, selector: #selector(handleRecieveDataWithNotification(notification:)) , name: NSNotification.Name(rawValue: "MPC_DidRecieveDataNotification"), object: nil)
    }
    
    // function when the player wants to choose the sentences 
    @IBAction func chooseSentencesClicked(_ sender: Any) {
        let disableMyButton = sender as? UIButton
        disableMyButton?.isUserInteractionEnabled = false
        disableMyButton?.isEnabled = false
        self.view.reloadInputViews()
        var actionDict: [String: Bool] = [:]
        // send message to other player that the chooseSentences button has been pressed over server
        actionDict["chooseSentencesClicked"] = true
        actionDict["enterWordsClicked"] = false
        actionDict["doneEnteringSentences"] = false
        actionDict["doneEnteringWords"] = false
        do {
            let messageData = try JSONSerialization.data(withJSONObject: actionDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            try appDelegate.mpcHandler.session.send(messageData, toPeers: appDelegate.mpcHandler.session.connectedPeers, with: MCSessionSendDataMode.reliable)
            self.performSegue(withIdentifier: "TwoPlayerWriteStorySegue", sender: AnyClass.self)
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    @IBAction func enterWordsClicked(_ sender: Any) {
        // send message to other player that the enter words button has been pressed over server
        var actionDict: [String: Bool] = [:]
        actionDict["chooseSentencesClicked"] = false
        actionDict["enterWordsClicked"] = true
        actionDict["doneEnteringSentences"] = false
        actionDict["doneEnteringWords"] = false
        do {
            let messageData = try JSONSerialization.data(withJSONObject: actionDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            try appDelegate.mpcHandler.session.send(messageData, toPeers: appDelegate.mpcHandler.session.connectedPeers, with: MCSessionSendDataMode.reliable)
            self.performSegue(withIdentifier: "TwoPlayerEnterWordsSegue", sender: AnyClass.self)
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
    // function to handle the recieved data between players
    @objc func handleRecieveDataWithNotification(notification:NSNotification){
        let userInfo = notification.userInfo! as Dictionary
        let recievedData:Data = userInfo["data"] as! Data
        do {
            let message = try JSONSerialization.jsonObject(with: recievedData, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary<String, Bool>
            
            // don't let other player click enter words
            if message["enterWordsClicked"]! {
                enterWordsButton?.isUserInteractionEnabled = false
                enterWordsButton?.isEnabled = false
                self.view.reloadInputViews()
            // don't let other player click choose sentences
            } else if message["chooseSentencesClicked"]! {
                chooseSentencesButton?.isUserInteractionEnabled = false
                chooseSentencesButton?.isEnabled = false
                self.view.reloadInputViews()
            }
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TwoPlayerWriteStorySegue" {
            let vc: TwoPlayerCreateStoryViewController = segue.destination as! TwoPlayerCreateStoryViewController
            vc.appDelegate = self.appDelegate
        } else if segue.identifier == "TwoPlayerEnterWordsSegue" {
            let vc: TwoPlayerLoadingSentencesViewController = segue.destination as! TwoPlayerLoadingSentencesViewController
            vc.appDelegate = self.appDelegate
        }
    }
    
}

