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
    let text = ["1. Choose an option from the storyline library",
                "2. Choose words according to the given type",
                "2. Choose words according to the given type",
                "3. View your completed storyline!"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        instructionsText.textAlignment = .center
        
        let screenSize: CGRect = UIScreen.main.bounds
        self.hand.frame = CGRect(x: screenSize.width / 1.8, y: screenSize.height / 1.4, width: self.hand.frame.width / 2, height: self.hand.frame.height / 2)
        self.view.addSubview(self.hand)
        fadeTextIn(val: 0)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    // Animate the hand clicking on a storyline
    func handClick() {
        UIView.animate(
            withDuration: 3.0,
            animations: {
                self.hand.center.x -= 50;
                self.hand.center.y -= 30;
            }
        )
    }
    
    // Animate the text changing
    func fadeTextIn(val: Int) {
        let length = self.text.endIndex
        let curVal = val % length
        
        // Change the images depending on the current text
        // Images are white, which is why you may not be able to see them below
        switch curVal {
            case 0:
                self.hand.isHidden = false
                self.howToPlayImage.image = #imageLiteral(resourceName: "storylineTable")
                self.handClick()
            case 1:
                hand.isHidden = true
                self.howToPlayImage.image = #imageLiteral(resourceName: "blanks")
            case 2:
                self.howToPlayImage.image = #imageLiteral(resourceName: "blanksFilledIn")
                break
            default:
                break
        }

        self.instructionsText.text = self.text[curVal]
        self.instructionsText.alpha = 1.0
        UIView.animate(
            withDuration: 1.0,
            delay: 5,
            options: [.curveEaseOut],
            animations: {
//                switch curVal {
//                    case 0:
//                        self.handClick()
//                    case 1:
//                        break
//                    case 2:
//                        break
//                    default:
//                        break
//                }
                self.instructionsText.alpha = 0.0;
        }, completion: { _ in
            if(self.hand.isHidden == false) {
                print("resetting hand values")
                self.hand.isHidden = true
                let screenSize: CGRect = UIScreen.main.bounds
                self.hand.center.x = screenSize.width / 1.8
                self.hand.center.y = screenSize.height / 1.4
            }
            self.fadeTextIn(val: val + 1)
        })
    }

        
}
