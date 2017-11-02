//
//  FreezeDryerManager.swift
//  Labconco Project
//
//  Created by Bobby Plubell on 10/18/17.
//  Copyright © 2017 Bobby Plubell. All rights reserved.
//

import Foundation

class FreezeDryerManager {
    static var freezeDryer: FreezeDryer = FreezeDryer(urlString: "127.0.0.1")!;
    
    public static func connect(urlString: String) {
        FreezeDryerManager.freezeDryer = FreezeDryer(urlString: urlString)!;
    }
    
    public static func checkConnection(completion: @escaping (Bool) -> Void) {
        if(FreezeDryerManager.freezeDryer.url.host == "127.0.0.1") {
            completion(false);
        }
        
        FreezeDryerManager.freezeDryer.updateSensors(completion: completion);
    }
}
