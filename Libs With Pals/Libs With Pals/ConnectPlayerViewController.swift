//
//  ConnectPlayerViewController.swift
//  Libs With Pals
//
//  Created by Rethi, Jennifer L on 3/4/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ConnectPlayerViewController: UIViewController, MCBrowserViewControllerDelegate {
    
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.mpcHandler.setupPeerWithDisplayName(displayName: UIDevice.current.name)
        appDelegate.mpcHandler.setupSession()
        appDelegate.mpcHandler.advertiseSelf(advertise: true)
        
        //NotificationCenter.default.addObserver(self, selector: Selector(("peerChangedStateWithNotification")), name: NSNotification.Name(rawValue: "MPC_DidChangeStateNotification"), object: nil)
        
        //NotificationCenter.default.addObserver(self, selector: Selector(("handleRecieveDataWithNotification")), name: NSNotification.Name(rawValue: "MPC_DidRecieveDataNotification"), object: nil)
    }
    
    // function to connect two players
    @IBAction func connectWithPlayer(_ sender: Any) {
        if appDelegate.mpcHandler.session != nil {
            appDelegate.mpcHandler.setupBrowser()
            appDelegate.mpcHandler.browser.delegate = self
            self.present(appDelegate.mpcHandler.browser, animated: true, completion: nil)
        }
    }
    
    func peerChangedStateWithNotification(notification:NSNotification) {
        let userInfo = NSDictionary(dictionary: notification.userInfo!)
        let state = userInfo.object(forKey: "state") as! Int
        
        if state != MCSessionState.connecting.rawValue {
            
        }
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        print("here")
        appDelegate.mpcHandler.browser.dismiss(animated: true)

    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        appDelegate.mpcHandler.browser.dismiss(animated: true)

    }
    
    // this function will be implemented later when data is passed between players
    func handleRecieveDataWithNotification(notification:NSNotification) {
        
    }

}
