//
//  LoadingScreenViewController.swift
//  Libs With Pals
//
//  Created by Rethi, Jennifer L on 4/2/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit

class TwoPlayerLoadingSentencesViewController: UIViewController {
    
    var appDelegate: AppDelegate!
    var message: Dictionary<String,Bool> = [:]
    
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
            if message["doneEnteringSentences"]! {
                print("In doneEnteringSentences")
                print(message)
                self.message = message
                self.performSegue(withIdentifier: "TwoPlayerChooseWordsSegue", sender: AnyClass.self)
            }
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TwoPlayerChooseWordsSegue",
            let destination = segue.destination as? TwoPlayerChooseWordsViewController {
            destination.appDelegate = self.appDelegate
            destination.words = self.message
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}

