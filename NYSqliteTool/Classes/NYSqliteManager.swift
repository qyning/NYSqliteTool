//
//  NYSqliteManager.swift
//  NYSqliteTool_Tests
//
//  Created by qyning on 2018/9/30.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import FMDB


public class NYSqliteManager {

    // MARK:- 单例
    static let instance = NYSqliteManager()
    static func share() -> NYSqliteManager {
        return instance
    }
    
    var db:FMDatabase!
    var queue:FMDatabaseQueue!
    var logState = false
    
    // MARK:- 启动数据库
    public init() {
        let dbName = "NYSqlite.db"
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        path = (path as NSString).appendingPathComponent(dbName)
        NYPrint("数据库的路径 " + path)
        db = FMDatabase(path: path)
        queue = FMDatabaseQueue(path: path)
        if db.open(){
            NYPrint("打开数据库成功")
        }
    }
    
    // MARK:- 增
    public func createTable(_ params: Dictionary<String, Any>) -> Bool{
        return executeUpdateWithDB(db, createTableSQL(params))
    }
    
    // MARK:- 改
    /// 插入数据
    public func insertData(_ params: Dictionary<String, Any> ) -> Bool {
        return executeUpdateWithDB(db, insertSQL(params))
    }
    
    /// 更新数据
    public func updataData(_ params: Dictionary<String, Any> ) -> Bool{
        return executeUpdateWithDB(db, updataSQL(params))
    }
    
    // MARK:-  删
    /// 删除数据
    public func deleteData(_ params: Dictionary<String, Any> ) -> Bool {
        return executeUpdateWithDB(db, deleteSQL(params))
    }
    
    //  删除表
    public func deleteTable(_ params: Dictionary<String, Any> ) -> Bool {
        return executeUpdateWithDB(db, deleteTableSQL(params))
    }
    
    /// 数据库升级添加需要添加新的字段
    public func checkUpdateTableWithNewColumnName(_ params: Dictionary<String, Any> ) -> Bool {
        return executeUpdateWithDB(db, addNewColumnName(params))
    }
    
    public func logIsOpen(_ params: Dictionary<String, Any>) {
        if let open = params["isOpen"] as? Bool{
            logState = open
        }
    }
    
    // MARK:-  查
    /// 获取查询数据
    public func fetchData(_ params: Dictionary<String, Any>) -> Any?{
        
        let tableName = params["tableName"] as! String
        let whereCondition = params["whereCondition"] as! String
        let sql = "SELECT * FROM \(tableName) \(whereCondition)"
        var result = [Any]()
        var sqlkeys = [String]()
        NYPrint("方法：\(#function)->\(#line)行：查询数据:sql=\(sql) \n")
        if let set = try? db.executeQuery(sql, values: nil) {
            for j in 0..<set.columnCount{
                if let columnName = set.columnName(for: j){
                    if columnName != "ID"{ sqlkeys.append(columnName) }
                }
            }
            while set.next() {
                let dict = NSMutableDictionary()
                for i in 0..<sqlkeys.count{
                    let key = sqlkeys[i]
                    if let value = set.string(forColumn: key){
                        dict.setValue(value, forKey: key)
                    }else{
                        dict.setValue("", forKey: key)
                    }
                }
                result.append(dict)
            }
            return result
        }
        return result
    }
    
    /// 查询是否存在
    public func searchData(_ params: Dictionary<String, Any> ) -> Bool{
        let tableName = params["tableName"] as! String
        let whereCondition = params["whereCondition"] as! String
        let sql = "SELECT * FROM \(tableName) \(whereCondition)"
        NYPrint("方法：\(#function)->\(#line)行：查询数据:sql=\(sql) \n")
        if let set = try? db.executeQuery(sql, values: nil) {
            while set.next() {
                return true
            }
        }
        return false
    }
    
    /// 批量操作增删改
    func QueueInDatabase(_ params: Dictionary<String, Any>) {
        
        if  let sqlDataModelArr = params["sqlDataModelArr"] as? [[String:Any]], let useTransaction = params["useTransaction"] as? Bool, let block = params["block"] as? ReturnBoolClosure{
            
            QueueInDatabaseWithParams(paramsArr: sqlDataModelArr, useTransaction: useTransaction, block: block)
        }
    }
    
    /// 批量操作增删改
    ///
    /// - Parameters:
    ///   - paramsArr: 模型或者字典的参数
    ///   - sqlTypes: 模型或者字典对应的操作入插入，删除，更新
    ///   - useTransaction: 是否开启事务
    ///   - block: 结果返回
    func QueueInDatabaseWithParams(paramsArr:[[String:Any]],
                                   useTransaction:Bool,
                                   block:ReturnBoolClosure){
        
        var sqls = QueueInDatabaseSQLs(paramsArr: paramsArr)
        var success = true
        if useTransaction{
            queue.inTransaction { (DB, rollback) in
                for i in 0..<sqls.count{
                    success = executeUpdateWithDB(DB, sqls[i])
                    if !success{
                        rollback.pointee = true
                        NYPrint("方法：\(#function)->\(#line)行：打印:数据库操作失败，事务回滚 sql=\(sqls[i])")
                        block(false)
                        break
                    }
                    if i == sqls.count - 1 && success == true{
                        block(success)
                    }
                }
            }
        } else {
            queue.inDatabase { (DB) in
                for i in 0..<sqls.count{
                    success = executeUpdateWithDB(DB, sqls[i])
                    if !success{
                        NYPrint("方法：\(#function)->\(#line)行：打印:数据库操作失败，事务回滚 sql=\(sqls[i])")
                        block(false)
                        break
                    }
                    if i == sqls.count-1 && success == true{
                        block(success)
                    }
                }
            }
        }
    }
    
}

// MARK:- 拼接SQL参数 executeUpdate
public extension NYSqliteManager {
    
    // MARK:- DB.executeUpdate
    public func executeUpdateWithDB(_ Database:FMDatabase, _ sql:String) -> Bool{
        if sql.count < 1 {
            NYPrint("方法：\(#function)->\(#line)行：操作数据库:sql=nil")
            return false
        }
        if let _ = try? Database.executeUpdate(sql, values: nil){
            NYPrint("方法：\(#function)->\(#line)行：操作数据库: sql=\(sql) 成功 \n ")
            return true
        }
        NYPrint("方法：\(#function)->\(#line)行：操作数据库: sql=\(sql) 失败 \n")
        return false
    }
    
    // MARK:-拼接SQL
    public func createTableSQL(_ params: Dictionary<String, Any>) -> String {
        let tableName = params["tableName"] as! String
        var sql = "CREATE TABLE IF NOT EXISTS \(tableName) (ID INTEGER PRIMARY KEY AUTOINCREMENT"
        var sqlkeys = [String]()
        if let dict = params["sqlDataModel"] as? [String:Any] {
            for (key,_) in dict{
                sqlkeys.append("\(key) TEXT")
            }
        }else if let model = params["sqlDataModel"] as? NSObject {
            let mirror = Mirror(reflecting: model)
            for case let (key1,_) in mirror.children {
                guard let key = key1 else{
                    break
                }
                sqlkeys.append("\(key) TEXT")
            }
        }
        let key = sqlkeys.joined(separator: ",")
        if key.count>1 {
            sql += "," + key + ")" // 拼接spl
        }else{
            sql += ")" // 拼接spl
        }
        return sql
    }
    
    public func insertSQL(_ params: Dictionary<String, Any> ) -> String {
        let tableName = params["tableName"] as! String
        
        var sqlkeys = [String]()
        var sqlValues = [String]()
        
        if let dict = params["sqlDataModel"] as? [String:Any] {
            for (key,value) in dict{
                sqlkeys.append("\(key)")
                sqlValues.append("'\(value)'")
            }
        } else if let model = params["sqlDataModel"] as? NSObject {
            let mirror = Mirror(reflecting: model)
            for case let (key1,keyValue) in mirror.children {
                guard let key = key1 else{
                    break
                }
                if let value = keyValue as? String {
                    sqlkeys.append("\(key)")
                    sqlValues.append("'\(value)'")
                }else if let value = keyValue as? Int{
                    sqlkeys.append("\(key)")
                    sqlValues.append("'\(value)'")
                }else if let value = keyValue as? Double{
                    sqlkeys.append("\(key)")
                    sqlValues.append("'\(value)'")
                }else if let value = keyValue as? Float{
                    sqlkeys.append("\(key)")
                    sqlValues.append("'\(value)'")
                }else if let value = keyValue as? Bool{
                    sqlkeys.append("\(key)")
                    sqlValues.append("'\(value)'")
                }else{
                    sqlkeys.append("\(key)")
                    sqlValues.append("'\("")'")
                    NYPrint("方法：\(#function)->\(#line)行：不支持插入的类型键值：\(key):\(keyValue)")
                }
            }
        }
        if sqlkeys.count == 0 || sqlValues.count == 0 {
            NYPrint("方法：\(#function)->\(#line)行：打印:插入数据库:\(tableName)失败 \n sql=\( params["sqlDataModel"] ?? "不能解析model")")
            return ""
        }
        let sql = "INSERT INTO \(tableName) (\(sqlkeys.joined(separator: ","))) VALUES (\(sqlValues.joined(separator: ",")))"
        
        return sql
    }
    
    public func updataSQL(_ params: Dictionary<String, Any> ) -> String{
        
        let tableName = params["tableName"] as! String
        let whereCondition = params["whereCondition"] as! String
        
        var sqlkeys = [String]()
        
        if let dict = params["sqlDataModel"] as? [String:Any] {
            for (key,value) in dict{
                sqlkeys.append("\(key) = '\(value)'")
            }
        }else if let model = params["sqlDataModel"] as? NSObject {
            let mirror = Mirror(reflecting: model)
            for case let (key1,keyValue) in mirror.children {
                guard let key = key1 else{
                    break
                }
                if let value = keyValue as? String{
                    sqlkeys.append("\(key) = '\(value)'")
                }else if let value = keyValue as? Int{
                    sqlkeys.append("\(key) = '\(value)'")
                }else if let value = keyValue as? Double{
                    sqlkeys.append("\(key) = '\(value)'")
                }else if let value = keyValue as? Float{
                    sqlkeys.append("\(key) = '\(value)'")
                }else if let value = keyValue as? Bool{
                    sqlkeys.append("\(key) = '\(value)'")
                }else{
                    sqlkeys.append("\(key) = '\("")'")
                    NYPrint("方法：\(#function)->\(#line)行：不支持更新的类型键值：\(key):\(keyValue)")
                }
            }
        }
        
        if sqlkeys.count == 0{
            NYPrint("方法：\(#function)->\(#line)行：打印:更新数据库:\(tableName)失败 \n sql=\( params["sqlDataModel"] ?? "不能解析model")")
            return ""
        }
        let sql = "UPDATE \(tableName) SET  \(sqlkeys.joined(separator: ",")) \(whereCondition)"
        return sql
    }
    
    public func deleteSQL(_ params: Dictionary<String, Any> ) -> String {
        let tableName = params["tableName"] as! String
        let whereCondition = params["whereCondition"] as! String
        let sql = "DELETE FROM \(tableName) \(whereCondition)"
        return sql
    }
    
    public func deleteTableSQL(_ params: Dictionary<String, Any>) -> String {
        let tableName = params["tableName"] as! String
        let sql = "DROP TABLE IF EXISTS \(tableName)"
        return sql
    }
    
    public func QueueInDatabaseSQLs(paramsArr:[[String:Any]]) -> [String] {
        var sqls = [String]()
        for i in 0..<paramsArr.count{
            let params = paramsArr[i]
            let type = params["sqlType"] as! Int
            var sql = ""
            switch type {
            case sqlQueueType.Inset.rawValue:
                sql = updataSQL(params)
            case sqlQueueType.Update.rawValue:
                sql = updataSQL(params)
            case sqlQueueType.Delete.rawValue:
                sql = deleteSQL(params)
            default:
                break
            }
            //            if type == sqlQueueType.Inset.rawValue{
            //                sql = insertSQL(params)
            //            }else if type == sqlQueueType.Update.rawValue{
            //                sql = updataSQL(params)
            //            }else if type == sqlQueueType.Delete.rawValue{
            //                sql = deleteSQL(params)
            //            }
            sqls.append(sql)
        }
        return sqls
    }
    /// table增加字段
    public func addNewColumnName(_ params: Dictionary<String, Any> ) -> String {
        
        let tableName = params["tableName"] as! String
        if !db.tableExists(tableName){
            return ""
        }
        var sqlkeys = [String]()
        if let dict = params["sqlDataModel"] as? [String:Any] {
            for (key,_) in dict{
                sqlkeys.append(key)
            }
        }else if let model = params["sqlDataModel"] as? NSObject{
            let mirror = Mirror(reflecting: model)
            for case let (key1,_) in mirror.children {
                guard let key = key1 else{
                    break
                }
                sqlkeys.append(key)
            }
        }
        var addkeys = [String]()
        
        for columN in sqlkeys{
            if !db.columnExists(columN, inTableWithName: tableName){
                addkeys.append("\(columN) TEXT")
            }
        }
        
        if addkeys.count>0 {
            let Key = addkeys.joined(separator: "  ")
            return "ALTER TABLE \(tableName) ADD " + Key
        }else{
            return ""
        }
    }
    
    func NYPrint(_ str:String) {
        if logState {
            print("打印->\(#function)第\(#line)行：\n\(str)\n")
        }
    }
    
}

