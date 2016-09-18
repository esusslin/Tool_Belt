//
//  HomeViewController.swift
//  Tool_Belt
//
//  Created by Emmet Susslin on 9/13/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    
    @IBOutlet var mainView: UIView!

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var overlay: UIView!
    
    var mask: CALayer!
    var animation: CABasicAnimation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        searchButton.layer.cornerRadius = 8.0
//        searchButton.layer.masksToBounds = true

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    

    @IBAction func button(sender: AnyObject) {
        
        animateLaunch(UIImage(named: "wrench")!)
    }
    
    func animateLaunch(image: UIImage) {
        
//        self.view.backgroundColor = bgColor
        
        // Create and apply mask
        
        mask = CALayer()
        mask.contents = image.CGImage
        mask.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        mask.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        mask.position = CGPoint(x: mainView.frame.width / 2.0, y: mainView.frame.height / 2.0)
        mainView.layer.mask = mask
        
        animateDecreaseSize()
        
    }
    
    func animateDecreaseSize() {
    
        let decreaseSize = CABasicAnimation(keyPath: "bounds")
        decreaseSize.delegate = self
        decreaseSize.duration = 0.5
        decreaseSize.fromValue = NSValue(CGRect: mask!.bounds)
        decreaseSize.toValue = NSValue(CGRect: CGRect(x: 0, y: 0, width: 80, height: 80))
        
        decreaseSize.fillMode = kCAFillModeForwards
        decreaseSize.removedOnCompletion = false
        
        mask.addAnimation(decreaseSize, forKey: "bounds")
        
    
        
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        animateIncreaseSize()
    }
    
    func animateIncreaseSize() {
        
        animation = CABasicAnimation(keyPath: "bounds")
        animation.duration = 0.75
        animation.fromValue = NSValue(CGRect: mask!.bounds)
        animation.toValue = NSValue(CGRect: CGRect(x: 0, y: 0, width: 4000, height: 4000))
        
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        
        mask.addAnimation(animation, forKey: "bounds")
        
        // Fade out overlay
        UIView.animateWithDuration(0.75, animations: { () -> Void in
            self.overlay.alpha = 0
    })


   }
}