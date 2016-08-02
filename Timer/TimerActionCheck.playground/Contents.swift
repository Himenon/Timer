//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"


let doubleValue: Double = 1.23

// Double -> Intに変換
String(format: "%02d", doubleValue)
String(format: "%02d", Int(doubleValue))

// 小数値
String(format: "%.2f", doubleValue)


let myURL = "a/b/c/defg.cfg"

myURL.componentsSeparatedByString("/").last


let pURL: String = "%E3%81%A6%E3%81%A3%E3%81%A6%E3%81%A3%E3%81%A6%E3%83%BC%E5%8E%9F%E6%9B%B2%E3%80%80ver.mp3"

pURL.stringByRemovingPercentEncoding

// Singleton
class Manager {
    static let sharedManager = Manager()
    
    var mynumber: Int = 0
    private init() {
    }
}

let m1 = Manager.sharedManager
let m2 = Manager.sharedManager


m1.mynumber = 100
print(m2.mynumber)


let date = NSDate()
let calendar = NSCalendar.currentCalendar()
let unitFlags: NSCalendarUnit = [.Year, .Month, .Day, .Hour, .Minute, .Second]
let components = calendar.components(unitFlags, fromDate: date)
let hour = components.hour

components.minute
components.second

// http://qiita.com/k-yamada@github/items/8b6411959579fd6cd995
class DateUtils {
    class func dateFromString(string: String, format: String) -> NSDate {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.dateFromString(string)!
    }
    
    class func stringFromDate(date: NSDate, format: String) -> String {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(date)
    }
}

// NSDate -> String
print("HELLO")
// String -> NSDate
let dateString = "2015/03/04 12:34:56 +09:00"
let date2 = DateUtils.dateFromString(dateString, format: "yyyy/MM/dd HH:mm:ss Z")
print(date2)

// NSDateの計算
let date_plus = DateUtils.dateFromString("2015/03/04 12:34:56", format: "yyyy/MM/dd HH:mm:ss")
let date_minu = DateUtils.dateFromString("2015/03/04 10:34:56", format: "yyyy/MM/dd HH:mm:ss")


let time_interval = date_plus.timeIntervalSinceDate(date_minu) / 2

NSDate(timeInterval: time_interval, sinceDate: date_minu)


var my_array = ["a", "b", "c", "d", "e", "f"]
my_array.insert("111", atIndex: 3)

// NSMutableArrayの挙動確認

let nsMDict: NSMutableDictionary = ["a": 1, "b": 2]

nsMDict["a"] = 300

nsMDict

let copyDict: NSMutableDictionary = NSMutableDictionary.init(dictionary: nsMDict as [NSObject : AnyObject], copyItems: true)
copyDict["a"] = 400

copyDict
nsMDict

NSDate()

enum revisionMode: Int {
    case Fix // Default
    case Flex
}

revisionMode.Fix.rawValue


