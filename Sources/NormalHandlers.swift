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
        let data = dbHandler.getListForView()
        let tags = dbHandler.getCategory()

        if tags.count > 0{
            let context: [String: Any] = [
                "posts": data,
                "title": "地盒的博客",
                "accountID": request.user.authDetails?.account.uniqueID ?? "",
                "authenticated": request.user.authenticated,
                "tags": tags
            ]
            response.renderWithDate(template: "index", context: context)
        }else{
            response.renderWithDate(template: "index", context: ["flash": "没有配置分类", "accountID": request.user.authDetails?.account.uniqueID ?? "", "authenticated": request.user.authenticated])
        }
        
    }
    open static func makeStoryQuery(request: HTTPRequest, _ response: HTTPResponse){
        var context: [String: Any]  = [String: Any]()
        let titleSanitized = request.urlVariables["titlesanitized"] ?? ""
        let data = dbHandler.getStory(titleSanitized)
        print(data)
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
        response.renderWithDate(template: "story", context: context)
    }
    
    open static func makeYearList(request: HTTPRequest, response: HTTPResponse){
        var context: [String: Any] = [String: Any]()
        let years: [String] = dbHandler.getBlogYears()
        var contentDict: [String: Any] = [String: Any]()
        for year in years{
            let data = dbHandler.getListForYear(year: year)
            contentDict["year"] = year
            contentDict["blog"] = data
        }
        context["data"] = contentDict
        context["accountID"] = request.user.authDetails?.account.uniqueID ?? ""
        context["authenticated"] = request.user.authenticated
        response.renderWithDate(template: "list", context: context)
    }
}
