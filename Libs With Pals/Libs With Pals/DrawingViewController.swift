//
//  DrawingViewController.swift
//  Libs With Pals
//
//  Created by Gerlou Shyy on 4/11/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit

class DrawingViewController: UIViewController {
    
    @IBOutlet weak var canvasView: UIView!
    var path = UIBezierPath()
    var startPoint = CGPoint()
    var touchPoint = CGPoint()
    
    @IBAction func onButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "drawSegue", sender: AnyClass.self)
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
        strokeLayer.strokeColor = UIColor.black.cgColor
        strokeLayer.path = path.cgPath
        canvasView.layer.addSublayer(strokeLayer)
        canvasView.layer.setNeedsDisplay()
    }

    // clear the screen
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        path.removeAllPoints()
        canvasView.layer.sublayers = nil
        canvasView.setNeedsDisplay()
    }
}
