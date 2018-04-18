//
//  Player2LoadingWordsViewController.swift
//  Libs With Pals
//
//  Created by Rethi, Jennifer L on 4/2/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit

class TwoPlayerLoadingWordsViewController: UIViewController {
    
    var appDelegate: AppDelegate!
    var words: [String] = []
    var sentences: [String] = []
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleRecieveDataWithNotification(notification:)) , name: NSNotification.Name(rawValue: "MPC_DidRecieveDataNotification"), object: nil)
        // Do any additional setup after loading the view.
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
            // player 2 is done entering sentences
            print("In two player loading words VC")
            if message["doneEnteringWords"]! {
                self.performSegue(withIdentifier: "TwoPlayerSentencesFinalStorylineSegue", sender: AnyClass.self)
            }
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TwoPlayerSentencesFinalStorylineSegue",
            let destination = segue.destination as? TwoPlayerFinalStorylineViewController {
            destination.words = self.words
            destination.sentences = self.sentences
        }
    }
    
}
