//
//  TimerWindowController.swift
//  Timer
//
//  Created by Himeno Kosei on 2016/07/17.
//  Copyright © 2016年 Kosei Himeno. All rights reserved.
//

import Cocoa
import Foundation


class TimerWindowController: NSViewController {
    @IBOutlet weak var missionLabel: NSTextField!
    @IBOutlet weak var timerLabel: NSTextField!
    @IBOutlet weak var logoImage: NSImageView!
    @IBOutlet weak var titleLabel: NSTextField!
    

    override func viewDidLoad() {
        NSLog("TimerWIndowControllerへようこそ")
    }
}