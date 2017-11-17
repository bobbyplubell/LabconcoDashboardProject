//
//  ChartViewController.swift
//  Labconco V2
//
//  Created by Bobby Plubell on 11/2/17.
//  Copyright © 2017 Bobby Plubell. All rights reserved.
//

import Foundation
import Charts
import UIKit

enum DataError : Error {
    case NotDouble(String)
}

class ChartViewController: UIViewController {
    
    @IBOutlet var lineChartView: LineChartView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        lineChartView.noDataText = "No data found";
        lineChartView.xAxis.labelRotationAngle = -45
        if(CSVManager.downloaded) {
            do {
             try? loadData();
            } catch DataError.NotDouble(let msg) {
                lineChartView.noDataText = "Sensor selected not graphable"
            }
        }
    }
    
    func loadData() throws {
        var times = [String]()
        for i in 0..<CSVManager.csv.count {
            times.append(CSVManager.csv[i][0] + " " + CSVManager.csv[i][1])
        }
        
        var values = CSVManager.getCol(col:UserDefaults.standard.integer(forKey:"sensorID"))
        var dValues = [Double]()
        for v in values {
            if(Double(v) != nil) {
                dValues.append(Double(v)!)
            } else {
                throw DataError.NotDouble("Not double")
            }
        }
        times.remove(at:0);
        print(times)
        print(times.count)
        print(values)
        setData(times: times,values: dValues);
    }
    
    func setData(times: [String], values: [Double]) {
        var entries: [ChartDataEntry] = []
        for i in 0..<times.count {
            entries.append(ChartDataEntry(x:Double(i), y:values[i]))
        }
        let chartDataSet = LineChartDataSet(values: entries, label: UserDefaults.standard.string(forKey: "sensor"))
        let chartData = LineChartData(dataSet: chartDataSet)
        lineChartView.data = chartData
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: times)
        lineChartView.chartDescription?.text = UserDefaults.standard.string(forKey: "csv")
    }
}
