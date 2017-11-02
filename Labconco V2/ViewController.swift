//
//  ViewController.swift
//  Labconco Project
//
//  Created by Bobby Plubell on 9/20/17.
//  Copyright © 2017 Bobby Plubell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var myLabel: UILabel!
    @IBOutlet var myButton: UIButton!
    let fd: FreezeDryer = FreezeDryer(urlString: "http://12.43.13.50/dump")!;
    
    @IBAction func pressed(_ sender: Any) {
        print(fd.sensors);
        //fd.update();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("view loaded");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

