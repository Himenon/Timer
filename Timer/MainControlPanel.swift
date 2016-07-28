//
//  MainControlPanel.swift
//  Timer
//
//  Created by Himeno Kosei on 2016/07/17.
//  Copyright © 2016年 Kosei Himeno. All rights reserved.
//

import Cocoa
import Foundation


class MainControlPanel: NSViewController {
    @IBOutlet var timeTable: NSTableView!
    @IBOutlet var timerWindow: NSWindow!
    
    var timerVC: NSWindowController?
    var timerViewManaer = TimerViewManager.sharedManager
    
    let colIDs: [String] = [
        "MissionNumberColumn",
        "MissionTitleColumn",
        "ScheduledFinishTimeColumn",
        "RealFinishTimeColumn",
        "TimeReviseColumn",
        "SoundSettingColumn"
    ]
    
    let celIDs: NSMutableDictionary  = [
        "MissionNumberColumn": "MissionNumberCell",
        "MissionTitleColumn": "MissionTitleCell",
        "ScheduledFinishTimeColumn": "ScheduledFinishTimeCell",
        "RealFinishTimeColumn": "RealFinishTimeCell",
        "TimeReviseColumn": "TimeReviseCell",
        "SoundSettingColumn": "SoundSettingCell",
        ]
    
    let timeTableData: [NSMutableDictionary] = [
        [
            "MissionNumberColumn": 1,
            "MissionTitleColumn": "my title",
            "ScheduledFinishTimeColumn": "20:10:12",
            "RealFinishTimeColumn": "20:20:15",
            "TimeReviseColumn": "false",
            "SoundSettingColumn": ""
        ],
        [
            "MissionNumberColumn": 2,
            "MissionTitleColumn": "your title",
            "ScheduledFinishTimeColumn": "20:20:12",
            "RealFinishTimeColumn": "21:20:15",
            "TimeReviseColumn": "false",
            "SoundSettingColumn": ""
        ]
    ]
    
    override func viewDidLoad() {
        // テーブルのデリゲートとデータソースの設定
        // TODO: クラスの分離
        timeTable.setDataSource(self)
        timeTable.setDelegate(self)
    }
    
    func inputEventInitialize() {
        // イベントの上書きで死ぬ．
        NSEvent.addLocalMonitorForEventsMatchingMask(NSEventMask.KeyDownMask, handler: {
            // TableViewにNSEventのHandlerを登録する．
            // http://stackoverflow.com/questions/37072182/xcode-swift-osx-select-and-edit-cells-in-viewbased-nstableview
            (event: NSEvent) in
            self.timeTable.keyDown(event);
            
            // print("KeyCode : '\(event.keyCode)' が入力されました．")
            switch(event.keyCode)
            {
            case 36: // Enter Key
                return nil;
            default:
                return event;
            }
        })
    }
    
    @IBAction func secondWindowFullScreen(sender: AnyObject) {
        if timerViewManaer.timerWindowOpen == false {
            // http://stackoverflow.com/questions/24694587/osx-storyboards-open-non-modal-window-with-standard-segue
            if (timerVC == nil) {
                timerViewManaer.fullScreenFlag = true
                let storyboard = NSStoryboard(name: "Main", bundle: nil)
                timerVC = storyboard.instantiateControllerWithIdentifier("TimerWindow") as? NSWindowController
            }
            if (timerVC != nil) {
                timerViewManaer.timerWindowOpen = true
                timerVC?.showWindow(sender)
            }
        }
    }
    
    
    @IBAction func exitButton(sender: AnyObject) {
        exit(0)
    }
    
}

extension MainControlPanel: NSTableViewDataSource {
    // テーブルViewのデータソース
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        // テーブルに何個表示するかの設定
        return timeTableData.count
    }
    
    //    func tableView(tableView: NSTableView, setObjectValue object: AnyObject?, forTableColumn tableColumn: NSTableColumn?, row: Int) {
    //        // View-basedになって消えてしまったメソッド。View-basedではもう呼び出されない
    //        print(#function)
    //        print("TableViewのデータを更新します！")
    //        timeTableData[row][(tableColumn?.identifier)!] = object as! String
    //    }
    
    
}

extension MainControlPanel: NSTableViewDelegate, NSTextFieldDelegate, NSMenuDelegate {
    // NSTableView操作: イベントなどを管理
    // データの取登録
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        // TODO: Modelからデータを呼び出す
        var text:String = ""
        var cellIdentifier: String = ""
        
        for (idx, colID) in colIDs.enumerate() {
            if tableColumn == timeTable.tableColumns[idx] {
                let mymy = timeTableData[row].objectForKey(colID)
                text = String(mymy!)
                cellIdentifier = String(celIDs.objectForKey(colID)!)
            }
            
            if idx == 4 || idx == 5 {
                if let cell = tableView.makeViewWithIdentifier(cellIdentifier, owner: nil) as? TimeTableCell {
                    cell.setValue()
                    cell.revisePopButton?.target = self
                    cell.soundPopButton?.target = self
                    return cell
                }
            }
            
            if let cell = tableView.makeViewWithIdentifier(cellIdentifier, owner: nil) as? TimeTableCell {
                cell.textField?.stringValue = text
                cell.textField?.editable = true
                cell.textField?.delegate = self
                return cell
            }
        }
        return nil
    }
    
    func menuDidClose(menu: NSMenu) {
        NSLog("\(#function): Selected!")
        print(menu.itemArray)
    }
    
    // カラムの操作
    func tableView(tableView: NSTableView, didClickTableColumn tableColumn: NSTableColumn) {
        // Todo: 時刻を選択した場合，時系列を反転させる．
        NSLog(#function)
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        NSLog("\(#function): 行が選択されました．")
        let selectedTableView: NSTableView = notification.object as! NSTableView
        let appModelManager = AppModelManager.sharedManager
        
        if appModelManager.currentSelectedRowIndex != selectedTableView.selectedRow {
            timeTableRowSelectedInitalize(selectedTableView, rowNum: appModelManager.currentSelectedRowIndex, enable: false)
            if selectedTableView.selectedRow >= 0 { // カラムのHeaderを選択した時にエラーが出る対策
                timeTableRowSelectedInitalize(selectedTableView, rowNum: selectedTableView.selectedRow, enable: true)
                appModelManager.currentSelectedRowIndex = selectedTableView.selectedRow
            }
        }
    }
    
    func timeTableRowSelectedInitalize(tableView: NSTableView, rowNum: Int, enable: Bool) {
        // PopUpMenuのToggle: 選択時のみ有効化
        let colNum1:Int = tableView.columnWithIdentifier(colIDs[4])
        let colNum2:Int = tableView.columnWithIdentifier(colIDs[5])
        for i in [colNum1, colNum2] {
            let cell = tableView.viewAtColumn(i, row: rowNum, makeIfNecessary: false) as? TimeTableCell
            cell?.revisePopButton?.enabled = enable
            cell?.soundPopButton?.enabled =  enable
        }
    }
    
    override func controlTextDidEndEditing(obj: NSNotification) {
        print("================================================================================")
        // TextFieldの入力が終了した時に呼び出し
        NSLog("\(#function): TextFieldの入力完了")
        let appModelManager = AppModelManager.sharedManager
        NSLog("現在選択中のRowの番号は \(appModelManager.currentSelectedRowIndex) です．")
        print(obj)
        print(obj.object)
        if let myValue = obj.object?.stringValue {
            NSLog("設定された値は'\(myValue)'です．")
        }
    }
    
}


class TimeTableCell: NSTableCellView {
    // セルの設定
    @IBOutlet var revisePopButton: NSPopUpButton!
    @IBOutlet var soundPopButton: NSPopUpButton!
    @IBOutlet var order_numner_label: NSTextField!
    @IBOutlet var text_content: NSTextField!
    @IBOutlet var date_set_field: NSTextField!
    
    func setValue() {
        if textField != nil {
            textField?.editable = true
        }
        
        if text_content != nil {
            text_content.editable = true
        }
        
        if revisePopButton != nil {
            revisePopButton.removeAllItems()
            for i in 1...10 {
                // Todo: モデルから編集項目の設定
                revisePopButton.addItemWithTitle("Hello \(i)")
            }
            revisePopButton.enabled = false
        }
        
        if soundPopButton != nil {
            // Todo: モデルからサウンドの設定
            soundPopButton.removeAllItems()
            for i in 1...10 {
                // Todo: モデルから編集項目の設定
                soundPopButton.addItemWithTitle("Sound: \(i)")
            }
            soundPopButton.enabled = false
        }
    }
    
    
}



