//
//  HomeViewController.swift
//  Libs With Pals
//
//  Created by Sonam Benakatti on 3/15/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit

@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}


class HomeViewController: UIViewController {

    // View either displays a user photo or a default photo
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var greetingLabel: UILabel!
    let prefs:UserDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize the screen to greet the user with their name
        let name = String(describing: prefs.value(forKey: "name")!)
        greetingLabel.text = "Hi, " +  name + "!"
        image.image = #imageLiteral(resourceName: "defaultUserImage")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Navigate to correct screen (either for one player mode or two player mode)
    @IBAction func onNewGameButtonPressed(_ sender: Any) {
        let twoPlayer = prefs.bool(forKey: "twoPlayer")
        if(twoPlayer) {
            self.performSegue(withIdentifier: "homeToTwoPlayerSegue", sender: AnyClass.self)
        } else {
            self.performSegue(withIdentifier: "homeToOnePlayerSegue", sender: AnyClass.self)

        }

    }
    

}
