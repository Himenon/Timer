//
//  AppModel.swift
//  Timer
//
//  Created by Himeno Kosei on 2016/07/17.
//  Copyright © 2016年 Kosei Himeno. All rights reserved.
//

import Foundation
import RealmSwift

class TimeTable: Object {
    // TimeTable と TimeTask は1対多のリレーション
    dynamic var id: Int = 0
    dynamic var title: String = ""
    dynamic var create_at = NSDate()
    dynamic var update_at = NSDate()
    let tasks = List<Mission>()
    
    override static func primaryKey() -> String? {
        return "id"
    }

}

class Mission: Object {
    // MissionとSoundBoxは1対1のリレーション
    // タイムテーブルのタスク
    dynamic var title: String = ""
    dynamic var time_mode: UInt = 0
    dynamic var finish_at = NSDate()
    dynamic var number: Int = 0      // ミッションの順番
    dynamic var lock: Int = 0
    dynamic var visible: Bool = true // 表示 非表示
    dynamic var end_sound: Sound?    // 音源を一つ持つ
}

class SoundBox: Object {
    // SoundBox と Sound は1対多のリレーション
    dynamic var title: String = ""
    dynamic var create_at = NSDate()
    dynamic var update_at = NSDate()
    let sound_list = List<Sound>()
}

class Sound: Object {
    dynamic var title: String = ""
    dynamic var trigger_time: Int = 0 // second
    dynamic var url: String = ""
}