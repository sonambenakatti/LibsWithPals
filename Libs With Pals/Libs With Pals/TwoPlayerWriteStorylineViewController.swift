//
//  TwoPlayerWriteStorylineViewController.swift
//  Libs With Pals
//
//  Created by Sonam Benakatti on 4/1/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit
import Eureka

// The container with a form to fill out a story, contained inside TwoPlayerCreateStoryViewController

class TwoPlayerWriteStorylineViewController: FormViewController {

    var words: [String: Any?] = [:]
    var delegate: TwoPlayerCreateStoryViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addRows()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Add the needed rows for the user to input words
    func addRows() {
            
        form +++ Section()
        for index in 0...9 {
            var blank = ""
            if(index % 2 == 0) {
                blank = "Sentence"
            } else {
                blank = "Type of Word"
            }
            print("Adding a row for index: \(index)")
            form.last!
                <<< AccountRow("\(index)") { row in
                    row.title = blank
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                    //row.placeholder = "Enter text here"
                    } .cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .red
                        }
            }
        }
    }
    
    // Ensure that the player inputted a word for every blank
    func checkIfAllRowsFilled() -> Bool {
        let valuesDictionary = form.values()
        for val in valuesDictionary {
            if val.value == nil {
                return false
            }
        }
        words = valuesDictionary
        return true
        
    }
}

