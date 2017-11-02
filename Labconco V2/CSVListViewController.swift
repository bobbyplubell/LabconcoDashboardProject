//
//  CSVListViewController.swift
//  Labconco V2
//
//  Created by Bobby Plubell on 10/19/17.
//  Copyright © 2017 Bobby Plubell. All rights reserved.
//

import UIKit

class CSVListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var csvTableView: UITableView!
    
    var csvs: [String] = [String]();
    let updateTime: Double = 60;//60 seconds
    
    override func viewDidLoad() {
        super.viewDidLoad();
        FreezeDryerManager.connect(urlString: "http://12.43.13.50");
        
        if(UserDefaults.standard.object(forKey:"csvlastupdated") != nil) {
            if(currentTime() - UserDefaults.standard.double(forKey: "csvlastupdated") > updateTime) {
                updateCSV();
            }
        } else {
            updateCSV();
        }
        
        print(csvs);
        
        csvTableView.delegate = self;
        csvTableView.dataSource = self;
        
        csvTableView.reloadData()
    }
    
    func updateCSV() {
        print("updating csvs");
        do {
            csvs = try FreezeDryerManager.freezeDryer.getCSVs();
            UserDefaults.standard.set(currentTime(), forKey: "csvlastupdated");
        } catch {
            print("CSV Connection error");
        }
    }
    
    func currentTime() -> Double {
        return NSDate().timeIntervalSince1970;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return csvs.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CSVTableViewCell";
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CSVTableViewCell
            else {
                fatalError("Cell not of type csv table view cell");
        }
        
        cell.csvName.text = csvs[indexPath.row];
        
        return cell
    }
}
