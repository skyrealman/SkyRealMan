//
//  Category.swift
//  SkyRealMan
//
//  Created by SongZhen on 2016/11/14.
//
//

import StORM
import SQLiteStORM

open class Category: SQLiteStORM{
    public var id: Int = 0
    public var name: String = ""
    
    override open func table() -> String{
        return "category"
    }
    override open func to(_ this: StORMRow){
        id = this.data["id"] as? Int ?? 0
        name = this.data["name"] as? String ?? ""
    }
    
    func rows() -> [Category]{
        var rows = [Category]()
        for i in 0..<self.results.rows.count{
            let row = Category()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
    
    public func setup(){
        do{
            try sqlExec("CREATE TABLE IF NOT EXISTS category(id INTEGER PRIMARY KEY NOT NULL, name TEXT)")
        }catch{
            print(error)
        }
    }
    public func exists(_ tag: String) -> Bool {
        do{
            try select(whereclause: "name = :1", params: [tag], orderby: [], cursor: StORMCursor(limit: 1, offset: 0))
            if results.rows.count == 1{
                return true
            } else{
                return false
            }
        }catch{
            print("Exists error: \(error)")
            return false
        }
    }
}
