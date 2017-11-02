//
//  SensorTableViewCell.swift
//  Labconco Project
//
//  Created by Bobby Plubell on 9/20/17.
//  Copyright © 2017 Bobby Plubell. All rights reserved.
//

import UIKit

class SensorTableViewCell: UITableViewCell {

    @IBOutlet var sensorNameLabel: UILabel!
    @IBOutlet var sensorValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
