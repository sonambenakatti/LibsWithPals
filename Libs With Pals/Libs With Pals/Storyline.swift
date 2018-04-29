//
//  Storyline.swift
//  Libs With Pals
//
//  Created by Sonam Benakatti on 3/27/18.
//  Copyright © 2018 Group8. All rights reserved.
//

// This class contains the storylines for one player mode and the blanks needed to complete the mad lib
// NOTE: In each story, the first blank MUST be name!

import Foundation

class Storyline {
    
    var story = Array<String>()
    var blanks = Array<String>()
    
    // TODO: Don't allow the user to enter a pronoun more than one time
    
    let groceryStory = ["It’s Saturday night and ", " has no ", " in ", " fridge. So clearly, it’s time for a trip to the store. ", " gets in ", " ", " and drives to the local grocery store wearing nothing but a ",   ". On ",  " way in, the ",  " store manager greets ",  ", looking a little ", " due to ", "'s attire. ", " realizes ", " completely forgot what ", " originally came for! So instead, ", " heads to the aisle with the ", ". ", " picks up seventeen ", " and heads to check out. ", " realizes ", " forgot their wallet at ", ", so ", " drops their items and heads to ", "."]
    
    let groceryBlanks = ["name", "noun", "possessive-pronoun", "name", "possessive-pronoun", "noun", "noun - article of clothing", "possessive-pronoun", "adjective", "name", "noun - emotion", "name", "name", "pronoun", "pronoun", "pronoun", "noun", "name", "noun - plural", "name", "pronoun", "noun - place", "pronoun", "adverb"]
    
    let morningStory = ["After a full 8 hours of sleep, ", " woke up early this morning. ", " went to the bathroom ", " and brushed ", " teeth ", ". After that, ", " went downstairs to cook ", " for breakfast. While ", " was cooking, ", " spilled all over ", " and ", " shouted, 'Oh no!' ", " went upstairs to clean up and unexpectedly found a ", " at the top of the stairs. This was turning out to be a really eye opening day."]

    let morningBlanks = ["name", "pronoun", "adverb", "possessive-pronoun", "adverb", "name", "noun", "pronoun", "noun", "name", "pronoun", "pronoun", "noun"]

    
    let examStory = ["The alarm rings and ", " crawls out of bed. ", " goes to ", " and gets ready for the day. ", " has a ", " midterm and quickly grabs ", " from the desk. ", " makes a ", " for lunch before heading out to the ", ". ", " walks to campus and then realizes ", " forgot to bring a ", ", but it's too late to go back home to get it. While ", " is walking, ", " gets a call from the ", " department that the ", " ran away. This was not how the day was supposed to turn out."]
    
    let examBlanks = ["name", "pronoun", "place", "name", "noun - subject", "noun", "pronoun", "food", "noun", "name", "pronoun", "noun", "name", "pronoun", "noun", "noun - animal"]
    
    let travelStory = ["Excited for a trip to Europe, ", " headed to the airport after lunch. ", " was going to ", " for the first time. ", " checked in the luggage and went to look at some ", " at the airport store. Then, ", " went to get some ", " at the food court. However, there were a lot of people in line, so it took a while to get the food. When ", " finished eating, it was almost time to board, so ", " quickly ", " to the gate, but since ", " was taking ", " Airlines, the gate was far from where ", " was. ", " almost fell over a ", " but made it on time."]
    
    let travelBlanks = ["name", "pronoun", "noun - place in Europe", "pronoun", "noun - plural", "pronoun", "noun - food", "pronoun", "name", "verb", "name", "noun", "pronoun", "pronoun", "noun - item"]
    
    let lunchStory = ["It's lunch now, and ", " decides to get ", " with friends. ", " likes to eat ", " but wants to save money and can't cook. ", " decides to ", " to the restaurant. Once ", " is there, ", " orders a ", " and decides to drink some ", ". While waiting for the food, ", " talks to ", " friends about ", ". The waiter finally arrives, and accidentally brings ", " the wrong dish. Luckily, ", " gets to keep the extra dish and brings it back to ", "."]
    
    let lunchBlanks = ["name", "food", "pronoun", "food", "name", "verb - present tense", "pronoun", "name", "food", "drink", "pronoun", "possessive pronoun", "noun", "name", "pronoun", "place"]
    
    var name: String = ""
    var pronoun: String = ""
    var storyName: String = ""

    //userInputedWords stores the words that the user enters
    var userInputedWords: Array<String> = []
    
    init(storyline: String) {
        self.storyName = storyline
        switch storyline {
            case "Trip to the Grocery Store":
                self.story = groceryStory
                self.blanks = groceryBlanks
            case "An Eventful Morning":
                self.story = morningStory
                self.blanks = morningBlanks
            case "Exam Day":
                self.story = examStory
                self.blanks = examBlanks
            case "A Travel Adventure":
                self.story = travelStory
                self.blanks = travelBlanks
            case "Lunch Time":
                self.story = lunchStory
                self.blanks = lunchBlanks
            default:
                // Default to the grocery story for now, although this case should never be reached
                self.story = groceryStory
                self.blanks = groceryBlanks
        }
    }

        func getStory() -> Array<String> {
        return self.story
    }
    
    // Returns the blanks in the story (ex. adjective, verb, name, etc.)
    func getBlanks() -> Array<String> {
        return self.blanks
    }
    
    // Returns the name of the story
    func getStoryName() -> String {
        return self.storyName
    }
}
