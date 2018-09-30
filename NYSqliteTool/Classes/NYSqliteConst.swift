//
//  NYSqliteConst.swift
//  NYSqliteTool_Tests
//
//  Created by qyning on 2018/9/30.
//  Copyright © 2018 CocoaPods. All rights reserved.
//


/// 数据库-增删改
@objc public enum sqlQueueType:Int {
    case Inset = 1
    case Update = 2
    case Delete = 3
}

typealias ReturnBoolClosure = (Bool) -> Void
typealias ReturnAnyClosure = (Any) -> Void
