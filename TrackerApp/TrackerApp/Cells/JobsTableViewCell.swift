//
//  JobsTableViewCell.swift
//  Tracker
//
//  Created by Andy LI on 9/27/17.
//  Copyright © 2017 Puzzle. All rights reserved.
//

import UIKit

class JobsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var jobNameLabel: UILabel!
    @IBOutlet weak var numProjLabel: UILabel!
    @IBOutlet weak var jobTotalCostLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
