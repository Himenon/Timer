//
//  SetTimerViewController.swift
//  Timer
//
//  Created by Himeno Kosei on 2016/07/09.
//  Copyright © 2016年 Kosei Himeno. All rights reserved.
//

import Cocoa
import Foundation

class SetTimerView: NSView {
    @IBOutlet var minutesLabel: NSTextField!
    @IBOutlet var secondLabel: NSTextField!
    
    func setup() {
        minutesLabel.intValue = 0
        secondLabel.intValue = 0
    }
    
    func getTotalSecond() -> Int {
        let minutes: Int = Int(minutesLabel.intValue)
        let second: Int = Int(secondLabel.intValue)
        return 60 * minutes + second
    }
    
    func setEnable(state: Bool) {
        minutesLabel.enabled = state
        secondLabel.enabled = state
    }
    
    func valueCheck() -> Bool {
        let minutes: Int = Int(minutesLabel.intValue)
        let second: Int = Int(secondLabel.intValue)
        
        if (minutes == 0 && second == 0) {
            return false
        } else {
            return true
        }
    }
    
}