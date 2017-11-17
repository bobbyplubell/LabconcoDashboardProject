//
//  CSVManager.swift
//  Labconco V2
//
//  Created by Bobby Plubell on 11/2/17.
//  Copyright © 2017 Bobby Plubell. All rights reserved.
//

import Foundation

class CSVManager {
    static var downloaded: Bool = false;
    static var csv = [[String]]();
    static var rows = [String]();
    
    static func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    static func downloadCSV(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            self.downloaded = true;
            print(url);
            let csvStr = String(data: data, encoding: String.Encoding.ascii) as String!;
            //print(csvStr);
            //parse it
            self.csv = csvStr!.components(separatedBy: "\n\n")[1].components(separatedBy: "\n").map{ $0.components(separatedBy: ",") }
            self.csv.remove(at: csv.count-1)
            self.parse();
        }
    }
    
    static func getCol(col: Int) -> [String]{
        var retRow = [String]();
        
        //skip first because it's labels
        for i in 1..<csv.count {
            retRow.append(String(csv[i][col]))
        }
        return retRow
    }
    
    static func parse() {
        rows = csv[0];
    }
}
