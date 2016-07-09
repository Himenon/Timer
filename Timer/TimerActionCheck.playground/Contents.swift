//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"


let doubleValue: Double = 1.23

// Double -> Intに変換
String(format: "%02d", doubleValue)
String(format: "%02d", Int(doubleValue))

// 小数値
String(format: "%.2f", doubleValue)

