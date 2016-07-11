import Glibc

var resultSet: [[String: String]] = [[:]]
	
func callback(
    resultVoidPointer: UnsafeMutablePointer<Void>?, // void *NotUsed 
    columnCount: Int32, // int argc
    values:UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?, // char **argv     
    columns:UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>? // char **azColName
    ) -> CInt {
    var dic: [String:String] = [:]
	for  i in 0 ..< Int(columnCount) {
        guard let value = values?[i] 
        else { continue }
        guard let column = columns?[i] 
        else { continue }
		
		let strCol = String(cString:column) 
		let strVal = String(cString:value)
		
		dic[strCol] = strVal
        //print("\(strCol) = \(strVal)")
    }
	resultSet.append(dic)
    return 0 // status ok
}

func sqlQueryCallbackBasic(dbStr:String, query:String) -> Int {
    var db: OpaquePointer? 
    var zErrMsg:UnsafeMutablePointer<Int8>?
    var rc: Int32 = 0 // result code

    rc = sqlite3_open(dbStr, &db)
    if  rc != 0 {
        print("ERROR: sqlite3_open " + String(sqlite3_errmsg(db)) ?? "" )
		sqlite3_close(db)
        return 1
    }

    rc = sqlite3_exec(db, query, callback, nil, &zErrMsg)
    if rc != SQLITE_OK {
		let errorMsg = zErrMsg
        print("ERROR: sqlite3_exec \(errorMsg)")
        sqlite3_free(zErrMsg)
    }

    sqlite3_close(db)
    return 0
}
func sqlQueryClosureBasic(dbStr:String, query:String) -> Int {
    var db: OpaquePointer? 
    var zErrMsg:UnsafeMutablePointer<Int8>?
    var rc: Int32 = 0
	
    rc = sqlite3_open(dbStr, &db)
    if  rc != 0 {
        print("ERROR: sqlite3_open " + String(sqlite3_errmsg(db)) ?? "" )
        sqlite3_close(db)
        return 1
    }

    rc = sqlite3_exec(
        db,      // database 
        query, // statement
        {        // callback: non-capturing closure
            resultVoidPointer, columnCount, values, columns in
            var dic: [String:String] = [:]
			for i in 0 ..< Int(columnCount) {
				guard let value = values?[i]
                else { continue }
                guard let column = columns?[i]
                else { continue }
				
				let strCol = String(cString:column)
				let strVal = String(cString:value)
				
				dic[strCol] = strVal
    
				//print("\(strCol) = \(strVal)")
            }
			resultSet.append(dic)
            return 0
        }, 
        nil, 
        &zErrMsg
    )

    if rc != SQLITE_OK {
        let errorMsg = zErrMsg
        print("ERROR: sqlite3_exec \(errorMsg)")
        sqlite3_free(zErrMsg)
    }
    sqlite3_close(db)
    return 0
}


//sqlQueryClosureBasic(dbStr:"Sqlite_Test.db", query:"SELECT * FROM Employee")

sqlQueryCallbackBasic(dbStr:"Sqlite_Test.db", query:"SELECT * FROM Employee")


for row in resultSet {
	for (col, val) in row {
		print("\(col): \(val)")
	}
}











