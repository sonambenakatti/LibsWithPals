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
import CoreData

// class to set up connection between 2 players
class TwoPlayerConnectPlayerViewController: UIViewController, MCBrowserViewControllerDelegate {
    
    let prefs: UserDefaults = UserDefaults.standard
    @IBOutlet weak var personImage: UIImageView!
    
    @IBOutlet weak var navBar: UINavigationBar!
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.mpcHandler.setupPeerWithDisplayName(displayName: UIDevice.current.name)
        appDelegate.mpcHandler.setupSession()
        appDelegate.mpcHandler.advertiseSelf(advertise: true)
        
        // add observer to be notified when connection state has been changed
        NotificationCenter.default.addObserver(self, selector: #selector(peerChangedStateWithNotification(notification:)), name: NSNotification.Name(rawValue: "MPC_DidChangeStateNotification"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getPlayerPhotoIfExists()
    }
    
    // Place player's profile picture if they have one
    func getPlayerPhotoIfExists() {
        
        if((prefs.bool(forKey: "hasImage"))) {
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
            
            if((fetchedResults?.count)! > 0) {
                let user = fetchedResults![0]
                
                print(user)
                
                if let imageData = user.value(forKey: "image") as? NSData {
                    if let image = UIImage(data:imageData as Data)  {
                        personImage.image = image
                    }
                }
            }
        }
    }
    
    // function to setup connection
    @IBAction func connectWithPlayer(_ sender: Any) {
        if appDelegate.mpcHandler.session != nil {
            appDelegate.mpcHandler.setupBrowser()
            appDelegate.mpcHandler.browser.delegate = self
            self.present(self.appDelegate.mpcHandler.browser, animated: true, completion: nil)
        }
    }
    
   // When peer has been connected, change title of nav bar to connected
   @objc func peerChangedStateWithNotification(notification:NSNotification) {
        let userInfo = NSDictionary(dictionary: notification.userInfo!)
        let state = userInfo.object(forKey: "state") as! Int
        if state == MCSessionState.connected.rawValue {
            self.performSegue(withIdentifier: "TwoPlayerStartGameSegue" , sender: AnyClass.self)
        }
    }
    
    // function to handle when the browser is finished
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        appDelegate.mpcHandler.browser.dismiss(animated: true) {
            self.performSegue(withIdentifier: "TwoPlayerStartGameSegue" , sender: AnyClass.self)
        }
    }
    
    // function to handle when browser has been cancelled
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        appDelegate.mpcHandler.browser.dismiss(animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TwoPlayerStartGameSegue" {
            let vc: TwoPlayerStartGameViewController = segue.destination as! TwoPlayerStartGameViewController
            vc.appDelegate = self.appDelegate
        }
    }

}
