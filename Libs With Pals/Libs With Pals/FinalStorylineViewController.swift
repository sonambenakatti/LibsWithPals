//
//  FinalStorylineViewController.swift
//  Libs With Pals
//
//  Created by Sonam Benakatti on 3/28/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit

class FinalStorylineViewController: UIViewController {

    var storyline: Array<String>?
    var words: [String: Any?] = [:]
    var wordsOrdered = [String]()
    var finalStory: String = ""
    
    @IBOutlet weak var storylineTextView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.putWordsInOrder()
        self.showStory()
        storylineTextView.text = finalStory
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func putWordsInOrder() {
        for i in 0...words.count - 1 {
            wordsOrdered.append(words[String(i)]!! as! String)
        }
        print(wordsOrdered)
    }
    
    func showStory() {
        for i in 0...storyline!.count - 1 {
            finalStory += storyline![i]
            if wordsOrdered.indices.contains(i) {
                finalStory += wordsOrdered[i]
            }
        }
        print(finalStory)
    }
}
