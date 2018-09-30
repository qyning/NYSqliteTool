import XCTest
//import NYSqliteTool

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
//    func myTest()  {
//
//        //        let person  = ["name": "xxxx", "age": 18,"age11": 18, "address": ["name": "xxxx", "age": 18, "address": "深圳高新奇xx"],"addressqq": "深圳高新奇xx"] as [String : Any]
//        //        let person1 = ["name": "xxxx", "age": 17, "address": "深圳高新奇xx","addressqq": "深圳高新奇xx"] as [String : Any]
//        //        let person2 = ["name": "xxxx", "age": 16, "address": "深圳高新奇xx","addressqq": "深圳高新奇xx"] as [String : Any]
//        //        let person3 = ["name": "xxxx", "age": 100, "address": "深圳高新奇xx","addressqq": "深圳高新奇xx"] as [String : Any]
//
//        let person  = PersonModel(Name: "xxxx", Age: 18, Address: "深圳高新奇xx")
//        let person1 = PersonModel(Name: "ssss", Age: 16, Address: "深圳高新奇sss")
//        let person2 = PersonModel(Name: "aaaa", Age: 17, Address: "深圳高新奇aaa")
//        let person3 = PersonModel(Name: "改变", Age: 100, Address: "改地址")
//
//        // 检查表是否增加字段
//        _ = CTMediator.sharedInstance()?.tq_checkUpdateTableWithNewColumnName(tableName: SQLTableName.person.rawValue, sqlDataModel: person)
//        // 创建表
//        _ = CTMediator.sharedInstance()?.tq_createTable(tableName: SQLTableName.person.rawValue, sqlDataModel: person)
//        _ = CTMediator.sharedInstance()?.tq_updataData(tableName: SQLTableName.person.rawValue, sqlDataModel: person2, whereCondition: "where age=16")
//        // 插入数据
//        _ = CTMediator.sharedInstance()?.tq_insertData(tableName: SQLTableName.person.rawValue, sqlDataModel: person)
//        _ = CTMediator.sharedInstance()?.tq_insertData(tableName: SQLTableName.person.rawValue, sqlDataModel: person1)
//        _ = CTMediator.sharedInstance()?.tq_insertData(tableName: SQLTableName.person.rawValue, sqlDataModel: person2)
//        _ = CTMediator.sharedInstance()?.tq_insertData(tableName: SQLTableName.person.rawValue, sqlDataModel: person3)
//        _ = CTMediator.sharedInstance()?.tq_insertData(tableName: SQLTableName.person.rawValue, sqlDataModel: person3)
//
//        // 查询数据
//        if let arr = CTMediator.sharedInstance()?.tq_fetchAllData(tableName: SQLTableName.person.rawValue, whereCondition: "where age=18") as? [Any]{
//            print("方法：\(#function)->\(#line)行：打印:查询数据=\(arr.count)")
//        }
//        // 更新数据
//        _ = CTMediator.sharedInstance()?.tq_updataData(tableName: SQLTableName.person.rawValue, sqlDataModel: person3, whereCondition: "where age=18")
//
//        // 查询数据
//        if let arr = CTMediator.sharedInstance()?.tq_fetchAllData(tableName: SQLTableName.person.rawValue, whereCondition: "where age=18") as? [Any]{
//            print("方法：\(#function)->\(#line)行：打印:查询数据=\(arr.count)")
//        }
//
//        // 查询数据
//        if let arr = CTMediator.sharedInstance()?.tq_fetchAllData(tableName: SQLTableName.person.rawValue, whereCondition: "where age>0") as? [Any]{
//            print("方法：\(#function)->\(#line)行：打印:查询数据=\(arr.count)")
//        }
//
//        // 删除数据
//        _ = CTMediator.sharedInstance()?.tq_deleteData(tableName: SQLTableName.person.rawValue, whereCondition: "where age=17")
//
//        // 查询数据
//        if let arr = CTMediator.sharedInstance()?.tq_fetchAllData(tableName: SQLTableName.person.rawValue, whereCondition: "where age>0") as? [Any]{
//            print("方法：\(#function)->\(#line)行：打印:查询数据=\(arr.count)")
//        }
//
//        // 异步批量操作
//        DispatchQueue.global().async {
//            CTMediator.sharedInstance()?.tq_queueInDatabase(tableName: SQLTableName.person.rawValue, sqlDataModels: [person,person1,person2,person3], whereConditions: ["","where age=18","where age=17",""], sqlTypes: [.Inset,.Update,.Delete,.Inset], useTransaction: true, block: { (success) in
//                print("方法：\(#function)->\(#line)行：打印: 批量操作 success=\(success)")
//            })
//        }
//
//        // 删除表
//        //        _ = CTMediator.sharedInstance()?.tq_deleteTable(tableName: SQLTableName.person.rawValue)
//
//    }
    
}

class PersonModel: NSObject {
    var name = ""
    var age = 0
    var address = ""
    //    var phone = ""
    //    var nickName = ""
    
    init(Name:String,Age:Int,Address:String) {
        self.name = Name
        self.age = Age
        self.address = Address
    }
}
