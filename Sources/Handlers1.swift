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
import PerfectMustache
public class PageHandlers{
    open static func makeHome(request: HTTPRequest, _ response: HTTPResponse){
        let dbHandler = DBOrm()
        let data = dbHandler.getList()
        let tags = dbHandler.getCategory()

        if tags.count > 0{
            let context: [String: Any] = [
                "posts": data,
                "title": "天真男的日志",
                "accountID": request.user.authDetails?.account.uniqueID ?? "",
                "authenticated": request.user.authenticated,
                "tags": tags
            ]
            response.render(template: "index", context: context)
        }else{
            response.render(template: "index", context: ["flash": "没有配置分类"])
        }
        
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
        context["accountID"] = request.user.authDetails?.account.uniqueID ?? ""
        context["authenticated"] = request.user.authenticated
        response.render(template: "story", context: context)
    }
    
    open static func makeStoryListByYear(request: HTTPRequest, response: HTTPResponse){
        var context: [String: Any] = [String: Any]()
        let dbHandler = DBOrm()
        let years: [String] = dbHandler.getBlogYears()
        for year in years{
            let data = dbHandler.getStoryListForYear(year: year)
            context[year] = data
        }
        context["accountID"] = request.user.authDetails?.account.uniqueID ?? ""
        context["authenticated"] = request.user.authenticated
        response.render(template: "list", context: context)
    }
}
