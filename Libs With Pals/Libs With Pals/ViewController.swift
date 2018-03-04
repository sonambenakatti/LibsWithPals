//
//  ViewController.swift
//  Libs With Pals
//
//  Created by Sonam Benakatti on 2/24/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit

import FacebookLogin
import FBSDKLoginKit
import MultipeerConnectivity

class ViewController: UIViewController, MCBrowserViewControllerDelegate {
   
    var dict : [String : AnyObject]!
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        //creating button
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.center = view.center
        
        //adding it to view
        view.addSubview(loginButton)
        
        //if the user is already logged in
        if (FBSDKAccessToken.current()) != nil{
            getFBUserData()
        }
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.mpcHandler.setupPeerWithDisplayName(displayName: UIDevice.current.name)
        appDelegate.mpcHandler.setupSession()
        appDelegate.mpcHandler.advertiseSelf(advertise: true)
        
        NotificationCenter.default.addObserver(self, selector: Selector(("peerChangedStateWithNotificatoin")), name: NSNotification.Name(rawValue: "MPC_DidChangeStateNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: Selector(("handleRecieveDataWithNotification")), name: NSNotification.Name(rawValue: "MPC_DidRecieveDataNotification"), object: nil)
    }
    
    //when login button clicked
    func facebookButtonClicked(sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile], viewController : self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in")
            }
        }
    }

    //function is fetching the user data
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                }
            })
        }
    }
    
    // function to connect two players
    @IBAction func connectWithPlayer(_ sender: Any) {
        if appDelegate.mpcHandler.session != nil {
            appDelegate.mpcHandler.browser.delegate? = self
            
            self.present(appDelegate.mpcHandler.browser, animated: true, completion: nil)
            
        }
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        appDelegate.mpcHandler.browser.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        appDelegate.mpcHandler.browser.dismiss(animated: true, completion: nil)
    }
    
    
}
