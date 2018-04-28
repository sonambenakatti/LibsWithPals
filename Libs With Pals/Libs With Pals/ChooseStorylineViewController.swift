//
//  ChooseStorylineThemeViewController.swift
//  Libs With Pals
//
//  Created by Sonam Benakatti on 3/17/18.
//  Copyright © 2018 Group8. All rights reserved.
//

// This class is used for when the game is in single player mode and the player chooses a storyline theme

import UIKit

// If you update these, you must also update Storyline.swift's constructor
public let storylines = ["Trip to the Grocery Store", "An Eventful Morning", "Exam Day", "A Travel Adventure", "Lunch Time"]

class ChooseStorylineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var storylineTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storylineTableView.delegate = self
        storylineTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    // Prepare to go to the form in which user inputs words for blanks in the mad lib
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "goToChooseWordsSegue",
            let destination = segue.destination as? ChooseWordsViewController,
            let storyIndex = storylineTableView.indexPathForSelectedRow?.row
        {
            destination.storyline = Storyline(storyline: storylines[storyIndex])
        }
    }

    // Return back to home screen
    @IBAction func onHomePressed(_ sender: Any) {
        self.performSegue(withIdentifier: "storylineThemeToHomeSegue", sender: AnyClass.self)
    }
    
    func animateTable() {
        storylineTableView.reloadData()
        let cells = storylineTableView.visibleCells
        
        let tableViewHeight = storylineTableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1.75, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }

}

