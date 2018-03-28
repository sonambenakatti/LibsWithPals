//
//  FormViewController.swift
//  Libs With Pals
//
//  Created by Sonam Benakatti on 3/27/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit
import Eureka

class WordsFormViewController: FormViewController {
    
    var storyline: Storyline? = nil
    var delegate: ChooseWordsViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addRows()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addRows() {
        
        let storyName = storyline!.getStoryName()
        let _ = storyline!.getStory()
        let blanks = storyline!.getBlanks()
        var index = 0
        
        form +++ Section(storyName)
        for blank in blanks {
            form.last!
                <<< AccountRow("\(index)") { row in
                    row.title = blank
                    row.add(rule: RuleRequired(msg: "You must fill in all the blanks!"))
                    row.validationOptions = .validatesOnChange
                    //row.placeholder = "Enter text here"
            } .cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .red
                        }
            }
            index += 1
        }
        let row: TextRow? = form.rowBy(tag: "hey")
        let value = row?.value
        print(String(describing: value))
    }
    
    func checkIfAllRowsFilled() -> Bool {
        let valuesDictionary = form.values()
        for val in valuesDictionary {
            if valuesDictionary.index(forKey: String(describing: val)) == nil {
                return false
            }
        }
        print(valuesDictionary)
        return true

    }
}
