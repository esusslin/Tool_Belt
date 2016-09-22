//
//  ToolDetailViewController.swift
//  Tool_Belt
//
//  Created by Emmet Susslin on 9/19/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import Mapbox

class ToolDetailViewController: UIViewController {
    
    @IBOutlet weak var toolImageView: UIImageView!
    @IBOutlet weak var toolTitle: UILabel!
    @IBOutlet weak var toolMake: UILabel!
    @IBOutlet weak var toolDescription: UILabel!
    

    var toolId: String?
    var ownerId: String?
    var tool: Tool?
    var owner: BackendlessUser?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(title: "", style:.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        
        getTool()
        
//        getOwner()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func getTool() {
        
        let whereClause = "objectId = '\(self.toolId)'"
        let dataQuery = BackendlessDataQuery()
        
        dataQuery.whereClause = whereClause
        var error: Fault?
        
        
        let tools = Backendless.sharedInstance().data.of(Tool.ofClass())
        
        tools.find(dataQuery, response: { (tools : BackendlessCollection!) in
        
        if let tool = tools.data.first as? Tool {
            print("********")
            print(tool.title)
            print("********")
            self.tool = tool
            print("********")
        }
        
       }) { (fault : Fault!) -> Void in
        print("Server report an error : \(fault)")
        }

    }
    



}
