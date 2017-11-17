//
//  CSVSensorTableViewCell.swift
//  Labconco V2
//
//  Created by Bobby Plubell on 11/2/17.
//  Copyright © 2017 Bobby Plubell. All rights reserved.
//

import Foundation
import UIKit

class CSVSensorTableViewCell: UITableViewCell {
    @IBOutlet var sensorName: UILabel!
    var id: Int = 0;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        UserDefaults.standard.set(sensorName.text, forKey:"sensor");
        UserDefaults.standard.set(id, forKey:"sensorID");
        // Configure the view for the selected state
    }
}
