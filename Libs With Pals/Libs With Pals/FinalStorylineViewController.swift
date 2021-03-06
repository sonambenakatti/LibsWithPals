//
//  FinalStorylinePlayer.swift
//  Libs With Pals
//
//  Created by Sonam Benakatti on 3/28/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit
import CoreData

class FinalStorylineViewController: UIViewController {

    var storyline: Storyline? = nil
    var words: [String: Any?] = [:]
    var wordsOrdered = [String]()
    var finalStory: String = ""
    var name: String = ""
    let prefs: UserDefaults = UserDefaults.standard

    @IBOutlet weak var changeFontSizeSlider: UISlider!
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
        let saveLibs = prefs.bool(forKey: "saveLibs")
        print("value of saveLibs: \(saveLibs)")
        if (saveLibs) {
            self.saveMadLib()
        }
        performSegue(withIdentifier: "finalStorylineToHomeSegue", sender: AnyClass.self)

    }
    
    // Allow user to share their mad lib
    @IBAction func onShareButtonPressed(_ sender: Any) {
        let items = [finalStory];
        let activity = UIActivityViewController(activityItems: items, applicationActivities: nil);
        self.present(activity, animated: true, completion: nil)
    }
    
    // Allow user to change the font size of their story
    @IBAction func onChangeFontSizeSlide(_ sender: Any) {
        
        self.storylineTextView.font = UIFont.systemFont(ofSize: CGFloat(changeFontSizeSlider.value * 30.0))
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
