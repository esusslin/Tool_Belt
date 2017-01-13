//
//  MyToolBeltTableViewCell.swift
//  Tool_Belt
//
//  Created by Emmet Susslin on 9/6/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit

class MyToolBeltTableViewCell: UITableViewCell {
    
    let backendless = Backendless.sharedInstance()
    

    @IBOutlet weak var toolImageView: UIImageView!
    
    @IBOutlet weak var toolTitle: UILabel!

    @IBOutlet weak var toolMake: UILabel!
    
    @IBOutlet weak var availableLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(tool: Tool) {
        
        print(tool.available)
        
        if tool.available == true {
            self.availableLbl.text = "available"
            self.availableLbl.textColor = UIColor.greenColor()
        } else {
            self.availableLbl.text = "unavailable"
            self.availableLbl.textColor = UIColor.redColor()
        }
        
        
        self.toolImageView.layer.cornerRadius = toolImageView.frame.size.width/2
        self.toolImageView.layer.masksToBounds = true
        
        self.toolImageView.image = tool.toolPic
        
        
        self.toolTitle.text = tool.title! as String
        
        self.toolMake.text = tool.make! as String

        
    }

}
