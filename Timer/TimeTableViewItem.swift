//
//  TimeTableViewItem.swift
//  Timer
//
//  Created by Himeno Kosei on 2016/08/02.
//  Copyright © 2016年 Kosei Himeno. All rights reserved.
//

import Cocoa
import Foundation

enum TableColumnID: String {
    case MissionNumberColumn
    case MissionTitleColumn
    case ScheduledFinishTimeColumn
    case RealFinishTimeColumn
    case TimeReviseColumn
    case SoundSettingColumn
}

class TimeTableCell: NSTableCellView {
    // セルの設定
    @IBOutlet var timeTablePopUpButton: NSPopUpButton!
    let sample_sound_list = ["Sound 001", "Sound 002"]
    var currentRowNumber: Int = 0
    var currentRowTableData: [TableColumnID: AnyObject] = [:]
    
    func setCommonValue() {
        textField?.identifier = self.identifier!
        textField?.editable = true
        timeTablePopUpButton?.enabled = false
    }
    
    func setMissionNumber() {
        textField?.stringValue = String(currentRowTableData[TableColumnID.MissionNumberColumn]!)
    }
    
    func setMissionTitle() {
        textField?.stringValue = String(currentRowTableData[TableColumnID.MissionTitleColumn]!)
        self.setCommonValue()
    }
    
    func setScheduledFinishTime() {
        textField?.stringValue = String(currentRowTableData[TableColumnID.ScheduledFinishTimeColumn]!)
        self.setCommonValue()
    }
    
    func setRealFinishTime() {
        textField?.stringValue = String(currentRowTableData[TableColumnID.RealFinishTimeColumn]!)
        self.setCommonValue()
    }
    
    func setMusicValue() {
        timeTablePopUpButton.removeAllItems()
        for sound_title in sample_sound_list {
            // Todo: モデルから編集項目の設定
            timeTablePopUpButton.addItemWithTitle(sound_title)
        }
        timeTablePopUpButton.selectItemWithTitle(currentRowTableData[TableColumnID.SoundSettingColumn] as! String)
        self.setCommonValue()
    }
    
    func setTimeReviseValue() {
        self.setCommonValue()
    }
}

class TimeTableManager {
    static let sharedManager = TimeTableManager()
    var fullScreenFlag: Bool = false
    var currentTime: Int = 0
    var timerWindowOpen: Bool = false
    var customTimeFormat: String? = nil
    
    let timeTableTemplateData: [TableColumnID: AnyObject] = [
        .MissionNumberColumn: 0,
        .MissionTitleColumn: "MissionTitle",
        .ScheduledFinishTimeColumn: TimeTableManager.dateFromString("2016/07/31 10:00:00 +0900"),
        .RealFinishTimeColumn: TimeTableManager.dateFromString("2016/07/31 10:05:00 +0900"),
        .TimeReviseColumn: TimeTableManager.revisionMode.Flex.rawValue,
        .SoundSettingColumn: ""
    ]
    
    let columnIds: [TableColumnID] = [
        .MissionNumberColumn,
        .MissionTitleColumn,
        .ScheduledFinishTimeColumn,
        .RealFinishTimeColumn,
        .TimeReviseColumn,
        .SoundSettingColumn
    ]
    
    enum insertFlag: Int {
        case Before
        case After
    }
    
    enum revisionMode: Int {
        case Fix // Default
        case Flex
    }
    
    private init() {
        
    }
    
    func getCurrentTime() -> String {
        // http://qiita.com/ktanaka117/items/05b85307e0f3fb15e4bb
        let now = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss z"
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
    
    func insertDate(currentDate: String, neighborDate: String, format: String = "yyyy/MM/dd HH:mm:ss z", insertPlace: insertFlag) -> String {
        let currentNSDate: NSDate = TimeTableManager.dateFromString(currentDate, format: format)
        let neighborNSDate: NSDate = TimeTableManager.dateFromString(neighborDate, format: format)
        
        // 隣接時刻との差分を計算
        let timeInterval = neighborNSDate.timeIntervalSinceDate( currentNSDate ) / 2
        
        if timeInterval > 0 {
            let insertNSDate = NSDate(timeInterval: timeInterval, sinceDate: currentNSDate)
            // 中間時刻を返す
            return TimeTableManager.stringFromDate(insertNSDate, format: format)
        } else {
            return "0"
        }
    }
    
    
    class func dateFromString(string: String, format: String = "yyyy/MM/dd HH:mm:ss z") -> NSDate {
        print(string)
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.dateFromString(string)!
    }
    
    class func stringFromDate(date: NSDate, format: String = "yyyy/MM/dd HH:mm:ss z") -> String {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(date)
    }
    
    class SampleData {
        let data1: [TableColumnID: AnyObject] = [
            .MissionNumberColumn: 1,
            .MissionTitleColumn: "Sample Title 001",
            .ScheduledFinishTimeColumn: TimeTableManager.dateFromString("2016/07/31 10:00:00 +0900"),
            .RealFinishTimeColumn: TimeTableManager.dateFromString("2016/07/31 10:00:00 +0900"),
            .TimeReviseColumn: TimeTableManager.revisionMode.Flex.rawValue,
            .SoundSettingColumn: "Sound 001"
        ]
        let data2: [TableColumnID: AnyObject] = [
            .MissionNumberColumn: 2,
            .MissionTitleColumn: "Sample Title 002",
            .ScheduledFinishTimeColumn: TimeTableManager.dateFromString("2016/07/31 10:30:00 +0900"),
            .RealFinishTimeColumn: TimeTableManager.dateFromString("2016/07/31 10:35:00 +0900"),
            .TimeReviseColumn: TimeTableManager.revisionMode.Flex.rawValue,
            .SoundSettingColumn: "Sound 002"
        ]
    }
    
}