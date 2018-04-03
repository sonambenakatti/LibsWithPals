//
//  FormViewController.swift
//  Libs With Pals
//
//  Created by Sonam Benakatti on 3/27/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit
import Eureka

// Class that controls the form used to collect user's input for each blank in the mad lib.
// Uses the Eureka framework in order to easily create a form.

struct Message {
    var actionDict: [String:Bool] = [:]
    var enteredWords: [String]
}

class WordsFormViewControllerPlayer2: FormViewController {
    
    var storyline: Storyline? = nil
    var delegate: ChooseWordsPlayer2ViewController?
    var words: [String: Any?] = [:]
    var name: String = ""
    var userEnteredWords: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleRecieveDataWithNotification(notification:)) , name: NSNotification.Name(rawValue: "MPC_DidRecieveDataNotification"), object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Add the needed rows for the user to input words
    func addRows() {
        
        let blanks = userEnteredWords
        var index = 0
        var nameRowCreated = false
        
        form +++ Section()
        for blank in blanks {
            if blank == "name" {
                if nameRowCreated {
                    continue
                } else {
                    nameRowCreated = true
                }
            }
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
            index += 1
        }
    }
    
    // Ensure that the player inputted a word for every blank
    func checkIfAllRowsFilled() -> Bool {
        let valuesDictionary = form.values()
        for val in valuesDictionary {
            if val.value == nil {
                return false
            } else if val.key == "0" {
                name = val.value as! String
            }
        }
        words = valuesDictionary
        return true
    }
    
    // function to handle the recieved data between players
    @objc func handleRecieveDataWithNotification(notification:NSNotification){
        let userInfo = notification.userInfo! as Dictionary
        let recievedData:Data = userInfo["data"] as! Data
        do {
            let message = try JSONSerialization.jsonObject(with: recievedData, options: JSONSerialization.ReadingOptions.allowFragments) as! Message
            if message.enteredWords.count > 0 {
                userEnteredWords = message.enteredWords
                self.addRows()
            }
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
}

