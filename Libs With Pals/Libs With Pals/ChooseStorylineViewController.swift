//
//  ChooseStorylineThemeViewController.swift
//  Libs With Pals
//
//  Created by Sonam Benakatti on 3/17/18.
//  Copyright © 2018 Group8. All rights reserved.
//

// When the game is in single player mode, the player chooses a storyline theme

import UIKit

public let storylines = ["Trip to the Grocery Store"]

class ChooseStorylineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var storylineTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storylineTableView.delegate = self
        storylineTableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storylines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "storylineCell", for: indexPath as IndexPath)
        let row = indexPath.row
        cell.textLabel?.text = storylines[row]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "goToChooseWordsSegue",
            let destination = segue.destination as? ChooseWordsViewController,
            let storyIndex = storylineTableView.indexPathForSelectedRow?.row
        {
            destination.storyline = Storyline(storyline: storylines[storyIndex])
        }
    }

    
    @IBAction func onHomePressed(_ sender: Any) {
        self.performSegue(withIdentifier: "storylineThemeToHomeSegue", sender: AnyClass.self)
    }
}

