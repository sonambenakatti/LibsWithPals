//
//  ViewController.swift
//  Libs With Pals
//
//  Created by Sonam Benakatti on 2/24/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit
import CoreData

import FacebookLogin
import FBSDKLoginKit
import MultipeerConnectivity

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
   
    var dict: [String: AnyObject]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if the user is already logged in
//        if (FBSDKAccessToken.current()) != nil {
//            self.getFBUserData()
//        }
    }
    
    // Login manually with a name, email, password
    @IBAction func onLoginButtonPressed(_ sender: Any) {
        if(retrieveUserIfExists(email: emailText.text!, password: passwordText.text!)) {
            performSegue(withIdentifier: "loginToHomeSegue", sender: AnyClass.self)
        } else {
            self.alertInvalidInput(message: "No user with the email " + emailText.text! + " found.")
        }
    }
    
    // Verify that user exists
    func retrieveUserIfExists(email: String, password: String) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
    
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"User")
        var fetchedResults:[NSManagedObject]? = nil
        request.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    
        // Email does not exist
        if(fetchedResults?.isEmpty)! {
            return false
        }
        
        // Only need to check the first element in list because there should not be mulitple users with the same email address
        let user = fetchedResults![0]
        return verifyPasswordMatch(password: password, user: user)
    }
    
    // Alert the user when their input is not valid
    func alertInvalidInput(message: String) {
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Verify the password matches the email
    func verifyPasswordMatch(password: String, user: NSManagedObject) -> Bool {
        if(String(describing: user.value(forKey: "password")!) != password) {
            self.alertInvalidInput(message: "Incorrect password.")
            return false
        }
        self.saveUserName(user: user)
        return true
    }
    
    // Save the user's name so that it can be used throughout the app
    func saveUserName(user: NSManagedObject) {
        let prefs: UserDefaults = UserDefaults.standard
        prefs.set(user.value(forKey: "name"), forKey: "name")
        prefs.synchronize()
    }
    
    // Login with Facebook
    @IBAction func onFacebookLoginButtonPressed(_ sender: Any) {
        self.facebookButtonClicked()
    }
    
    // Create a new account
    @IBAction func onNewAccountButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "createAccountSegue", sender: AnyClass.self)

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Called when the user touches on the main view (outside the UITextField).
    //
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    // When Facebook login button is clicked
    // NOTE: When FB login is used, the returned id is used in place of a traditional password
    func facebookButtonClicked() {
        if (FBSDKAccessToken.current()) == nil {
            let loginManager = LoginManager()
            loginManager.logIn(readPermissions: [.publicProfile, .email], viewController : self) { loginResult in
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
        } else {
            self.getFBUserData()
        }
    }

    // Fetch user data
    func getFBUserData() {
        if((FBSDKAccessToken.current()) != nil) {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil) {
                    self.dict = result as! [String : AnyObject]
                    print(self.dict)
                    
                    let name = self.dict["name"] as! String
                    let email = self.dict["email"] as! String
                    let password = self.dict["id"] as! String
                    
                    if(self.retrieveUserIfExists(email: self.dict["email"] as! String, password: self.dict["id"] as! String)) {
                        self.performSegue(withIdentifier: "loginToHomeSegue", sender: AnyClass.self)
                    } else {
                        CreateAccountViewController().saveUserData(name: name, email: email, password: password)
                        self.performSegue(withIdentifier: "loginToHomeSegue", sender: AnyClass.self)
                    }
                }
            })
        }
    }

}
