//
//  Attachment.swift
//  SkyRealMan
//
//  Created by skyrealman on 2016/12/26.
//
//

import StORM
import SQLiteStORM

open class Attachment: SQLiteStORM{
    public var uniqueID: String = ""
    public var oldName: String = ""
    public var fileSize: Int = 0
    public var blogid: Int = 0
    
    
    override open func table() -> String {
        return "attachment"
    }
    override open func to(_ this: StORMRow){
        uniqueID = this.data["uniqueID"] as! String
        oldName = this.data["oldname"] as! String
        fileSize = this.data["filesize"] as! Int
        blogid = this.data["blogid"] as! Int
    }
    func rows() -> [Attachment]{
        var rows = [Attachment]()
        for i in 0..<self.results.rows.count{
            let row = Attachment()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
    public func setup() {
        do{
            try sqlExec("CREATE TABLE IF NOT EXISTS attachment(uniqueID TEXT PRIMARY KEY NOT NULL, oldname TEXT, filesize INTEGER, blogid INTEGER)")
        }catch{
            print(error)
        }
    }
}
