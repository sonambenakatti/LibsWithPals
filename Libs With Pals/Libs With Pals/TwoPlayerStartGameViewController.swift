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
        setNeededValuesInJson(dataToSend: &actionDict, Vals: [false, false, true, false])
        sendDataOverServer(dataToSend: actionDict)
        self.performSegue(withIdentifier: "TwoPlayerWriteStorySegue", sender: AnyClass.self)
    }
    
    @IBAction func enterWordsClicked(_ sender: Any) {
        // send message to other player that the enter words button has been pressed over server
        var actionDict: [String: Bool] = [:]
        setNeededValuesInJson(dataToSend: &actionDict, Vals: [false, true, false, false])
        sendDataOverServer(dataToSend: actionDict)
        self.performSegue(withIdentifier: "TwoPlayerEnterWordsSegue", sender: AnyClass.self)
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

