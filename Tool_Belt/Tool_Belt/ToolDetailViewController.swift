//
//  ToolDetailViewController.swift
//  Tool_Belt
//
//  Created by Emmet Susslin on 9/19/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit

class ToolDetailViewController: UIViewController {
    
    
    var toolId: String?
    var ownerId: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(title: "", style:.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    



}
