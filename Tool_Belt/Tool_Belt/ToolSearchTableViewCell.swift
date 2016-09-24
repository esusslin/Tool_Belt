//
//  ToolSearchTableViewCell.swift
//  Tool_Belt
//
//  Created by Emmet Susslin on 9/24/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit

class ToolSearchTableViewCell: UITableViewCell {
    
    let backendless = Backendless.sharedInstance()
    
    @IBOutlet weak var toolImageView: UIImageView!

    @IBOutlet weak var title: UILabel!

    
    @IBOutlet weak var distance: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(tool: Tool) {
        
        self.toolImageView.image = tool.toolPic
        
        print(tool.toolPic!)
        
        self.toolImageView.layer.cornerRadius = toolImageView.frame.size.width/2
        self.toolImageView.layer.masksToBounds = true
        
        
        self.title.text = tool.title! as String
        

        
        
    }

}
