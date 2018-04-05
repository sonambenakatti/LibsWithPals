//
//  FormViewController.swift
//  Libs With Pals
//
//  Created by Sonam Benakatti on 3/27/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit
import Eureka
import Foundation

// Class that controls the form used to collect user's input for each blank in the mad lib.
// Uses the Eureka framework in order to easily create a form.

//struct Message: Codable {
//    var actionDict: [String:Bool]
//    var enteredWords: [String]
//    
//    init(actionDict: Dictionary<String, Bool>, enteredWords: Array<String>) {
//        self.actionDict = actionDict
//        self.enteredWords = enteredWords
//    }
//    
//    enum CodingKeys: String, CodingKey {
//        case actionDict = "actionDict"
//        case enteredWords = "enteredWords"
//    }
//    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self) // defining our (keyed) container
//        let actionDict: Dictionary<String, Bool> = try container.decode(Dictionary<String, Bool>.self, forKey: .actionDict) // extracting the data
//        let enteredWords: Array<String> = try container.decode(Array<String>.self, forKey: .enteredWords) // extracting the data
//        self.init(actionDict: actionDict, enteredWords: enteredWords) // initializing our struct
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(self.actionDict, forKey: .actionDict)
//        try container.encode(self.enteredWords, forKey: .enteredWords)
//    }
//}


class TwoPlayerWordsFormViewController: FormViewController {
    
    //var storyline: Storyline? = nil
    var delegate: TwoPlayerChooseWordsViewController?
    var name: String = ""
    var userEnteredWords: [String:Bool] = [:]
    var words: [String: Any?] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleRecieveDataWithNotification(notification:)) , name: NSNotification.Name(rawValue: "MPC_DidRecieveDataNotification"), object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // get the types of words inputed by player one
    func getTypesOfWords() -> Array<String>{
        var userWords: Array<String> = []
        for (word, bool) in self.userEnteredWords {
            userWords.append(word)
        }
        print(userWords)
        return userWords
    }
    
    // Add the needed rows for the user to input words
    func addRows() {
        
        let blanks = getTypesOfWords()
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
        print("Words recieved over server")
        let userInfo = notification.userInfo! as Dictionary
        let recievedData:Data = userInfo["data"] as! Data
        do {
            let message = try JSONSerialization.jsonObject(with: recievedData, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary<String, Bool>
            self.userEnteredWords = message
            self.addRows()
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
}

