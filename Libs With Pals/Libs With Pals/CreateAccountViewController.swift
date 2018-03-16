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
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let user = NSEntityDescription.insertNewObject(
            forEntityName: "User", into: context)
        
        // Ensure user fields are not empty
        if(!self.validateInput()) {
            return
        }
        
        // Set the attribute values
        user.setValue(nameInput.text, forKey: "name")
        user.setValue(emailInput.text, forKey: "email")
        user.setValue(passwordInput.text, forKey: "password")
        
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
        
        self.performSegue(withIdentifier: "createAccountToHomeSegue", sender: AnyClass.self)

    }
    
    // Ensures user entered proper data when creating account (no empty fields)
    // TODO: validate that user email is the proper format (string@service.com)
    func validateInput() -> Bool {
        print(nameInput.text!)
        if (nameInput.text!.isEmpty) {
            createAlert(field: "Name")
            return false
        } else if (emailInput.text!.isEmpty) {
            createAlert(field: "Email")
            return false
        } else if (passwordInput.text!.isEmpty) {
            createAlert(field: "Password")
            return false
        }
        return true
    }
    
    // Alerts user what they entered is incorrect
    func createAlert(field: String) {
        // create the alert
        let alert = UIAlertController(title: "Invalid Input", message: field + " cannot be empty.", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
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
}
