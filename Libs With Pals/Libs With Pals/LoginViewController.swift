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

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
   
    var dict : [String : AnyObject]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if the user is already logged in
        if (FBSDKAccessToken.current()) != nil{
            getFBUserData()
        }
    }
    
    // Login manually with a name, email, password
    @IBAction func onLoginButtonPressed(_ sender: Any) {
    }
    
    // Login with Facebook
    @IBAction func onFacebookLoginButtonPressed(_ sender: Any) {
        self.facebookButtonClicked()
    }
    
    // Create a new account
    @IBAction func onNewAccountButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "createAccountSegue", sender: AnyClass.self)

    }
    
    // When Facebook login button is clicked
    func facebookButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile], viewController : self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in")
                self.getFBUserData()
            }
        }
    }

    // Fetch user data
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                } else {
                    print(result!)
                }
            })
        }
    }

}
