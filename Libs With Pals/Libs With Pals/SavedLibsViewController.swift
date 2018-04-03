//
//  SavedLibsViewController.swift
//  Libs With Pals
//
//  Created by Sonam Benakatti on 4/2/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit
import CoreData

class SavedLibsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var madLibs = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadStories()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return madLibs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storyCell", for: indexPath as IndexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = "Story \(row)"
        cell.detailTextLabel?.text = madLibs[row]

        return cell

    }
    
    // load stories from CoreData so that they can be displayed in the table
    func loadStories() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MadLib")
        var fetchedResults:[NSManagedObject]

        do {
            try fetchedResults = context.fetch(request) as! [NSManagedObject]
            if fetchedResults.count > 0 {
                for result in fetchedResults {
                    madLibs.append(result.value(forKey: "story")! as! String)
                    print(result.value(forKey: "story")!)
                }
            }
        } catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        self.tableView.reloadData()
    }
    
    @IBAction func onHomeButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "savedLibsToHomeSegue", sender: AnyClass.self)

    }
}
