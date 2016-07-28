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
    
    let colIDs: [String] = ["MissionNumberCell",
                            "MissionTitleCell",
                            "ScheduledFinishTimeCell",
                            "RealFinishTimeCell",
                            "TimeReviseCell",
                            "SoundSettingCell"]
    
    let timeTableData: [NSMutableDictionary] = [
        [
            "MissionNumberCell": 1,
            "MissionTitleCell": "my title",
            "ScheduledFinishTimeCell": "20:10:12",
            "RealFinishTimeCell": "20:20:15",
            "TimeReviseCell": "false",
            "SoundSettingCell": ""
        ],
        [
            "MissionNumberCell": 2,
            "MissionTitleCell": "Second Title",
            "ScheduledFinishTimeCell": "20:16:12",
            "RealFinishTimeCell": "20:30:15",
            "TimeReviseCell": "wayway",
            "SoundSettingCell": ""
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

extension MainControlPanel: NSTableViewDelegate, NSTextFieldDelegate, NSComboBoxDelegate {

    //
    override func validateProposedFirstResponder(responder: NSResponder, forEvent event: NSEvent?) -> Bool {
        return true
    }
    
    // NSTableView操作: イベントなどを管理
    // データの取登録
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        // TODO: Modelからデータを呼び出す
        var text:String = ""
        var cellIdentifier: String = ""
        
        for (idx, checkCellIdentifier) in colIDs.enumerate() {
            if tableColumn == timeTable.tableColumns[idx] {
                let mymy = timeTableData[row].objectForKey(checkCellIdentifier)
                text = String(mymy!)
                cellIdentifier = checkCellIdentifier
            }
            
            if idx == 4 {
                if let cell = tableView.makeViewWithIdentifier(cellIdentifier, owner: nil) as? TimeTableCell {
                    
                    cell.setValue()
                    
                    cell.soundComboBox?.enabled = true
                    cell.soundComboBox?.editable = true
                    cell.reviseComboBox?.enabled = true
                    cell.reviseComboBox?.editable = true
                    cell.soundComboBox?.setDelegate(self)
                    cell.reviseComboBox?.setDelegate(self)
                    return cell
                }
            }
            
            if idx == 5 {
                if let cell = tableView.makeViewWithIdentifier(cellIdentifier, owner: nil) as? TimeTableCell {
                    cell.setValue()
                    cell.soundComboBox?.enabled = true
                    cell.soundComboBox?.editable = true
                    cell.reviseComboBox?.enabled = true
                    cell.reviseComboBox?.editable = true
                    cell.soundComboBox?.setDelegate(self)
                    cell.reviseComboBox?.setDelegate(self)
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
    
    func tableView(tableView: NSTableView, setObjectValue object: AnyObject?, forTableColumn tableColumn: NSTableColumn?, row: Int) {
        NSLog("\(#function): 値の設定と見込んだ")
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        print("\(#function): 値の取得と見込んだ")
        return true
    }
    
    // カラムの操作
    func tableView(tableView: NSTableView, didClickTableColumn tableColumn: NSTableColumn) {
        NSLog(#function)
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        NSLog("\(#function): セルが選択されました．")
        let selectedTableView: NSTableView = notification.object as! NSTableView
        let appModelManager = AppModelManager.sharedManager
        appModelManager.currentSelectedRowIndex = selectedTableView.selectedRow
    }
    
    
    func tableViewSelectionIsChanging(notification: NSNotification) {
        NSLog("\(#function): 選択中の行が変更されました．")
    }
    
    override func controlTextDidBeginEditing(obj: NSNotification) {
        // 入力開始時に呼び出し
        NSLog("\(#function): 編集開始")
    }
    
    override func controlTextDidChange(obj: NSNotification) {
        // 入力中に呼び出し
        NSLog("\(#function): 編集中")
    }
    
    func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        NSLog("\(#function): Cellの編集終了")
        print(fieldEditor.string)
        // [Mac] NSTableView - セル編集終了時のイベントを掴む
        // http://cocoadays.blogspot.jp/2010/11/mac-nstableview_28.html
        return true
    }
    
    override func controlTextDidEndEditing(obj: NSNotification) {
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
    
    func comboBoxSelectionDidChange(notification: NSNotification) {
        NSLog("\(#function): comboboxのチェンジ！")
        print(notification)
    }
    
}


class TimeTableCell: NSTableCellView {
    // セルの設定
    @IBOutlet var reviseComboBox: NSComboBox!
    @IBOutlet var soundComboBox: NSComboBox!
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
        
        if reviseComboBox != nil {
            for i in 1...10 {
                // Todo: モデルから編集項目の設定
                reviseComboBox.insertItemWithObjectValue("Hello \(i)", atIndex: reviseComboBox.numberOfItems)
            }
        }
        
        if soundComboBox != nil {
            // Todo: モデルからサウンドの設定
        }
    }
    
    
}



