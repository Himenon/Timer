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
    var timeTableManaer = TimeTableManager.sharedManager
    let appModelManager = AppModelManager.sharedManager
    let timeFormat: String = "HH:mm:ss"
    
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
    
    let timeTableDataInitTemplate: NSMutableDictionary = [
        "MissionNumberColumn": 1,
        "MissionTitleColumn": "MissionTitle",
        "ScheduledFinishTimeColumn": "20:10:12",
        "RealFinishTimeColumn": "20:20:15",
        "TimeReviseColumn": "false",
        "SoundSettingColumn": ""
    ]
    
    var timeTableData: [NSMutableDictionary] = [
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
    
    @IBAction func secondWindowFullScreen(sender: AnyObject) {
        if timeTableManaer.timerWindowOpen == false {
            // http://stackoverflow.com/questions/24694587/osx-storyboards-open-non-modal-window-with-standard-segue
            if (timerVC == nil) {
                timeTableManaer.fullScreenFlag = true
                let storyboard = NSStoryboard(name: "Main", bundle: nil)
                timerVC = storyboard.instantiateControllerWithIdentifier("TimerWindow") as? NSWindowController
            }
            if (timerVC != nil) {
                timeTableManaer.timerWindowOpen = true
                timerVC?.showWindow(sender)
            }
        }
    }
    
    @IBAction func missionInsertAction(sender: AnyObject) {
        // Todo: モデル内にデータを追加
        // Todo: バリデーション
        // Todo: senderより，上に追加，か下に追加か判断．
        
        
        let insertData: NSMutableDictionary = NSMutableDictionary.init(dictionary: timeTableDataInitTemplate as [NSObject: AnyObject], copyItems: true)
        let insertIndex: Int = appModelManager.currentSelectedRowIndex
        NSLog("行を \(insertIndex) に追加します．")
        
        if (insertIndex >= 0 && insertIndex + 1 < timeTableData.count) {
            // 隣のNSDateを取得
            // 隣のNSDateとの差分で，前に挿入か，後に挿入歌を決定する．
            let scheduleKey: String = "ScheduledFinishTimeColumn"
            let currentDate = timeTableData[insertIndex][scheduleKey] as! String
            let neighborDate = timeTableData[insertIndex + 1][scheduleKey] as! String // +1 or -1
            
            insertData[scheduleKey] = timeTableManaer.insertDate(currentDate, neighborDate: neighborDate, format: timeFormat, insertPlace: .After) as String
            
            NSLog("現在の時刻: \(currentDate), 隣接した時刻: \(neighborDate), 計算した(挿入する)時刻: \(insertData[scheduleKey])")
            timeTableData.insert(insertData, atIndex: insertIndex + 1)
            timeTable.reloadData()
        }
    }
    
    @IBAction func missinDeleteAction(sender: AnyObject) {
        // Todo: 行の削除
        if timeTableData.count > 0 {
            timeTableData.removeAtIndex(appModelManager.currentSelectedRowIndex)
            timeTable.reloadData()
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
        
        // 行番号を表示
        timeTableData[row].setValue(String(row + 1), forKey: "MissionNumberColumn")
        
        for (idx, colID) in colIDs.enumerate() {
            if tableColumn == timeTable.tableColumns[idx] {
                let mymy = timeTableData[row].objectForKey(colID)
                text = String(mymy!)
                cellIdentifier = String(celIDs.objectForKey(colID)!)
            }
            
            if idx == 4 || idx == 5 {
                if let cell = tableView.makeViewWithIdentifier(cellIdentifier, owner: nil) as? TimeTableCell {
                    cell.setValue()
                    cell.timeTablePopUpButton.target = self
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
        // 初回以外に有効
        if (appModelManager.currentSelectedRowIndex != selectedTableView.selectedRow && appModelManager.currentSelectedRowIndex >= 0) {
            // 前回選択時の行のpopupButtonを無効化する
            timeTableRowSelectedInitalize(selectedTableView, rowNum: appModelManager.currentSelectedRowIndex, enable: false)
            
            if selectedTableView.selectedRow >= 0 { // カラムのHeaderを選択した時にエラーが出る対策
                timeTableRowSelectedInitalize(selectedTableView, rowNum: selectedTableView.selectedRow, enable: true)
                appModelManager.currentSelectedRowIndex = selectedTableView.selectedRow
            }
        } else if (appModelManager.currentSelectedRowIndex == -100) {
            // 初回はcurrentSelectedRowIndexに-100をわざと仕込んでいる．
            // なぜならば，初回は選択された行がないため，currentSelectedRowIndexを用いて無効化するPopUpButtonが存在しない．
            timeTableRowSelectedInitalize(selectedTableView, rowNum: selectedTableView.selectedRow, enable: true)
            appModelManager.currentSelectedRowIndex = selectedTableView.selectedRow
        }
        NSLog("現在選択されている行番号は \(appModelManager.currentSelectedRowIndex) 番です． ")
    }
    
    func timeTableRowSelectedInitalize(tableView: NSTableView, rowNum: Int, enable: Bool) {
        // PopUpMenuのToggle: 選択時のみ有効化
        let colNum1:Int = tableView.columnWithIdentifier(colIDs[4])
        let colNum2:Int = tableView.columnWithIdentifier(colIDs[5])
        for i in [colNum1, colNum2] {
            let cell = tableView.viewAtColumn(i, row: rowNum, makeIfNecessary: false) as? TimeTableCell
            cell?.timeTablePopUpButton.enabled = enable
        }
    }
    
    override func controlTextDidEndEditing(obj: NSNotification) {
        print("================================================================================")
        // TextFieldの入力が終了した時に呼び出し
        NSLog("\(#function): TextFieldの入力完了")
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
    @IBOutlet var timeTablePopUpButton: NSPopUpButton!
    
    func setValue() {
        if textField != nil {
            textField?.editable = true
        }
        
        if timeTablePopUpButton != nil {
            timeTablePopUpButton.removeAllItems()
            for i in 1...10 {
                // Todo: モデルから編集項目の設定
                timeTablePopUpButton.addItemWithTitle("My List \(i)")
            }
            timeTablePopUpButton.enabled = false
        }
    }
}



