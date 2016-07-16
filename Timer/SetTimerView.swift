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
    @IBOutlet var dayField: NSTextField!
    @IBOutlet var hourField: NSTextField!
    @IBOutlet var minuteField: NSTextField!
    @IBOutlet var secondField: NSTextField!
    
    func setup() {
        dayField.intValue = 0
        hourField.intValue = 0
        minuteField.intValue = 0
        secondField.intValue = 0
    }
    
    func getTotalSecond() -> Int {
        let day: Int = Int(dayField.intValue)
        let hour: Int = Int(hourField.intValue)
        let minute: Int = Int(minuteField.intValue)
        let second: Int = Int(secondField.intValue)
        
        return 24 * 3600 * day + 3600 * hour + 60 * minute + second
    }
    
    func setEnable(state: Bool) {
        dayField.enabled = state
        hourField.enabled = state
        minuteField.enabled = state
        secondField.enabled = state
    }
    
    func valueCheck() -> Bool {
        
        let day: Int = Int(dayField.intValue)
        let hour: Int = Int(hourField.intValue)
        let minute: Int = Int(minuteField.intValue)
        let second: Int = Int(secondField.intValue)
        
        if (day == 0 && hour == 0 && minute == 0 && second == 0) {
            return false
        } else {
            return true
        }
    }
    
}