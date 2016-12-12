//
//  Blog.swift
//  SkyRealMan
//
//  Created by SongZhen on 2016/11/12.
//
//

import StORM
import SQLiteStORM

open class Blog: SQLiteStORM{
    public var id: Int = 0
    public var title: String = ""
    public var titlesanitized: String = ""
    public var synopsis: String = ""
    public var body: String = ""
    public var posttime: String = ""
    public var authorid: String = ""
    public var categoryid: Int = 0
    public var readtimes: Int = 0
    
    override open func table() -> String{
        return "blog"
    }
    override open func to(_ this: StORMRow){
        title = this.data["title"] as? String ?? ""
        
        synopsis = this.data["synopsis"] as? String ?? ""
        titlesanitized = this.data["titlesanitized"] as? String ?? ""
        body = this.data["body"] as? String ?? ""
        posttime = this.data["posttime"] as? String ?? ""
        authorid = this.data["authorid"] as? String ?? ""
        categoryid = this.data["categoryid"] as? Int ?? 0
        readtimes = this.data["readtimes"] as? Int ?? 0
        id = this.data["id"] as? Int ?? 0
    }
    func rows() ->[Blog]{
        var rows = [Blog]()
        for i in 0..<self.results.rows.count{
            let row = Blog()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
    
    public func setup(){
        do{
            try sqlExec("CREATE TABLE IF NOT EXISTS blog (id INTEGER PRIMARY KEY NOT NULL, title TEXT, titlesanitized TEXT, synopsis TEXT, body TEXT, posttime TEXT, authorid TEXT REFERENCES users(uniqueID) ON DELETE CASCADE, categoryid INTEGER REFERENCES category(id) ON DELETE CASCADE, readtimes INTEGER)")
        }catch{
            print(error)
        }
    }
//    func make() throws{
//        print("IN MAKE")
//        do{
//            try create()
//        }catch{
//            print(error)
//        }
//    }
}
