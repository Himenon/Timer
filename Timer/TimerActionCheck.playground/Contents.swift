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