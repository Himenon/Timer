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
    
    override func viewDidLoad() {
        // テーブルのデリゲートとデータソースの設定
        // TODO: クラスの分離
        timeTable.setDataSource(self)
        timeTable.setDelegate(self)
    }
}

class SubControlPanel: NSViewController {
    
}

class TimeTableControlPanel: NSViewController {
    
}

extension MainControlPanel: NSTableViewDataSource {
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        // テーブルに何個表示するかの設定
        return 5
    }
}

extension MainControlPanel: NSTableViewDelegate {
    
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        // TODO: Modelからデータを呼び出す
        var text:String = ""
        var cellIdentifier: String = ""
        
        if tableColumn == timeTable.tableColumns[0] {
            text = String(row + 1)
            cellIdentifier = "MissionNumberCell"
        }
        
        if tableColumn == timeTable.tableColumns[1] {
            text = "Mission Title" + String(row + 1)
            cellIdentifier = "MissionTitleCell"
        }
        
        if tableColumn == timeTable.tableColumns[2] {
            text = "ScheduledFinishTimeCell " + String(row + 1)
            cellIdentifier = "ScheduledFinishTimeCell"
        }
        
        if tableColumn == timeTable.tableColumns[3] {
            text = "RealFinishTimeCell" + String(row + 1)
            cellIdentifier = "RealFinishTimeCell"
        }
        
        if tableColumn == timeTable.tableColumns[4] {
            text = "TimeReviseCell" + String(row + 1)
            cellIdentifier = "TimeReviseCell"
            print(cellIdentifier)
            if let cell = tableView.makeViewWithIdentifier(cellIdentifier, owner: nil) as? TimeTableCustomCell {
                cell.setValue()
                return cell
            }
        }
        
        if tableColumn == timeTable.tableColumns[5] {
            text = "SoundSettingCell" + String(row + 1)
            cellIdentifier = "SoundSettingCell"
            print(cellIdentifier)
            if let cell = tableView.makeViewWithIdentifier(cellIdentifier, owner: nil) as? TimeTableCustomCell {
                cell.setValue()
                return cell
            }
        }
        
        if let cell = tableView.makeViewWithIdentifier(cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text

            return cell
        }
        
        return nil
    }
}


class TimeTableCustomCell: NSTableCellView {
    @IBOutlet var cBox: NSComboBox!
    
    func setValue() {
        for i in 1...10 {
            cBox.insertItemWithObjectValue("Hello \(i)", atIndex: cBox.numberOfItems)
        }
        
    }
    
}



