//
//  FreezeDryer.swift
//  Labconco Project
//
//  Created by Bobby Plubell on 9/20/17.
//  Copyright © 2017 Bobby Plubell. All rights reserved.
//

import Foundation
import SwiftSoup

class FreezeDryer{
    
    let url : URL;
    var vacuumLevel : String;
    var _sensors : [String: Double];
    var sensors : [(String,Double)] = [(String,Double)]();
    var time : String;
    var fdMode : String;
    var product : String;
    var csvs : [String] = [String]();
    
    enum FreezeDryerError: Error {
        case invalidJSONString;
        case cannotConnect
    }
    
    init?(urlString: String) {
        self.url = URL(string: urlString)!;
        self._sensors = [String: Double]();
        self.product = "";
        self.vacuumLevel = "";
        self.time = "";
        self.fdMode = "";
    }
    
    func getCSVs() throws -> [String] {
        let string = try NSString(contentsOf:self.url, encoding: String.Encoding.utf8.rawValue);
        //print(string);
        let doc: Document = try SwiftSoup.parse(string as String);
        let filelistSection: Elements = try doc.select("section#filelist");
        let csvLinks: Elements = try filelistSection.select("a");
        var returnArray: [String] = [String]();
        for csv in csvLinks {
            returnArray.append((try csv.attr("href")));
        }
        return returnArray;
    }
    
    func getCSVAsync(completion: @escaping (Bool, [String]) -> Void) {
        let populateTask = URLSession.shared.dataTask(with: self.url) {(data, response, error) in
            if(error != nil) {
                completion(false, [String]());
                return;
            }
            do {
                let strData = String(data:data!, encoding: String.Encoding.utf8) as String!;
                let doc: Document = try SwiftSoup.parse((strData)!);
                let filelistSection: Elements = try doc.select("section#filelist");
                let csvLinks: Elements = try filelistSection.select("a");
                var returnArray: [String] = [String]();
                for csv in csvLinks {
                    returnArray.append((try csv.attr("href")));
                }
                self.csvs = returnArray;
                completion(true, returnArray);
                return;
            } catch {
                completion(false, [String]());
                return;
            }
            
            completion(true, [String]());
            return;
        }
        
        populateTask.resume();
    }
    
    func updateSensors(completion: @escaping (Bool) -> Void) {
        let populateTask = URLSession.shared.dataTask(with: self.url.appendingPathComponent("/dump")) {(data, response, error) in
            if(error != nil) {
                completion(false);
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []);
                try self.populateWithJson(json: json as! [String : Any]);
            } catch {
                completion(false);
            }
            
            completion(true);
        }
        
        populateTask.resume();
    }
    
    func populateWithJson(json: [String: Any]) throws {
        guard var sensors = json["Sensors"] as? String
            else {
                throw FreezeDryerError.invalidJSONString;
        }
        
        //remove curcly braces
        sensors = String(sensors.characters.dropLast().dropFirst());
        
        //create new array with sensors split into strings such as "44=2.354"
        let sensorArr : [String] = sensors.components(separatedBy: ",");
        print(sensorArr);
        //init sensor array
        self._sensors = [String: Double]();
        
        //iterate over all sensors
        for sensorString in sensorArr {
            //if sensor is null skip it
            if(sensorString.contains("null")) {
                continue;
            }
            
            //split into id and value [id,val]
            let sensorIDVal = sensorString.components(separatedBy: "=");
            
            //separate id and val, remove whitespaces, and cast to int and double, lookup sensor name with int id
            let sensorID = FreezeDryer.sensorIDToName(sensorID: Int(sensorIDVal[0].trimmingCharacters(in: .whitespacesAndNewlines))!);
            if sensorID.isEmpty {
                continue;
            }
            let sensorVal = Double(sensorIDVal[1].trimmingCharacters(in: .whitespacesAndNewlines))!;
            
            //add new sensor
            self._sensors[sensorID] = sensorVal;
        }
        for (name, val) in self._sensors {
            self.sensors.append((name, val));
        }
        print(self.sensors);
        print("sensors updated");
        print(self._sensors);
    }
    
    static let sensorIdToNameTable : [Int: String] = [1: "Lexsol Temp Sensor",
                               2: "Shelf Temp Probe",
                               3: "Shelf Sample Probe",
                               4: "Collector Temp Sensor",
                               5: "Lexsol Temp Sensor",
                               
                               6: "Temp Probe 1",
                               7: "Temp Probe 2",
                               8: "Temp Probe 3",
                               
                               9: "Shelf 1 Temp Probe",
                               10: "Shelf 2 Temp Probe",
                               11: "Shelf 3 Temp Probe",
                               12: "Shelf 4 Temp Probe",
                               13: "Shelf 5 Temp Probe",
                               14: "Shelf 1 Sample Probe",
                               15: "Shelf 2 Sample Probe",
                               16: "Shelf 3 Sample Probe",
                               17: "Shelf 4 Sample Probe",
                               18: "Shelf 5 Sample Probe",
                               
                               19: "Shelf 1 Temp Probe",
                               20: "Shelf 2 Temp Probe",
                               21: "Shelf 3 Temp Probe",
                               22: "Shelf 4 Temp Probe",
                               23: "Shelf 5 Temp Probe",
                               24: "Shelf 1 Sample Probe",
                               25: "Shelf 2 Sample Probe",
                               26: "Shelf 3 Sample Probe",
                               27: "Shelf 4 Sample Probe",
                               28: "Shelf 5 Sample Probe",
                               
                               29: "Tray 1 Temp Probe",
                               30: "Tray 2 Temp Probe",
                               31: "Tray 3 Temp Probe",
                               32: "Tray 4 Temp Probe",
                               33: "Tray 5 Temp Probe",
                               34: "Tray 1 Sample Probe",
                               35: "Tray 2 Sample Probe",
                               36: "Tray 3 Sample Probe",
                               37: "Tray 4 Sample Probe",
                               38: "Tray 5 Sample Probe",
                               
                               39: "Collector Temp",
                               40: "Mini-chamber Temp",
                               41: "Shell Freezer Temp",
                               42: "Triad Home Screen",
                               
                               50: "System Vacuum Sensor",
                               51: "System Vacuum Sensor",
                               52: "System Vacuum Sensor",
                               
                               53: "Vacuum Sample Sensor 1",
                               54: "Vacuum Sample Sensor 2",
                               55: "Vacuum Sample Sensor 3",
                               56: "Vacuum Sample Sensor 4",
                               57: "Vacuum Sample Sensor 5",
                               58: "Vacuum Sample Sensor 6",
                               ];
    
    private static func sensorIDToName(sensorID : Int) -> String {
        guard let name = sensorIdToNameTable[sensorID] as? String
            else {
                return "";
        }
        return name;
    }
}
