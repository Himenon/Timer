//
//  TimerWindowController.swift
//  Timer
//
//  Created by Himeno Kosei on 2016/07/17.
//  Copyright © 2016年 Kosei Himeno. All rights reserved.
//

import Cocoa
import Foundation

class TimerViewManager {
    static let sharedManager = TimerViewManager()
    var fullScreenFlag: Bool = false
    var currentTime: Int = 0
    private init() {
        
    }
}


class TimerWindowController: NSViewController {
    @IBOutlet weak var missionLabel: NSTextField!
    @IBOutlet weak var timerLabel: NSTextField!
    @IBOutlet weak var logoImage: NSImageView!
    @IBOutlet weak var titleLabel: NSTextField!
    
    var timerViewManaer = TimerViewManager.sharedManager
    
    override func viewDidLoad() {
        if timerViewManaer.fullScreenFlag {
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
                    .DisableMenuBarTransparency,   // Menu Bar's transparent appearance is disabled
                //  .FullScreen                ,   // Application is in fullscreen mode
                    .HideDock                  ,   // Dock is entirely unavailable. Spotlight menu is disabled.
                    .HideMenuBar               ,   // Menu Bar is Disabled
                    .DisableAppleMenu          ,   // All Apple menu items are disabled.
                //  .DisableProcessSwitching   ,   // Cmd+Tab UI is disabled. All Exposé functionality is also disabled.
                    .DisableSessionTermination ,   // PowerKey panel and Restart/Shut Down/Log Out are disabled.
                    .DisableHideApplication    ,   // Application "Hide" menu item is disabled.
                    .AutoHideToolbar
                ]
            
            let optionsDictionary = [NSFullScreenModeApplicationPresentationOptions :
                NSNumber(unsignedLong: presOptions.rawValue)]
            self.view.enterFullScreenMode(NSScreen.mainScreen()!, withOptions: optionsDictionary)
            self.view.wantsLayer = true
        }
    }
    
    func fullScreenTrigger() {
        NSLog("FullScreen!")
    }
}