//
//  ViewController.swift
//  Timer
//
//  Created by Himeno Kosei on 2016/07/09.
//  Copyright © 2016年 Kosei Himeno. All rights reserved.
//

import Cocoa

class TimerController: NSViewController {

 
    @IBOutlet weak var TimerLabel: NSTextField!
    @IBOutlet weak var TimerSetField: NSTextField!
    
 
    @IBAction func TimerStart(sender: AnyObject) {
        print(#function)
    }
    
    @IBAction func TimerStop(sender: AnyObject) {
        print(#function)
    }
    
    
    @IBAction func TimerClear(sender: AnyObject) {
        print(#function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

