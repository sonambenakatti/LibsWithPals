//
//  HowToPlayViewController.swift
//  Libs With Pals
//
//  Created by Sonam Benakatti on 4/15/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit

class HowToPlayViewController: UIViewController {
    
    let hand = UIImageView(image: UIImage(named: "finger"))
    @IBOutlet weak var howToPlayImage: UIImageView!
    
    @IBOutlet weak var instructionsText: UITextView!
    // List of instructions to display
    let text = ["One Player",
                "Choose an option from the storyline library",
                "Input words according to the given type",
                "Input words according to the given type",
                "View your completed storyline!",
                
                "Two Player",
                "Connect with another player",
                "Player one chooses sentences",
                "Player two chooses words",
                "View your completed storyline!"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instructionsText.centerVertically()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        addHandToScreen()
        fadeTextIn(val: 0)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func addHandToScreen() {
        // Set the hand image to its starting position
        let screenSize: CGRect = UIScreen.main.bounds
        self.hand.frame = CGRect(x: screenSize.width / 1.8, y: screenSize.height / 1.4, width: self.hand.frame.width / 2, height: self.hand.frame.height / 2)
        self.view.addSubview(self.hand)
    }

    // Reset the hand back to the original position so that it doesn't go off screen
    func resetHand() {
        self.hand.isHidden = true
        let screenSize: CGRect = UIScreen.main.bounds
        self.hand.frame.origin.x = screenSize.width / 1.8
        self.hand.frame.origin.y = screenSize.height / 1.4
    }
    
    // Animate the hand clicking on a storyline
    func handClick() {
        UIView.animate(
            withDuration: 3.0,
            animations: {
                self.hand.center.x -= 50;
                self.hand.center.y -= 45;
            }
        )
    }
    
    // Animates the text changing
    func fadeTextIn(val: Int) {
        let length = self.text.endIndex
        let curVal = val % length
        
        // Change the images depending on the current text
        // Images are white, which is why you may not be able to see them below
        switch curVal {
            case 0:
                hand.isHidden = true
            case 1:
                self.hand.isHidden = false
                self.howToPlayImage.image = #imageLiteral(resourceName: "storylineTable")
                self.handClick()
            case 2:
                self.howToPlayImage.image = #imageLiteral(resourceName: "blanks")
            case 3:
                self.howToPlayImage.image = #imageLiteral(resourceName: "blanksFilledIn")
            case 4:
                self.howToPlayImage.image = #imageLiteral(resourceName: "filledInSentence")
            case 5:
                self.howToPlayImage.image = nil
            default:
                self.howToPlayImage.image = nil
        }

        self.instructionsText.text = self.text[curVal]
        self.instructionsText.alpha = 1.0
        UIView.animate(
            withDuration: 1.0,
            delay: 5,
            options: [.transitionFlipFromLeft],
            animations: {
                self.instructionsText.alpha = 0.0;
        }, completion: { _ in
            if(self.hand.isHidden == false) {
                self.resetHand()
            }
            self.fadeTextIn(val: val + 1)
        })
    }
}

extension UITextView {
    // Center the text vertically
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}

