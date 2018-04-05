//
//  FormViewController.swift
//  Libs With Pals
//
//  Created by Rethi, Jennifer L on 4/2/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit
import Eureka
import Foundation



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

// Class that controls the form used to collect user's input for each blank in the mad lib.
// Uses the Eureka framework in order to easily create a form.
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
        for (word, _) in self.userEnteredWords {
            // need to make sure that word is not identified as sentence and not other data sent over server
            if(word != "doneEnteringSentences"
                && word != "enterWordsClicked"
                && word != "chooseSentencesClicked"
                && word != "doneEnteringWords" && word.last != "2") {
                // get rid of identifier on word
                let val = String(word.suffix(word.count - 1))
                userWords.append(val)
            }
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
            print("In data recieved function")
            print(self.userEnteredWords)
            self.addRows()
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
}

