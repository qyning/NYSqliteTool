//
//  NYSqliteConst.swift
//  NYSqliteTool_Tests
//
//  Created by qyning on 2018/9/30.
//  Copyright © 2018 CocoaPods. All rights reserved.
//


/// 数据库-增删改
enum sqlQueueType:String {
    case Inset = "Inset"
    case Update = "Update"
    case Delete = "Delete"
}

typealias ReturnBoolClosure = (Bool) -> Void
typealias ReturnAnyClosure = (Any) -> Void
