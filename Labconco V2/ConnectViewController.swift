//
//  ConnectViewController.swift
//  Labconco Project
//
//  Created by Bobby Plubell on 10/19/17.
//  Copyright © 2017 Bobby Plubell. All rights reserved.
//

import UIKit

class ConnectViewController: UIViewController {
    @IBOutlet var ipTextField: UITextField!
    @IBOutlet var connectButton: UIButton!
    @IBOutlet var validLabel: UILabel!
    let defaults = UserDefaults.standard;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(UserDefaults.standard.object(forKey: "url") != nil) {
            ipTextField.text = defaults.string(forKey:"url");
        }
        validLabel.text = "";
    }
    
    @IBAction func connectPressed(_ sender: Any) {
        if(validateIP(string: ipTextField.text!)) {
            FreezeDryerManager.connect(urlString: "http://" + ipTextField.text!);
            validLabel.text = "Attempting connection...";
            validLabel.textColor = UIColor.black;
            FreezeDryerManager.checkConnection(completion: connectedCallback(success:));
        } else {
            validLabel.text = "Invalid IP";
            validLabel.textColor = UIColor.red;
        }
    }
    
    func connectedCallback(success: Bool) {
        if(success) {
            DispatchQueue.main.async {
                self.validLabel.text = "Connected!";
                self.validLabel.textColor = UIColor.green;
                self.defaults.set(self.ipTextField.text, forKey:"url");
            }
        } else {
            DispatchQueue.main.async {
                self.validLabel.text = "Could not connect...";
                self.validLabel.textColor = UIColor.red;
            }
            
        }
    }
    
    func validateIP(string: String) -> Bool {
        return isIPv4(string);
    }
    
    private func isIPv4(_ IP: String) -> Bool {
        let items = IP.components(separatedBy: ".")
        if(items.count != 4) { return false }
        for item in items {
            var tmp = 0
            if(item.characters.count > 3 || item.characters.count < 1){
                return false
            }
            for char in item.characters{
                if(char < "0" || char > "9"){
                    return false
                }
                tmp = tmp * 10 + Int(String(char))!
            }
            if(tmp < 0 || tmp > 255){
                return false
            }
            if((tmp > 0 && item.characters.first == "0") || (tmp == 0 && item.characters.count > 1)){
                return false
            }
        }
        return true
    }
}
