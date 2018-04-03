//
//  ConnectPlayerViewController.swift
//  Libs With Pals
//
//  Created by Rethi, Jennifer L on 3/4/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import Foundation

class ConnectPlayerViewController: UIViewController, MCBrowserViewControllerDelegate {
    
    @IBOutlet weak var navBar: UINavigationBar!
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.mpcHandler.setupPeerWithDisplayName(displayName: UIDevice.current.name)
        appDelegate.mpcHandler.setupSession()
        appDelegate.mpcHandler.advertiseSelf(advertise: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(peerChangedStateWithNotification(notification:)), name: NSNotification.Name(rawValue: "MPC_DidChangeStateNotificationType1"), object: nil)
        
    }
    
    // function to connect two players
    @IBAction func connectWithPlayer(_ sender: Any) {
        if appDelegate.mpcHandler.session != nil {
            appDelegate.mpcHandler.setupBrowser()
            appDelegate.mpcHandler.browser.delegate = self
            self.present(self.appDelegate.mpcHandler.browser, animated: true, completion: nil)
        }
    }
    
   @objc func peerChangedStateWithNotification(notification:NSNotification) {
        let userInfo = NSDictionary(dictionary: notification.userInfo!)
        let state = userInfo.object(forKey: "state") as! Int
        if state != MCSessionState.connected.rawValue {
            navBar.topItem?.title = "Connected"
            self.performSegue(withIdentifier: "startGame2PlayerSegue" , sender: AnyClass.self)
        }
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        appDelegate.mpcHandler.browser.dismiss(animated: true) {
            self.performSegue(withIdentifier: "startGame2PlayerSegue" , sender: AnyClass.self)
        }
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        appDelegate.mpcHandler.browser.dismiss(animated: true) {
            self.performSegue(withIdentifier: "startGame2PlayerSegue" , sender: AnyClass.self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startGame2PlayerSegue" {
            let vc: startTwoPlayerGameViewController = segue.destination as! startTwoPlayerGameViewController
            vc.appDelegate = self.appDelegate
        }
    }

}
