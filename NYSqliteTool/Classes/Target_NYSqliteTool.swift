//
//  Target_NYSqliteTool.swift
//  NYSqliteTool_Tests
//
//  Created by qyning on 2018/9/30.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit


@objc class Target_NYSqliteTool: NSObject {
    
    /// 创建数据库表
    ///
    /// - Parameter params: 创建表需要的数据
    /// - Returns: 创建表的状态
    @objc func Action_createTable(_ params: Dictionary<String, Any>) -> Bool  {
        return NYSqliteManager.share().createTable(params)
    }
    
    /// 插入数据库数据
    ///
    /// - Parameter params: 插入数据库的数据
    /// - Returns: 插入数据的状态
    @objc func Action_insertData(_ params: Dictionary<String, Any>)  -> Bool  {
        return NYSqliteManager.share().insertData(params)
    }
    
    /// 查询数据库数据是否存在
    ///
    /// - Parameter params: 查询数据库条件和表
    /// - Returns: 是否存在
    @objc func Action_searchData(_ params: Dictionary<String, Any>) -> Bool  {
        return NYSqliteManager.share().searchData(params)
    }
    
    /// 更新数据库数据
    ///
    /// - Parameter params: 更新数据库数据参数
    /// - Returns: 更新数据的状态
    @objc func Action_updataData(_ params: Dictionary<String, Any>) -> Bool {
        return NYSqliteManager.share().updataData(params)
    }
    
    /// 删除数据库数据
    ///
    /// - Parameter params: 删除数据库数据参数
    /// - Returns: 删除数据的状态
    @objc func Action_deleteData(_ params: Dictionary<String, Any>) -> Bool  {
        return NYSqliteManager.share().deleteData(params)
    }
    
    /// 获取数据库数据
    ///
    /// - Parameter params: 获取数据库数据参数
    /// - Returns: 数据库中数据集合
    @objc func Action_fetchData(_ params: Dictionary<String, Any>)  -> Any?  {
        return NYSqliteManager.share().fetchData(params)
    }
    
    /// 删除表
    ///
    /// - Parameter params: 删除表参数
    /// - Returns: 数据库中数据集合
    @objc func Action_deleteTable(_ params: Dictionary<String, Any>) -> Bool  {
        return NYSqliteManager.share().deleteTable(params)
    }
    
    /// 数据库升级添加需要添加新的字段
    @objc func Action_checkUpdateTableWithNewColumnName(_ params: Dictionary<String, Any>) -> Bool  {
        return NYSqliteManager.share().checkUpdateTableWithNewColumnName(params)
    }
    
    /// 批量操作增删改
    @objc func Action_queueInDatabase(_ params: Dictionary<String, Any>) {
        NYSqliteManager.share().QueueInDatabase(params)
    }
    
    /// log
    @objc func Action_logOpen(_ params: Dictionary<String, Any>) {
        NYSqliteManager.share().logIsOpen(params)
    }
    
}
