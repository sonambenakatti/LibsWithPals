//
//  SettingsViewController.swift
//  Libs With Pals
//
//  Created by Sonam Benakatti on 3/15/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit
import CoreData
import DKCamera

class SettingsViewController: UIViewController {
    
    let prefs: UserDefaults = UserDefaults.standard
    @IBOutlet weak var twoPlayerSwitch: UISwitch!
    @IBOutlet weak var saveLibsSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        // Ensure switches are set to what the user last set them to
        let twoPlayer = prefs.bool(forKey: "twoPlayer")
        let saveLibs = prefs.bool(forKey: "saveLibs")
        if (twoPlayer) {
            twoPlayerSwitch.setOn(true, animated: false)
        }
        if (saveLibs) {
            saveLibsSwitch.setOn(true, animated: false)
        }
        
        super.viewDidLoad()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Save the settings in UserDefaults
        // 1. One player or two player
        // 2. Save the libs you create or don't save
        prefs.set(twoPlayerSwitch.isOn, forKey: "twoPlayer")
        prefs.set(saveLibsSwitch.isOn, forKey: "saveLibs")
        prefs.synchronize()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onLogoutButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "logoutSegue", sender: AnyClass.self)
    }
    
    
    // Delete account button displays alert asking user if they are sure
    // if no: do nothing
    // if yes: delete account information
    @IBAction func onDeleteAccountButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Wait!", message: "Are you sure you want to delete your account?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
            self.deleteAccount()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    
    func deleteAccount() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"User")
        var fetchedResults:[NSManagedObject]
        request.predicate = NSPredicate(format: "email == %@", String(describing: prefs.value(forKey: "email")!))

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
        
        LoginViewController().logoutOfFacebook()
        self.performSegue(withIdentifier: "logoutSegue", sender: AnyClass.self)
    }
    
    // Adds a photo to a user's account
    @IBAction func onAddPhotoPressed(_ sender: Any) {
        let camera = DKCamera()
        
        camera.didCancel = {
            print("didCancel")
            self.dismiss(animated: true, completion: nil)
        }
        
        camera.didFinishCapturingImage = { (image: UIImage?, metadata: [AnyHashable : Any]?) in
            print("didFinishCapturingImage")
            self.dismiss(animated: true, completion: nil)
            self.addPhotoToUser(userImage: image!)
        }
        
        self.present(camera, animated: true, completion: nil)
    }
    
    // Add the photo in Core Data so that it may be used again
    func addPhotoToUser(userImage: UIImage) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"User")
        var fetchedResults:[NSManagedObject]? = nil
        request.predicate = NSPredicate(format: "email == %@", String(describing: prefs.value(forKey: "email")!))
        
        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }

        let user = fetchedResults![0]
        let imageData: NSData = UIImageJPEGRepresentation(userImage, 0.5)! as NSData

        user.setValue(imageData, forKey: "image")
        prefs.set(true, forKey: "hasImage")
        print("Added image to user account")
    }
    
    
}
