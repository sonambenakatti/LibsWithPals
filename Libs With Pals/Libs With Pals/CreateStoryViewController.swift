//
//  CreateStoryViewController.swift
//  Libs With Pals
//
//  Created by Gerlou Shyy on 4/1/18.
//  Copyright © 2018 Group8. All rights reserved.
//

// This class is used for when the user chooses sentences for 2 player mode
import UIKit

class CreateStoryViewController: UIViewController {
    
    // sentences that the player can choose from
    var one = ["It's finally the weekend, so ", " decides to hit up Target."]
    var two = [" goes to the ", " aisle to look for some ", "."]
    var three = [" needs to buy a birthday present for a friend, so ", " grabs a ", " from the shelf."]
    var four = ["Since it's ", " season, ", " decides to buy twenty boxes of ", " while they're on sale."]
    var five = [" is having a game night later on, so ", " goes to the game section and picks up ", " as well as some ", " to have for snacks."]
    var six = [" walks by the drinks aisle and picks up a bottle of ", ". "]
    var seven = [" sees a clearance sale sign and drops the ", " to buy ", "."]
    var eight = ["While driving to the store, ", " sees a ", " dancing on the street."]
    var nine = [" puts on a ", " before going to cook breakfast."]
    var ten = ["After shopping, ", " goes home to get ready to see a ", " at the theater with a friend."]
    
    
    var oneBlank = ["name"]
    var twoBlank = ["name", "noun", "noun"]
    var threeBlank = ["name", "pronoun", "noun"]
    var fourBlank = ["noun - holiday", "name", "noun"]
    var fiveBlank = ["name", "pronoun", "noun - game", "food"]
    var sixBlank = ["name", "noun - drink"]
    var sevenBlank = ["pronoun", "noun", "noun"]
    var eightBlank = ["name", "noun"]
    var nineBlank = ["pronoun", "noun - type of clothing"]
    var tenBlank = ["name", "noun"]

}
