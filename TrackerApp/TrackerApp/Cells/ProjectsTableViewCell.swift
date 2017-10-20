//
//  ProjectsTableViewCell.swift
//  Tracker
//
//  Created by Andy LI on 9/27/17.
//  Copyright © 2017 Puzzle. All rights reserved.
//

import UIKit

class ProjectsTableViewCell: UITableViewCell {


    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var numItemLabel: UILabel!
    @IBOutlet weak var projectsTotalCostLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
