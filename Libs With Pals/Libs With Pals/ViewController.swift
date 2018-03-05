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

class ViewController: UIViewController {
   
    var dict : [String : AnyObject]!

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

}
