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
    var timeTableManager = TimeTableManager.sharedManager
    let appModelManager = AppModelManager.sharedManager
    
    let timeTableDataInitTemplate: [TableColumnID: AnyObject] = TimeTableManager.sharedManager.timeTableTemplateData
    
    // Todo: モデルと同じ型に揃えること．
    var timeTableData: [[TableColumnID: AnyObject]] = [ TimeTableManager.SampleData().data1, TimeTableManager.SampleData().data2 ]
    
    override func viewDidLoad() {
        // テーブルのデリゲートとデータソースの設定
        // TODO: クラスの分離
        timeTable.setDataSource(self)
        timeTable.setDelegate(self)
    }
    
    @IBAction func secondWindowFullScreen(sender: AnyObject) {
        if timeTableManager.timerWindowOpen == false {
            // http://stackoverflow.com/questions/24694587/osx-storyboards-open-non-modal-window-with-standard-segue
            if (timerVC == nil) {
                timeTableManager.fullScreenFlag = true
                let storyboard = NSStoryboard(name: "Main", bundle: nil)
                timerVC = storyboard.instantiateControllerWithIdentifier("TimerWindow") as? NSWindowController
            }
            if (timerVC != nil) {
                timeTableManager.timerWindowOpen = true
                timerVC?.showWindow(sender)
            }
        }
    }
    
    @IBAction func missionInsertAction(sender: AnyObject) {
        // Todo: モデル内にデータを追加
        // Todo: バリデーション
        // Todo: senderより，上に追加，か下に追加か判断．
        
        var insertData = timeTableManager.timeTableTemplateData
        // NSMutableDictionary.init(dictionary: timeTableManager.timeTableTemplateData , copyItems: true)
        
        let insertIndex: Int = appModelManager.currentSelectedRowIndex
        NSLog("行を \(insertIndex) に追加します．")
        
        if (insertIndex >= 0 && insertIndex + 1 < timeTableData.count) {
            // 隣のNSDateを取得
            NSLog("current Date = \(timeTableData[insertIndex][.ScheduledFinishTimeColumn])")
            
            // NSDate
            let currentDate = String(timeTableData[insertIndex][.ScheduledFinishTimeColumn]!)
            let neighborDate = String(timeTableData[insertIndex + 1][.ScheduledFinishTimeColumn]!) // +1 or -1
            
            // 隣のNSDateとの差分で，前に挿入か，後に挿入歌を決定する．
            let insertDate = timeTableManager.insertDate(currentDate, neighborDate: neighborDate, insertPlace: .After) as String
            
            if insertDate != "0" {
                // 差分が0になったら，挿入しない．
                insertData[.ScheduledFinishTimeColumn] = insertDate
                timeTableData.insert(insertData, atIndex: insertIndex + 1)
                timeTable.reloadData()
            }
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
        // 行番号を表示
        timeTableData[row][.MissionNumberColumn] = String(row + 1)
        // 各列のセルに値を設定していく
        
        if let cell = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: nil) as? TimeTableCell {
            
            cell.currentRowNumber = row
            cell.currentRowTableData = timeTableData[row] // セルにデータを渡す
            
            switch tableColumn!.identifier {
            case TableColumnID.MissionTitleColumn.rawValue:
                cell.setMissionTitle()
            case TableColumnID.MissionNumberColumn.rawValue:
                cell.setMissionNumber()
            case TableColumnID.RealFinishTimeColumn.rawValue:
                cell.setRealFinishTime()
            case TableColumnID.ScheduledFinishTimeColumn.rawValue:
                cell.setScheduledFinishTime()
            case TableColumnID.SoundSettingColumn.rawValue:
                cell.timeTablePopUpButton.target = self
                cell.setMusicValue()
            case TableColumnID.TimeReviseColumn.rawValue:
                cell.timeTablePopUpButton.target = self
                cell.setTimeReviseValue()
            default:
                cell.textField?.stringValue = "データの呼び出しに失敗"
            }
            
            cell.textField?.delegate = self

            return cell
        } else {
            return nil
        }
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
            timeTableRowSelectedInitalize(selectedTableView, rowNum: appModelManager.currentSelectedRowIndex, enableStatus: false)
            
            if selectedTableView.selectedRow >= 0 { // カラムのHeaderを選択した時にエラーが出る対策
                timeTableRowSelectedInitalize(selectedTableView, rowNum: selectedTableView.selectedRow, enableStatus: true)
                appModelManager.currentSelectedRowIndex = selectedTableView.selectedRow
            }
        } else if (appModelManager.currentSelectedRowIndex == -100) {
            // 初回はcurrentSelectedRowIndexに-100をわざと仕込んでいる．
            // なぜならば，初回は選択された行がないため，currentSelectedRowIndexを用いて無効化するPopUpButtonが存在しない．
            timeTableRowSelectedInitalize(selectedTableView, rowNum: selectedTableView.selectedRow, enableStatus: true)
            appModelManager.currentSelectedRowIndex = selectedTableView.selectedRow
        }
        NSLog("現在選択されている行番号は \(appModelManager.currentSelectedRowIndex) 番です． ")
    }
    
    func timeTableRowSelectedInitalize(tableView: NSTableView, rowNum: Int, enableStatus: Bool) {
        // PopUpMenuのToggle: 選択時のみ有効化
        let colNum1: Int = tableView.columnWithIdentifier(TableColumnID.SoundSettingColumn.rawValue)
        let colNum2: Int = tableView.columnWithIdentifier(TableColumnID.TimeReviseColumn.rawValue)
        
        for i in [colNum1, colNum2] {
            let cell = tableView.viewAtColumn(i, row: rowNum, makeIfNecessary: false) as? TimeTableCell
            cell?.timeTablePopUpButton.enabled = enableStatus
        }
    }
    
    override func controlTextDidEndEditing(obj: NSNotification) {
        print("================================================================================")
        // TextFieldの入力が終了した時に呼び出し
        // Todo: モデルの更新
        // Todo: バリデーション
        NSLog("\(#function): TextFieldの入力完了")
        NSLog("現在選択中のRowの番号は \(appModelManager.currentSelectedRowIndex) です．")
        print(obj)
        // 現在入力しているTextFieldにidentifierを仕込むことにより，保存する場所が特定できる．
        print(obj.object)
        print(obj.object?.identifier)
        if let myValue = obj.object?.stringValue {
            NSLog("設定された値は'\(myValue)'です．")
        }
    }
}






