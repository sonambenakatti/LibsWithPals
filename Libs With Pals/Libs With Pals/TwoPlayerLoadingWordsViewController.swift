//
//  Player2LoadingWordsViewController.swift
//  Libs With Pals
//
//  Created by Rethi, Jennifer L on 4/2/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import SwiftSpinner

class TwoPlayerLoadingWordsViewController: UIViewController {
    
    var appDelegate: AppDelegate!
    var message: Dictionary<String, Bool> = [:]
    var sentences: [String] = []
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleRecieveDataWithNotification(notification:)) , name: NSNotification.Name(rawValue: "MPC_DidRecieveDataNotification"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SwiftSpinner.show(delay: 0.5, title: "Player 2 is Entering Words", animated: true)
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
            } else {
                // player 2 is done entering words
                if message["doneEnteringWords"]! {
                    // message containing entered words
                    self.message = message
                    self.performSegue(withIdentifier: "TwoPlayerSentencesFinalStorylineSegue", sender: AnyClass.self)
                }
            }
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func lostConnection() {
        let alert = UIAlertController(title: "The other player has left the session", message: "Please return home to connect another player or play in one player mode.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Go home", style: UIAlertActionStyle.default, handler: { action in
            self.performSegue(withIdentifier: "TwoPlayerLoadingWordsToHome", sender: AnyClass.self)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onHomePressed(_ sender: Any) {
        var actionDict: Dictionary<String, Bool> = [:]
        setNeededValuesInJson(dataToSend: &actionDict, Vals: [false, false, false, false, false, true, false])
        sendDataOverServer(dataToSend: actionDict)
        performSegue(withIdentifier: "TwoPlayerLoadingWordsToHome" , sender: AnyClass.self)
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
    
    // function to prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TwoPlayerSentencesFinalStorylineSegue",
            let destination = segue.destination as? TwoPlayerFinalStorylineViewController {
            destination.message = self.message
            destination.sentences = self.sentences
        }
    }
    
}

