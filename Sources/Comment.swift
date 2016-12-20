//
//  comment.swift
//  SkyRealMan
//
//  Created by SongZhen on 2016/12/20.
//
//

import StORM
import SQLiteStORM

open class Comment: SQLiteStORM{
    public var uniqueID: String = ""
    public var author: String = ""
    public var posttime: String = ""
    public var body: String = ""
    public var blogid: Int = 0
    override open func table() -> String {
        return "comment"
    }
    override open func to(_ this: StORMRow) {
        uniqueID = this.data["uniqueID"] as! String
        author = this.data["author"] as! String
        posttime = this.data["posttime"] as! String
        body = this.data["body"] as! String
        blogid = this.data["blogid"] as! Int
    }
    func rows() -> [Comment]{
        var rows = [Comment]()
        for i in 0..<self.results.rows.count{
            let row = Comment()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
    public func setup() {
        do{
           try sqlExec("CREATE TABLE IF NOT EXISTS comment(uniqueID TEXT PRIMARY KEY NOT NULL, author TEXT, posttime TEXT, body TEXT, blogid INTEGER)")
        }catch{
            print(error)

        }
    }
}
