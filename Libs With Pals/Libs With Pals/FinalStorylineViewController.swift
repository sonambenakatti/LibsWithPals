//
//  FinalStorylineViewController.swift
//  Libs With Pals
//
//  Created by Sonam Benakatti on 3/28/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit

class FinalStorylineViewController: UIViewController {

    var storyline: Storyline? = nil
    var words: [String: Any?] = [:]
    var wordsOrdered = [String]()
    var finalStory: String = ""
    var name: String = ""
    
    @IBOutlet weak var storylineTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.putWordsInOrder()
        self.showStory()
        storylineTextView.isEditable = false
        storylineTextView.text = finalStory
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Ensure the words are in order because words is a dictionary and therefore order is not guaranteed
    func putWordsInOrder() {
        for i in 0...words.count - 1 {
            wordsOrdered.append(words[String(i)]!! as! String)
        }
        print(wordsOrdered)
    }
    
    // Loop through each element in the story
    // Alternate between a component of the story and a user inputted word
    func showStory() {
        // Start this index at 1 because the first element is always the name
        var wordsOrderedIndex = 1
        for i in 0...storyline!.getStory().count - 1 {
            finalStory += storyline!.getStory()[i]
            if storyline!.getBlanks().indices.contains(i) {
                if((storyline?.getBlanks()[i])! == "name") {
                    finalStory += name
                } else {
                    finalStory += wordsOrdered[wordsOrderedIndex]
                    wordsOrderedIndex += 1
                }
            }
        }
        print(finalStory)
    }
    
    @IBAction func onHomeButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "finalStorylineToHomeSegue", sender: AnyClass.self)
    }
    
}
