//
//  CreateAccountViewController.swift
//  Libs With Pals
//
//  Created by Sonam Benakatti on 3/15/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit
import CoreData

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the line below only if you want to erase all user data
        // clearCoreData()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Store the user info
    // TODO: implement a "forgot password" button
    @IBAction func onCreateAccountPressed(_ sender: Any) {
        
        // Ensure user fields are not empty
        if(!self.validateInput()) {
            return
        }
        self.saveUserData(name: nameInput.text!, email: emailInput.text!, password: passwordInput.text!)
        self.performSegue(withIdentifier: "createAccountToHomeSegue", sender: AnyClass.self)
        
    }
    
    // Save the user's data into CoreData
    func saveUserData(name: String, email: String, password: String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let user = NSEntityDescription.insertNewObject(
            forEntityName: "User", into: context)
        
        // Set the attribute values
        user.setValue(name, forKey: "name")
        user.setValue(email, forKey: "email")
        user.setValue(password, forKey: "password")
        
        LoginViewController().saveUserName(user: user)
        
        // Commit the changes
        do {
            try context.save()
            NSLog("Saved new User")
        } catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
    
    // Ensures user entered proper data when creating account (no empty fields)
    // TODO: validate that user email is the proper format (string@service.com)
    func validateInput() -> Bool {
        print(nameInput.text!)
        if (nameInput.text!.isEmpty) {
            createAlert(message: "Name cannot be empty.")
            return false
        } else if (emailInput.text!.isEmpty) {
            createAlert(message: "Email cannot be empty.")
            return false
        } else if (passwordInput.text!.isEmpty) {
            createAlert(message: "Password cannot be empty.")
            return false
        }
        
        return ensureEmailDoesNotExist(email: emailInput.text!)
    }
    
    // Makes sure user does not already have an account with their email
    func ensureEmailDoesNotExist(email: String) -> Bool {
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
        
        if((fetchedResults?.isEmpty)! == false) {
            createAlert(message: "An account with this email already exists.")
            return false
        }
        
        return true
    }
    
    // Alerts user what they entered is incorrect
    func createAlert(message: String) {
        let alert = UIAlertController(title: "Invalid Input", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Clear all user data (names, emails, and passwords)
    func clearCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        var fetchedResults:[NSManagedObject]
        
        do {
            try fetchedResults = context.fetch(request) as! [NSManagedObject]
            if fetchedResults.count > 0 {
                
                for result:AnyObject in fetchedResults {
                    context.delete(result as! NSManagedObject)
                    print("\(result.value(forKey: "name")!) has been Deleted")
                }
            }
            try context.save()
        } catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
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
}

