//
//  TwoPlayerCreateStoryViewController.swift
//  Libs With Pals
//
//  Created by Sonam Benakatti on 4/1/18.
//  Copyright © 2018 Group8. All rights reserved.
//

// For the ViewController that allows a player to create sentences for another player to fill words into

import UIKit



class TwoPlayerCreateStoryViewController: UIViewController, passEnteredWordsToPlayer2Delegate {
    
    var container: TwoPlayerWriteStorylineViewController?
    var words: Dictionary<String, Any?> = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TwoPlayerWriteStorylineFormSegue",
            let destination = segue.destination as? TwoPlayerWriteStorylineViewController {
            container = destination
            destination.delegate = self
        }
    }
    
    func passEnteredWords(words: Dictionary<String, Any?>) {
        self.words = words
    }
    
    // get the types of words inputted by player one
    func getTypesOfWords() -> Array<String>{
        var userWords: Array<String> = []
        // Start this index at 1 because the first element is always the name
        for (index, word) in self.words {
            let i = Int(index)
            // if an odd index, than the value in the dictionary is a type of word
            if i! % 2 != 0 {
                userWords.append(word as! String)
            }
        }
        return userWords
    }
    
    func checkUserInputtedAllNeededWords() {
        if (self.container?.checkIfAllRowsFilled())! {
            self.performSegue(withIdentifier: "ChooseWordsToFinalStorySegue", sender: AnyClass.self)
        } else {
            let alert = UIAlertController(title: "Looks like you missed some words!", message: "You must fill out all the fields.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // check that player one inputted all types
    @IBAction func onDoneButtonPressed(_ sender: Any) {
        checkUserInputtedAllNeededWords()
        var userWords = getTypesOfWords()
    }
    
    
    
}

