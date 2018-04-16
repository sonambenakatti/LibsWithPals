//
//  HowToPlayViewController.swift
//  Libs With Pals
//
//  Created by Sonam Benakatti on 4/15/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit

class HowToPlayViewController: UIViewController {

    @IBOutlet weak var instructionsText: UITextView!
    let text = ["Choose an option from the storyline library", "Choose words according to the given type", "c", "d"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        fadeTextIn(newText: "Choose an option from the storyline library")
//        fadeTextIn(newText: "Choose words based on the given type. For example, if given the option \'noun\', enter \'apple\'")
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        fadeTextIn(val: 0)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func fadeTextIn(val: Int) {
        let length = self.text.endIndex - 1
        self.instructionsText.alpha = 1.0
        UIView.animate(
            withDuration: 1.0,
            delay: 5,
            options: [.curveEaseOut],
            animations: {
                self.instructionsText.alpha = 0.0;
        }, completion: { _ in
                self.instructionsText.text = self.text[val % length]
                self.fadeTextIn(val: val + 1)
        })
    }

        
}
