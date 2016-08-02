//
//  TabBarController.swift
//  Tool_Belt
//
//  Created by Emmet Susslin on 7/26/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // color of tab items
        self.tabBar.tintColor = .blackColor()
        
        // color of background
        self.tabBar.barTintColor = UIColor(red: 84.0 / 255.0, green: 104.0 / 255.0, blue: 120.0 / 255.0, alpha: 1)
        
        //disable translucent
        self.tabBar.translucent = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
