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
    @IBOutlet var graphButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func graphButtonPressed(_ sender: Any) {
        UserDefaults.standard.set(csvName.text, forKey: "csv")
        var url = UserDefaults.standard.string(forKey: "url")
        url?.append(csvName.text!)
        print("graph button")
        print(url)
        
        if(url != nil) {
            CSVManager.downloadCSV(url: URL(string:"http://" + url!)!);
            csvName.textColor = UIColor.green;
        } else {
            csvName.textColor = UIColor.red;
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
