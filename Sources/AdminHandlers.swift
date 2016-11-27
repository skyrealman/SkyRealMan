//
//  BlogAdmin.swift
//  SkyRealMan
//
//  Created by SongZhen on 2016/11/26.
//
//

import PerfectHTTP
import StORM
import SQLiteStORM
import Foundation
public class BlogAdmin{
    open static func makeLogin(request: HTTPRequest, _ response: HTTPResponse){
        response.render(template: "login")
    }
    open static func makeRegister(request: HTTPRequest, _ response: HTTPResponse){
        response.render(template: "register")
    }
    open static func makeTag(request: HTTPRequest, _ response: HTTPResponse){
        response.setHeader(.contentType, value: "text/html")
        let category = request.param(name: "category") ?? ""
        if category.characters.count > 0 {
            let dbHandler = DBOrm()
            dbHandler.setCategory(category)
        }
        var ary = [Any]()
        let data = dbHandler.getCategory()
        for i in 0..<data.count{
            var thisPos = [String: String]()
            thisPos["name"] = data[i]["name"]
            ary.append(thisPos)
        }
        let context: [String: Any] = [
            "categories": ary,
            "year": Date().getYear() ?? 0
        ]
        
        response.render(template: "admin/manage", context: context)
        response.redirect(path: "/admin/manage")
    }
}
