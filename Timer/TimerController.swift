//
//  ViewController.swift
//  Timer
//
//  Created by Himeno Kosei on 2016/07/09.
//  Copyright © 2016年 Kosei Himeno. All rights reserved.
//

import Cocoa
import AVFoundation


class TimerController: NSViewController, AVAudioPlayerDelegate {
    
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
    @IBOutlet var ChooseMusicButton: NSButton!
    
    // タイムアップ時に流すミュージック
    var timerUpMusicURL: NSURL!
    var timeUpMusic: AVAudioPlayer! = nil
    
    @IBOutlet var timeUpMusicLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        TimerStopButton.enabled = false
//        TimerClearButton.enabled = false
//        TimerLabel.font = NSFont(name: "Helvetica", size: 64)
//        
//        initTimerSetting.setup()
//        updateTimerSetting.setup()
    }
    
    @IBAction func TimerStart(sender: AnyObject) {
        
        missionLabel.stringValue = missionLabel.stringValue
        
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
        ChooseMusicButton.enabled = false
        
        timerCounter = NSTimeInterval( initTimerSetting.getTotalSecond() )
        initTimerSetting.setEnable(false)
        TimerLabel.stringValue = generateTimerCountLabel(Int(timerCounter))
        
        mainTimer = NSTimer.scheduledTimerWithTimeInterval(self.timerInterval, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        mainTimer.fire()
    }
    
    @IBAction func TimerStop(sender: AnyObject) {
        missionLabel.stringValue = missionLabel.stringValue
        
        TimerStartButton.enabled = true
        TimerStopButton.enabled = false
        ChooseMusicButton.enabled = true
        
        if (timeUpMusic != nil && timeUpMusic.playing) {
            timeUpMusic.stop()
        }
        
        mainTimer.invalidate()
    }
    
    
    @IBAction func TimerClear(sender: AnyObject) {
        if (timeUpMusic != nil && timeUpMusic.playing) {
            timeUpMusic.stop()
        }
        
        TimerStartButton.enabled = true
        TimerStopButton.enabled = false
        TimerClearButton.enabled = false
        ChooseMusicButton.enabled = true
        
        missionLabel.stringValue = missionLabel.stringValue
        
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
    
    func update() {
        timerCounter -= timerInterval
        
        if timerCounter <= 0 {
            TimerLabel.stringValue = "終了です！"
            //　タイマーの終了
            mainTimer.invalidate()
            initTimerSetting.setEnable(true)
            
            TimerStartButton.enabled = false
            TimerStopButton.enabled = false
            TimerClearButton.enabled = true
            ChooseMusicButton.enabled = true
            
            playTimeUpMusic()
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
    
    // NSTextFieldの入力イベントの取得
    
    // 音楽
    func playTimeUpMusic() {
        if timerUpMusicURL != nil {
            timeUpMusic = try! AVAudioPlayer(contentsOfURL: timerUpMusicURL)
            timeUpMusic.play()
        }
    }
    
    @IBAction func chooseMusic(sender: AnyObject) {
        
        // ----
        print(#function)
        let openDir = NSOpenPanel()
        openDir.canChooseFiles = true
        openDir.canChooseDirectories = false
        openDir.allowsMultipleSelection = false
        
        if (openDir.runModal() == NSModalResponseOK) {
            
            if !hasMusicExt(openDir.URL!) {
                timeUpMusicLabel.stringValue = "有効なファイル形式ではありません。"
                return
            }
            
            timerUpMusicURL = openDir.URL
            timeUpMusicLabel.stringValue = getFileTitle(timerUpMusicURL)
            
            timeUpMusic = try! AVAudioPlayer(contentsOfURL: timerUpMusicURL)
            timeUpMusic.prepareToPlay()
            
        }
    }
    
    func getFileTitle(URL: NSURL) -> String {
        let strURL = URL.absoluteString.componentsSeparatedByString("/").last!
        return strURL.stringByRemovingPercentEncoding!
    }
    
    func hasMusicExt(URL: NSURL) -> Bool {
        let ext_array: [String] = ["mp3", "mp4", "caf"]
        let ext: String = getFileTitle(URL).componentsSeparatedByString(".").last!
        
        for cext in ext_array {
            print("拡張子:\(ext), 調査する拡張子: \(cext)")
            if ext.containsString(cext) {
                return true
            }
        }
        
        return false
    }
    
}

