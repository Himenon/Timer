//
//  ViewController.swift
//  Timer
//
//  Created by Himeno Kosei on 2016/07/09.
//  Copyright © 2016年 Kosei Himeno. All rights reserved.
//

import Cocoa

class TimerController: NSViewController {
    
    var mainTimer: NSTimer!
    var timerCounter: NSTimeInterval = 0
    var timerInterval: NSTimeInterval = 1
    
    @IBOutlet weak var TimerLabel: NSTextField!
    
    // 設定ビュー
    @IBOutlet var initTimerSetting: SetTimerView!
    @IBOutlet var updateTimerSetting: SetTimerView!
    
    // ミッションビュー
    @IBOutlet var missionLabel: NSTextField!
    
    
    // 実行ボタン
    @IBOutlet var TimerStartButton: NSButton!
    @IBOutlet var TimerStopButton: NSButton!
    @IBOutlet var TimerClearButton: NSButton!
    
    @IBAction func TimerStart(sender: AnyObject) {
        
        if initTimerSetting.valueCheck()  == false {
            TimerLabel.stringValue = "値を設定して下さい。"
            TimerLabel.font = NSFont(name: "Helvetica", size: 24)
            return
        } else {
            TimerLabel.font = NSFont(name: "Helvetica", size: 64)
        }
        
        TimerStartButton.enabled = false
        TimerStopButton.enabled = true
        TimerClearButton.enabled = true
        missionLabel.enabled = false
        
        timerCounter = NSTimeInterval( initTimerSetting.getTotalSecond() )
        initTimerSetting.setEnable(false)
        TimerLabel.stringValue = generateTimerCountLabel(Int(timerCounter))
        
        mainTimer = NSTimer.scheduledTimerWithTimeInterval(self.timerInterval, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        mainTimer.fire()
    }
    
    @IBAction func TimerStop(sender: AnyObject) {
        TimerStartButton.enabled = true
        TimerStopButton.enabled = false
        
        mainTimer.invalidate()
    }
    
    
    @IBAction func TimerClear(sender: AnyObject) {
        
        TimerClearButton.enabled = false
        missionLabel.enabled = true
        
        mainTimer.invalidate()
        initTimerSetting.setEnable(true)
        timerCounter = NSTimeInterval( initTimerSetting.getTotalSecond() )
        TimerLabel.stringValue = generateTimerCountLabel(Int(timerCounter))
    }
    
    @IBAction func AddTimerCount(sender: AnyObject) {
        timerCounter += NSTimeInterval( updateTimerSetting.getTotalSecond() )
        TimerLabel.stringValue = generateTimerCountLabel(Int(timerCounter))
    }
    
    @IBAction func DiffTimerCount(sender: AnyObject) {
        timerCounter -= NSTimeInterval(  updateTimerSetting.getTotalSecond() )
        if timerCounter <= 0 {
            timerCounter = 0
        }
        TimerLabel.stringValue = generateTimerCountLabel(Int(timerCounter))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TimerStopButton.enabled = false
        TimerClearButton.enabled = false
        TimerLabel.font = NSFont(name: "Helvetica", size: 64)
        
        initTimerSetting.setup()
        updateTimerSetting.setup()
    }
    
    func update() {
        timerCounter -= timerInterval
        
        if timerCounter <= 0 {
            TimerLabel.stringValue = "終了です！"
            //　タイマーの終了
            mainTimer.invalidate()
            initTimerSetting.setEnable(true)
        } else {
            TimerLabel.stringValue = generateTimerCountLabel(Int(timerCounter))
        }
        
    }
    
    func generateTimerCountLabel(totalSecond: Int) -> String {
        // ジェネリックスで書いたほうが良い。
        let minutes: Int = Int(totalSecond / 60)
        let second: Int = totalSecond - 60 * minutes
        return String(format: "%02d:%02d", minutes, second)
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func buttnoStateToggle(state: Bool) {
        
    }
    
}

