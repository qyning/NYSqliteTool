//
//  Extension_NYSqliteTool.swift
//  NYSqliteTool_Tests
//
//  Created by qyning on 2018/9/30.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import CTMediator


// 模块名称
let NYSqliteModuleName = "NYSqlite"
// 数据库创建表名接口
let NYSqliteCreateTable = "createTable"
// 数据库插入数据
let NYSqliteInsertData = "insertData"
// 数据库数据更新
let NYSqliteUpdataData = "updataData"
// 数据库数据删除
let NYSqliteDeleteData = "deleteData"
// 数据库数据查询
let NYSqliteFetchData = "fetchData"
// 删除数据库表
let NYSqliteDeleteTable = "deleteTable"
// 升级数据库表字段
let NYSqliteCheckUpdateTableWithNewColumnName = "checkUpdateTableWithNewColumnName"
// 批量操作增删改
let NYSqliteQueueInDatabase = "queueInDatabase"
// 日志开关
let NYlogOpen = "logOpen"

public extension CTMediator {
    
    
    /// 创建表名称接口
    ///
    /// - Parameters:
    ///   - tableName: 创建的表名
    ///   - sqlDataModel: 模型or字典
    /// - return: 创建表是否成功
    @objc public func SQL_createTable(tableName: String, sqlDataModel: Any) -> Bool {
        let params = [
            kCTMediatorParamsKeySwiftTargetModuleName: NYSqliteModuleName,
            "tableName": tableName,
            "sqlDataModel": sqlDataModel
            ] as [AnyHashable: Any]
        
        return performTarget(NYSqliteModuleName, action: NYSqliteCreateTable, params: params, shouldCacheTarget: false) as? Bool ?? false
    }
    
    /// 插入数据到表中
    ///
    /// - Parameters:
    ///   - tableName: 插入数据库的表名
    ///   - sqlDataModel: 模型or字典
    /// - return: 插入数据是否成功
    
    @objc public func SQL_insertData(tableName: String, sqlDataModel: Any) -> Bool {
        let params = [
            kCTMediatorParamsKeySwiftTargetModuleName: NYSqliteModuleName,
            "tableName": tableName,
            "sqlDataModel": sqlDataModel] as [AnyHashable: Any]
        
        return performTarget(NYSqliteModuleName, action: NYSqliteInsertData, params: params, shouldCacheTarget: false) as? Bool ?? false
    }
    
    /// 更新数据库中的数据
    ///
    /// - Parameters:
    ///   - tableName: 更新数据库的表名
    ///   - sqlDataModel: 模型or字典
    ///   - whereCondition: 更新指定数据的条件
    /// - return: 更新数据是否成功
    
    @objc public func SQL_updataData(tableName: String, sqlDataModel: Any, whereCondition: String) -> Bool {
        let params = [
            kCTMediatorParamsKeySwiftTargetModuleName: NYSqliteModuleName,
            "tableName": tableName,
            "sqlDataModel": sqlDataModel,
            "whereCondition": whereCondition] as [AnyHashable: Any]
        
        return performTarget(NYSqliteModuleName, action: NYSqliteUpdataData, params: params, shouldCacheTarget: false) as? Bool ?? false
    }
    
    /// 删除数据库中的数据(可以删除所有数据)
    ///
    /// - Parameters:
    ///   - tableName: 删除数据库的表名
    ///   - whereCondition: 删除指定数据的条件
    /// - return: 删除数据是否成功
    
    @objc public func SQL_deleteData(tableName: String, whereCondition: String) -> Bool {
        let params = [
            kCTMediatorParamsKeySwiftTargetModuleName: NYSqliteModuleName,
            "tableName": tableName,
            "whereCondition": whereCondition] as [AnyHashable: Any]
        
        return performTarget(NYSqliteModuleName, action: NYSqliteDeleteData, params: params, shouldCacheTarget: false) as? Bool ?? false
    }
    
    /// 获取指定表中指定的数据(包含所有数据)
    ///
    /// - Parameters:
    ///   - tableName: 获取数据的表名
    ///   - whereCondition: 获取数据的条件
    /// - return: 指定数据的集合
    
    @objc public func SQL_fetchAllData(tableName: String, whereCondition: String) -> Any {
        let params = [
            kCTMediatorParamsKeySwiftTargetModuleName: NYSqliteModuleName,
            "tableName": tableName,
            "whereCondition": whereCondition] as [AnyHashable: Any]
        
        return performTarget(NYSqliteModuleName, action: NYSqliteFetchData, params: params, shouldCacheTarget: false)
    }
    
    /// 删除表
    ///
    /// - Parameter tableName: 删除表的表名
    /// - return: 删除表是否成功
    @objc public func SQL_deleteTable(tableName: String) -> Bool{
        let params = [
            kCTMediatorParamsKeySwiftTargetModuleName: NYSqliteModuleName,
            "tableName": tableName] as [AnyHashable: Any]
        
        return performTarget(NYSqliteModuleName, action: NYSqliteDeleteTable, params: params, shouldCacheTarget: false) as? Bool ?? false
    }
    
    
    /// 数据库升级添加需要添加新的字段
    /// 对比表的字段添加新字段
    /// - Parameters:
    ///   - tableName: 表名
    ///   - sqlDataModel: 模型or字典
    /// - Returns: 添加成功
    @objc public func SQL_checkUpdateTableWithNewColumnName(tableName: String, sqlDataModel: Any) -> Bool {
        let params = [
            kCTMediatorParamsKeySwiftTargetModuleName: NYSqliteModuleName,
            "tableName": tableName,
            "sqlDataModel": sqlDataModel] as [AnyHashable: Any]
        
        return performTarget(NYSqliteModuleName, action: NYSqliteCheckUpdateTableWithNewColumnName, params: params, shouldCacheTarget: false) as? Bool ?? false
    }
    
    /// 批量操作增删改
    /// 使用 FMDatabaseQueue 线程安全 注意（block回调里面不能再嵌套数据库操作增删改查）
    /// - Parameters:
    ///   - tableName: 表名
    ///   - sqlDataModels: 模型or字典的数组
    ///   - whereConditions: 条件
    ///   - sqlTypes: 每一个操作数组
    ///   - useTransaction: 是否开启事务
    ///   - block: 操作结果
    @objc public func SQL_queueInDatabase(tableName: String, sqlDataModels: Any, whereConditions:[String], sqlTypes:[Int], useTransaction:Bool, block:@escaping (Bool) -> Void){
        
        var paramsArr = [[String:Any]]()
        if let models = sqlDataModels as? [Any]{
            for i in 0..<models.count{
                let whereCondition = whereConditions[i]
                let sqlType = sqlTypes[i]
                let sqlDataModel = models[i]
                let param = [
                    "tableName": tableName,
                    "sqlDataModel": sqlDataModel,
                    "whereCondition": whereCondition,
                    "sqlType":sqlType] as [String: Any]
                paramsArr.append(param)
            }
        }
        let params = [
            kCTMediatorParamsKeySwiftTargetModuleName: NYSqliteModuleName,
            "tableName": tableName,
            "sqlDataModelArr": paramsArr,
            "useTransaction":useTransaction,
            "block":block] as [AnyHashable: Any]
        
        performTarget(NYSqliteModuleName, action: NYSqliteQueueInDatabase, params: params, shouldCacheTarget: false)
    }
    
    ///是否打印日志
    @objc public func SQL_logOpen(isOpen:Bool){
        let params = [
            kCTMediatorParamsKeySwiftTargetModuleName: NYSqliteModuleName,
            "isOpen": isOpen
            ] as [AnyHashable: Any]
        
        performTarget(NYSqliteModuleName, action: NYlogOpen, params: params, shouldCacheTarget: false)
    }
}
