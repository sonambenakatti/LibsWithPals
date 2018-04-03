//
//  SavedLibsViewController.swift
//  Libs With Pals
//
//  Created by Sonam Benakatti on 4/2/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit

class SavedLibsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func onHomeButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "savedLibsToHomeSegue", sender: AnyClass.self)

    }
    

}
