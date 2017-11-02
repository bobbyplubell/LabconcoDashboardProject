//
//  CSVTableViewCell.swift
//  Labconco V2
//
//  Created by Bobby Plubell on 10/20/17.
//  Copyright © 2017 Bobby Plubell. All rights reserved.
//

import UIKit

class CSVTableViewCell: UITableViewCell {
    @IBOutlet weak var csvName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
