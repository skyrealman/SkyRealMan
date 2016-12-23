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
    public var visitor: String = ""
    public var email: String = ""
    public var cposttime: String = ""
    public var cbody: String = ""
    public var blogid: Int = 0
    override open func table() -> String {
        return "comment"
    }
    override open func to(_ this: StORMRow) {
        uniqueID = this.data["uniqueID"] as! String
        visitor = this.data["visitor"] as! String
        email = this.data["email"] as! String
        cposttime = this.data["cposttime"] as! String
        cbody = this.data["cbody"] as! String
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
           try sqlExec("CREATE TABLE IF NOT EXISTS comment(uniqueID TEXT PRIMARY KEY NOT NULL, visitor TEXT, email TEXT, cposttime TEXT, cbody TEXT, blogid INTEGER)")
        }catch{
            print(error)

        }
    }
}
