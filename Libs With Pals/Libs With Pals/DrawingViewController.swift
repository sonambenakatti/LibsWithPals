//
//  DrawingViewController.swift
//  Libs With Pals
//
//  Created by Gerlou Shyy on 4/11/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit
import CoreData

class DrawingViewController: UIViewController {
    
    // properties
    @IBOutlet weak var canvasView: UIView!
    var path = UIBezierPath()
    var startPoint = CGPoint()
    var touchPoint = CGPoint()
    var color = UIColor.black
    let prefs: UserDefaults = UserDefaults.standard
    var finalStory: String = ""
    
    @IBAction func pressBackButton(_ sender: Any) {
        let saveLibs = prefs.bool(forKey: "saveLibs")
        print("value of saveLibs: \(saveLibs)")
        if (saveLibs) {
            self.saveMadLib()
        }
        self.performSegue(withIdentifier: "backSegue", sender: AnyClass.self)
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
    
    /*
    @IBAction func pressBackButton(_ sender: Any) {
        self.performSegue(withIdentifier: "backSegue", sender: AnyClass.self)
    }
 */
    
    @IBAction func pressBlueButton(_ sender: Any) {
        color = UIColor.blue
    }
    
    @IBAction func pressRedButton(_ sender: Any) {
        color = UIColor.red
    }
    
    @IBAction func pressGreenButton(_ sender: Any) {
        color = UIColor.green
    }
    
    @IBAction func pressOrangeButton(_ sender: Any) {
        color = UIColor.orange
    }
    
    @IBAction func pressYelloButton(_ sender: Any) {
        color = UIColor.yellow
    }
    
    @IBAction func pressPurpleButton(_ sender: Any) {
        color = UIColor.purple
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let point = touch?.location(in: canvasView) {
            startPoint = point
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let point = touch?.location(in: canvasView) {
            touchPoint = point
        }
        
        // draw a smooth line
        path.move(to: startPoint)
        path.addLine(to: touchPoint)
        startPoint = touchPoint
        
        // call draw
        draw()
    }
    
    // let users draw a picture
    func draw() {
        let strokeLayer = CAShapeLayer()
        strokeLayer.fillColor = nil
        strokeLayer.lineWidth = 5
        strokeLayer.strokeColor = color.cgColor
        strokeLayer.path = path.cgPath
        canvasView.layer.addSublayer(strokeLayer)
        canvasView.layer.setNeedsDisplay()
    }

    // clear the screen
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        path.removeAllPoints()
        canvasView.layer.sublayers = nil
        canvasView.setNeedsDisplay()
        color = UIColor.black
    }
}
