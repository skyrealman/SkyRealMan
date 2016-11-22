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
    public var id: Int?
    public var name: String?
    
    override open func table() -> String{
        return "category"
    }
    override open func to(_ this: StORMRow){
        id = this.data["id"] as! Int?
        name = this.data["name"] as! String?
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
}
