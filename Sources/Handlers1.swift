//
//  Handlers1.swift
//  SkyRealMan
//
//  Created by SongZhen on 2016/11/27.
//
//

import PerfectLib
import PerfectHTTP
import StORM
import SQLiteStORM
import SwiftString
import PerfectLogger
import Foundation

public class PageHandlers{
    open static func makeHome(request: HTTPRequest, _ response: HTTPResponse){
        var ary = [Any]()
        let dbHandler = DBOrm()
        let data = dbHandler.getList()
        
        for i in 0..<data.count {
            var thisPost = [String:String]()
            thisPost["title"] = data[i]["title"]
            thisPost["synopsis"] = data[i]["synopsis"]
            thisPost["titlesanitized"] = data[i]["title"]!.transformToLatinStripDiacritics().slugify()
            ary.append(thisPost)
        }

        let context: [String: Any] = [
            "posts": ary,
            "year": Date().getYear() ?? 0,
            "title": "天真男的日志",
            "accountID": request.user.authDetails?.account.uniqueID ?? "",
            "authenticated": request.user.authenticated
            ]
        response.render(template: "index", context: context)
    }
    open static func makeStoryQuery(request: HTTPRequest, _ response: HTTPResponse){
        var context: [String: Any]  = [String: Any]()
        let titleSanitized = request.urlVariables["titlesanitized"] ?? ""
        let dbHandler = DBOrm()
        let data = dbHandler.getStory(titleSanitized)
        if data["title"] == nil{
            context["title"] = "错误"
            context["body"] = "没有找到相关博客"
            context["posttime"] = ""
        }else {
            context["title"] = data["title"]
            context["body"] = data["body"]
            context["posttime"] = data["posttime"]
            context["user_name"] = data["user_name"]
            context["category_name"] = data["category_name"]
        }
        context["year"] = Date().getYear() ?? 0
        context["accountID"] = request.user.authDetails?.account.uniqueID ?? ""
        context["authenticated"] = request.user.authenticated
        response.render(template: "story", context: context)
    }

}
