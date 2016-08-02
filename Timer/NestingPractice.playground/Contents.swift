//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"


class TopKlass {
    let myname: String = "topklass"
    class SubKlass {

    }
    
}

var myklass = TopKlass().myname


enum TableColumnID: String {
    case MissionNumberColumn
    case MissionTitleColumn
    case ScheduledFinishTimeColumn
    case RealFinishTimeColumn
    case TimeReviseColumn
    case SoundSettingColumn
}


TableColumnID.MissionTitleColumn
TableColumnID.MissionTitleColumn.rawValue


let timeTableTemplateData: [TableColumnID: AnyObject] = [
    .MissionNumberColumn: "hello",
    .MissionTitleColumn: "your name"
]

timeTableTemplateData[.MissionTitleColumn]


for cid in timeTableTemplateData {
    print(cid.0)
}
