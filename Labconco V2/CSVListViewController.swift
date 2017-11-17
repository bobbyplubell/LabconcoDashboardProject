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
    
    @IBAction func updatePressed(_ sender: Any) {
        updateCSV();
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        let url = UserDefaults.standard.string(forKey: "url");
        if(url != nil && (!url!.isEmpty)) {
            FreezeDryerManager.connect(urlString: "http://" + url!);
        } else {
            print("No url")
        }
        
        csvTableView.delegate = self;
        csvTableView.dataSource = self;
        
        if(!FreezeDryerManager.freezeDryer.csvs.isEmpty) {
            csvTableView.reloadData()
        }
    }
    
    func updateCSV() {
        print("updating csvs");
        do {
            try FreezeDryerManager.freezeDryer.getCSVAsync(completion: csvUpdated);
        } catch FreezeDryer.FreezeDryerError.cannotConnect {
            print("CSV Connection error");
        }
    }
    
    func csvUpdated(success: Bool, csvs_: [String]) {
        print("csvUpdated!")
        if(success) {
            self.csvs = csvs_;
            DispatchQueue.main.async {
                self.csvTableView.reloadData();
            }
        } else {
            print("csv update not successful");
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
        print(indexPath.row);
        print(csvs);
        cell.csvName.text = csvs[indexPath.row];
        
        return cell
    }
}
