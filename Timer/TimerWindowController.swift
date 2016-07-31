//
//  TimerWindowController.swift
//  Timer
//
//  Created by Himeno Kosei on 2016/07/17.
//  Copyright © 2016年 Kosei Himeno. All rights reserved.
//

import Cocoa
import Foundation

class TimeTableManager {
    static let sharedManager = TimeTableManager()
    var fullScreenFlag: Bool = false
    var currentTime: Int = 0
    var timerWindowOpen: Bool = false

    enum insertFlag: Int {
        case Before
        case After
    }
    
    private init() {
        
    }
    
    func getCurrentTime() -> String {
        // http://qiita.com/ktanaka117/items/05b85307e0f3fb15e4bb
        let now = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.stringFromDate(now)
    }
    
    func timerOverFlag(finishDate: NSDate) -> Bool {
        // 引数と現在時刻の差分を計算して、0の場合終了(true)を返すs
        return true
    }
    
    func leaveTime(finishDate: NSDate) -> NSDate {
        // 残り時間を計算
        return NSDate()
    }
    
    func insertDate(currentDate: String, neighborDate: String, format: String, insertPlace: insertFlag) -> String {
        let currentNSDate: NSDate = TimeTableManager.dateFromString(currentDate, format: format)
        let neighborNSDate: NSDate = TimeTableManager.dateFromString(neighborDate, format: format)
        
        // 隣接時刻との差分を計算
        let timeInterval = neighborNSDate.timeIntervalSinceDate( currentNSDate ) / 2
        let insertNSDate = NSDate(timeInterval: timeInterval, sinceDate: currentNSDate)
        
        // 中間時刻を返す
        return TimeTableManager.stringFromDate(insertNSDate, format: format)
    }
    
    
    class func dateFromString(string: String, format: String) -> NSDate {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.dateFromString(string)!
    }
    
    class func stringFromDate(date: NSDate, format: String) -> String {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(date)
    }
    
}

class AppModelManager {
    static let sharedManager = AppModelManager()
    var currentSelectedRowIndex: Int = -100
    private init() {
        
    }
}


class TimerWindowController: NSViewController {
    @IBOutlet weak var missionLabel: NSTextField!
    @IBOutlet weak var timerLabel: NSTextField!
    @IBOutlet weak var logoImage: NSImageView!
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var currentTimeLabel: NSTextField!
    
    var timerViewManager = TimeTableManager.sharedManager
    var mainTimer: NSTimer!
    
    var timerCounter: NSTimeInterval = 0
    let timerInterval: NSTimeInterval = 1
    
    override func viewDidLoad() {
        if timerViewManager.fullScreenFlag {
            // http://blogs.wcode.org/2015/06/howto-create-a-locked-down-fullscreen-cocoa-application-and-implement-nslayoutconstraints-using-swift/
            // http://stackoverflow.com/questions/32810878/how-to-apply-the-nsapplicationpresentationoptions-to-an-application
            NSLog("フルスクリーンにしました。")
            let presOptions: NSApplicationPresentationOptions =
                //----------------------------------------------
                // These are all the options for the NSApplicationPresentationOptions
                // BEWARE!!!
                // Some of the Options may conflict with each other
                //----------------------------------------------
                [
                //  .Default                   ,
                //  .AutoHideDock              ,   // Dock appears when moused to
                //  .AutoHideMenuBar           ,   // Menu Bar appears when moused to
                //  .DisableForceQuit          ,   // Cmd+Opt+Esc panel is disabled
                //  .DisableMenuBarTransparency,   // Menu Bar's transparent appearance is disabled
                //  .FullScreen                ,   // Application is in fullscreen mode
                //  .HideDock                  ,   // Dock is entirely unavailable. Spotlight menu is disabled.
                //  .HideMenuBar               ,   // Menu Bar is Disabled
                    .DisableAppleMenu          ,   // All Apple menu items are disabled.
                //  .DisableProcessSwitching   ,   // Cmd+Tab UI is disabled. All Exposé functionality is also disabled.
                    .DisableSessionTermination ,   // PowerKey panel and Restart/Shut Down/Log Out are disabled.
                //  .DisableHideApplication    ,   // Application "Hide" menu item is disabled.
                    .AutoHideToolbar
                ]
            
            let optionsDictionary = [NSFullScreenModeApplicationPresentationOptions :
                NSNumber(unsignedLong: presOptions.rawValue)]
            
            self.view.enterFullScreenMode(NSScreen.mainScreen()!, withOptions: optionsDictionary)
            self.view.wantsLayer = true
        }
        
        mainTimer = NSTimer.scheduledTimerWithTimeInterval(self.timerInterval, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        mainTimer.fire()
        
    }
    
    func fullScreenTrigger() {
        NSLog("FullScreen!")
    }
    
    
    func update() {
        self.currentTimeLabel.stringValue = timerViewManager.getCurrentTime()
        // 終了フラグが立った場合、タイマーをストップ。
    }
    
}