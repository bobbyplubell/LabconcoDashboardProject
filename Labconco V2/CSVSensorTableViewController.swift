//
//  CSVSensorTableViewController.swift
//  Labconco V2
//
//  Created by Bobby Plubell on 11/2/17.
//  Copyright © 2017 Bobby Plubell. All rights reserved.
//

import Foundation
import UIKit

class CSVSensorTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var csvSensorTableView: UITableView!;
    var sensors: [String] = [String]();
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        csvSensorTableView.delegate = self;
        csvSensorTableView.dataSource = self;
        
        if(CSVManager.downloaded) {
            sensors = CSVManager.rows;
            csvSensorTableView.reloadData();
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(!CSVManager.downloaded) {
            
            return 0;
        }
        return sensors.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CSVSensorTableViewCell";
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CSVSensorTableViewCell
            else {
                fatalError("Cell not of type csv sensor table view cell");
        }
        cell.sensorName.text = sensors[indexPath.row];
        cell.id = indexPath.row
        
        
        return cell
    }
}
