//
//  TasksTableViewCell.swift
//  Homework32
//
//  Created by Kato on 6/2/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class TasksTableViewCell: UITableViewCell {

    @IBOutlet weak var taskTitleLabel: UILabel!
    
    @IBOutlet weak var taskTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
