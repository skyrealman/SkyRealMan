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
        let data = dbHandler.getLatestFiveStories()
        let latest = dbHandler.getLatestStory()
        let tags = dbHandler.getCategory()
        if tags.count > 0{
            let context: [String: Any] = [
                "latest": latest,
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
        let comments = dbHandler.getComments(by: titleSanitized)
        let commentCount = dbHandler.getCommentCount(by: titleSanitized)
        if data["title"] == nil{
            context["title"] = "错误"
            context["body"] = "没有找到相关博客"
            context["posttime"] = ""
        }else {
            context["title"] = data["title"]
            context["titleSanitized"] = titleSanitized
            context["body"] = data["body"]
            context["posttime"] = data["posttime"]
            context["user_name"] = data["user_name"]
            context["category_name"] = data["category_name"]
            context["iscomment"] = data["iscomment"]
            context["istopped"] = data["istopped"]
            context["comments"] = comments["comments"]
            context["commentcount"] = commentCount
            context["readtimes"] = data["readtimes"]
        }
        context["accountID"] = request.user.authDetails?.account.uniqueID ?? ""
        context["authenticated"] = request.user.authenticated
        for key in request.scratchPad.keys {
            context[key] = request.scratchPad[key]
        }
        response.renderWithDate(template: "story", context: context)
    }
    
    open static func makeYearList(request: HTTPRequest, response: HTTPResponse){
        var context: [String: Any] = [String: Any]()
        let years: [String] = dbHandler.getBlogYears().reversed()
        let tags = dbHandler.getCategory()
        var contentDict: [Any] = [Any]()
        for year in years{
            var tmpDict = [String: Any]();
            let data = dbHandler.getListForYear(year: year)
            tmpDict["sign"] = year
            tmpDict["blog"] = data
            contentDict.append(tmpDict)
        }
        context["tags"] = tags
        context["data"] = contentDict
        context["accountID"] = request.user.authDetails?.account.uniqueID ?? ""
        context["authenticated"] = request.user.authenticated
        response.renderWithDate(template: "list", context: context)
    }
    open static func makeCategoryList(request: HTTPRequest, _ response: HTTPResponse){
        var context: [String: Any] = [String: Any]()
        let stag = request.urlVariables["tag"] ?? ""
        let storyArr = dbHandler.getListForCategory(tag: stag)
        let tags = dbHandler.getCategory()
        var contentDict: [String: Any] = [String: Any]()
        contentDict["sign"] = stag
        contentDict["blog"] = storyArr
        context["data"] = contentDict
        context["tags"] = tags
        context["accountID"] = request.user.authDetails?.account.uniqueID ?? ""
        context["authenticated"] = request.user.authenticated
        response.renderWithDate(template: "list", context: context)
    }
    open static func insertComment(request: HTTPRequest, _ response: HTTPResponse){
        let titleSanitized = request.urlVariables["titlesanitized"] ?? ""
        let visitor = request.param(name: "visitor") ?? ""
        let email = request.param(name: "email") ?? ""
        let cbody = request.param(name: "cbody") ?? ""
        guard visitor != "", email != "", cbody != "" else{
            response.request.scratchPad["flash"] = "请输入评论的必要字段"
            makeStoryQuery(request: request, response)
            return
        }
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date) as String
        dbHandler.setComment(comment: (visitor: visitor, email: email, cposttime: strNowTime, cbody: cbody, titleSanitized: titleSanitized, uniqueID: UUID().string))
        response.redirect(path: "/story/\(titleSanitized)")
    }
    open static func quoteComment(request: HTTPRequest, _ response: HTTPResponse){
        let uniqueID = request.urlVariables["uniqueid"] ?? ""
        let context = dbHandler.getComment(by: uniqueID)
        response.setHeader(.contentType, value: "application/json")
        do{
            try response.setBody(json: context)
        }catch{
            print(error)
        }
        response.completed()
    }
    open static func makeSearch(request: HTTPRequest, _ response: HTTPResponse){
        response.setHeader(.contentType, value: "application/json")
        let keyWords = request.urlVariables["keys"] ?? ""
        print(keyWords)
        let keyArr = keyWords.components(separatedBy: "&")
        let keyArrWithoutBlank = keyArr.filter{$0 != ""}
        if keyArrWithoutBlank.count > 2{
            response.renderWithDate(template: "list", context: ["flash": "请输入不超过两个关键字搜索"])
            return 
        }
        let tmp = dbHandler.getSearchResult(by: keyArrWithoutBlank)
        let context: [String: Any] = ["results": tmp]
        do{
            try response.setBody(json: context)
        }catch{
            print("search error: \(error)")
        }
        response.completed()
    }
}
