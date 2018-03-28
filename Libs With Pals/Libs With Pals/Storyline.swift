//
//  Storyline.swift
//  Libs With Pals
//
//  Created by Sonam Benakatti on 3/27/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import Foundation

class Storyline {
    
    var story = Array<String>()
    var blanks = Array<String>()
    
    // TODO: Don't allow the user to enter a name or pronoun more than one time
    
    let groceryStory = ["It’s Saturday night and ", "has no ", "in ", " fridge. So clearly, it’s time for a trip to the store. ", "gets in ",    "and drives to the local grocery store wearing nothing but a ",   ". ", "On",  "way in, the ",  "store manager greets ",  ", looking a little ", " due to ", "'s attire. ", " realizes ", " completely forgot what ", " originally came for! So instead, ", " heads to the aisle with the ", ".", " picks up seventeen ", " and heads to check out. ", " realizes ", " forgot their wallet at ", ", so ", " drops their items and heads to ", "*"]
    
    let groceryBlanks = ["name", "noun", "pronoun", "name", "possesive-pronoun", "noun", "noun - article of clothing", "pronoun", "adjective", "name", "noun - emotion", "name", "name", "pronoun", "pronoun", "pronoun", "noun", "name", "noun - plural", "name", "pronoun", "noun - place", "pronoun", "adverb"]
    
    let morningStory = [" woke up early this morning. ", " went to the bathroom ", " and brushed ", " teeth ", ". After that, ", " went downstairs to cook ", " for breakfast. While ", " was cooking, ", " spilled all over ", " and ", " shouted, 'Oh no!' ", " went upstairs to clean up and unexpectedly found ", " at the top of the stairs. This was turning out to be a really eye opening day."]

    let morningBlanks = ["name", "pronoun", "adverb", "possessive-pronoun", "adverb", "name", "noun", "pronoun", "name", "pronoun", "pronoun", "noun"]

    
    var name: String = ""
    var pronoun: String = ""
    var storyName: String = ""

    //userInputedWords stores the words that the user enters
    var userInputedWords: Array<String> = []
    
    init(storyline: String) {
        if storyline == "Trip to the Grocery Store" {
            self.story = groceryStory
            self.blanks = groceryBlanks
            self.storyName = storyline
        }
    }

        func getStory() -> Array<String> {
        return self.story
    }
    
    func getBlanks() -> Array<String> {
        return self.blanks
    }
    
    func getStoryName() -> String {
        return self.storyName
    }
}
