//
//  FinalStorylinePlayer2ViewController.swift
//  Libs With Pals
//
//  Created by Rethi, Jennifer L on 4/2/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit
import CoreData

class TwoPlayerFinalStorylineViewController: UIViewController {
    
    var message: Dictionary<String, Bool> = [:]
    var sentences: [String] = []
    var words: [String] = []
    var passedWords: Dictionary<String, Any?> = [:]
    var finalStory: String = ""
    var name: String = ""
    let prefs: UserDefaults = UserDefaults.standard
    
    @IBOutlet weak var storylineTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storylineTextView.isEditable = false
        if message.count > 0 {
            getTypesOfWords()
        } else {
            putPassedWordsInOrder()
        }
        combineWordsAndSentences()
        storylineTextView.text = finalStory
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // get the types of words inputed by player one
    func getTypesOfWords() {
        var ordered: Dictionary<Int, String> = [:]
        for (word, _) in self.message {
            // need to make sure that word is not identified as sentence and not other data sent over server
            if(word != "doneEnteringSentences"
                && word != "enterWordsClicked"
                && word != "chooseSentencesClicked"
                && word != "doneEnteringWords"
                && word != "connected"
                && word != "responding"
                && word != "doneResponding") {
                // get rid of identifier on word
                var newWord = word
                let lastChar = newWord.removeLast()
                let val = Int(String(lastChar))
                ordered[val!] = newWord
            }
        }
        // Ensure the words are in order because words is a dictionary and therefore order is not guaranteed
        for i in 0...ordered.count - 1 {
            words.append(ordered[i]!)
        }
    }
    
    func putPassedWordsInOrder() {
        for i in 0...passedWords.count - 1 {
            words.append(passedWords[String(i)]! as! String)
        }
    }
    
    func combineWordsAndSentences() {
        var sentencesIndex = 0
        for wordsIndex in 0...words.count - 1 {
            finalStory += sentences[sentencesIndex]
            finalStory += " "
            finalStory += words[wordsIndex]
            finalStory += " "
            sentencesIndex = sentencesIndex + 1
        }
    }
    
    @IBAction func onHomeButtonPressed(_ sender: Any) {
        let saveLibs = prefs.bool(forKey: "saveLibs")
        print("value of saveLibs: \(saveLibs)")
        if (saveLibs) {
            self.saveMadLib()
        }
        performSegue(withIdentifier: "TwoPlayerFinalStorylineToHomeSegue", sender: AnyClass.self)
        
    }
    
    // Save the mad lib into core data if the user has the setting enabled
    func saveMadLib() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let lib = NSEntityDescription.insertNewObject(
            forEntityName: "MadLib", into: context)
        
        lib.setValue(finalStory, forKey: "story")
        
        // Commit the changes
        do {
            try context.save()
            NSLog("Saved story into core data")
        } catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
    }

}

