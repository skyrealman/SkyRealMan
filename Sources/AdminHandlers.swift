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
import TurnstilePerfect
import Turnstile
import TurnstileCrypto
import TurnstileWeb
import PerfectLogger
import PerfectMustache
public class BlogAdmin{
    open static func makeLoginGET(request: HTTPRequest, _ response: HTTPResponse){
        response.renderWithDate(template: "login")
    }
    
    open static func makeLoginPOST(request: HTTPRequest, _ response: HTTPResponse){
        guard let username = request.param(name: "username"), let password = request.param(name: "password") else{
            response.renderWithDate(template: "login", context: ["flash": "请输入用户名和密码"])
            return
        }
        let credentials = UsernamePassword(username: username, password: password)
        do {
            try request.user.login(credentials: credentials, persist: true)
            response.redirect(path: "/")
        }catch{
            response.renderWithDate(template: "login", context: ["flash": "用户名或密码错误"])
        }
    }
    
    open static func makeRegisterGET(request: HTTPRequest, _ response: HTTPResponse){
        response.renderWithDate(template: "register")
    }
    
    open static func makeRegisterPOST(request: HTTPRequest, _ response: HTTPResponse){
        guard let username = request.param(name: "username"), let password = request.param(name: "password") else{
            response.renderWithDate(template: "register", context: ["flash": "请输入用户名和密码"])
            return
        }
        let credentials = UsernamePassword(username: username, password: password)
        do{
            try request.user.register(credentials: credentials)
            try request.user.login(credentials: credentials, persist: true)
            response.redirect(path: "/")
        }catch let e as TurnstileError{
            response.renderWithDate(template: "register", context: ["flash": e.description])
        }catch {
            response.renderWithDate(template: "register", context: ["flash": "未知错误"])
        }
    }
    
    open static func makeLogout(request: HTTPRequest, _ response: HTTPResponse){
        request.user.logout()
        response.redirect(path: "/")
    }
    
    open static func makeTagGET(request: HTTPRequest, _ response: HTTPResponse){
        let page = request.urlVariables["page"] ?? "1"
        guard page.isNumeric() else{
            response.redirect(path: "/admin/manage")
            return
        }
        let categoryPageCount = dbHandler.getCategoryPageCount()
        let data = dbHandler.getCategoryByPage(page: page)

        let context: [String: Any] = [
            "count": dbHandler.getTagPageContext(),
            "previous": {(previous: String, context: MustacheEvaluationContext) -> String in
                return String(Int(page)! - 1 <= 0 ? 1 : Int(page)! - 1)
            },
            "next": {(next: String, context: MustacheEvaluationContext) -> String in
                return String(Int(page)! + 1 >= categoryPageCount ? categoryPageCount : Int(page)! + 1)
            },
            "categories": data,
            "accountID": request.user.authDetails?.account.uniqueID ?? "",
            "authenticated": request.user.authenticated
        ]
        response.renderWithDate(template: "admin/manage", context: context)
    }
    
    open static func makeTagPOST(request: HTTPRequest, _ response: HTTPResponse){
        response.setHeader(.contentType, value: "text/html")
        let page = "1"
        let categoryPageCount = dbHandler.getCategoryPageCount()
        var data = dbHandler.getCategoryByPage(page: page)
        guard let category = request.param(name: "category"), category.trimmed() != "" else{
            let contxt: [String: Any] = [
                "count": dbHandler.getTagPageContext(),
                "previous": {(previous: String, context: MustacheEvaluationContext) -> String in
                    return String(Int(page)! - 1 <= 0 ? 1 : Int(page)! - 1)
                },
                "next": {(next: String, context: MustacheEvaluationContext) -> String in
                    return String(Int(page)! + 1 >= categoryPageCount ? categoryPageCount : Int(page)! + 1)
                },
                "categories": data,
                "flash": "标签名不能为空",
                "accountID": request.user.authDetails?.account.uniqueID ?? "",
                "authenticated": request.user.authenticated
            ]
            response.renderWithDate(template: "admin/manage", context: contxt)
            return

        }
        guard !dbHandler.isCategoryExist(tag: category) else{
            let contxt: [String: Any] = [
                "count": dbHandler.getTagPageContext(),
                "categories": data,
                "flash": "标签名已经存在",
                "accountID": request.user.authDetails?.account.uniqueID ?? "",
                "authenticated": request.user.authenticated
            ]
            response.renderWithDate(template: "admin/manage", context: contxt)
            return
        }
        if category.characters.count > 0{
            dbHandler.setCategory(category)
        }
        data = dbHandler.getCategoryByPage(page: String(dbHandler.getCategoryPageCount()))

        let context: [String: Any] = [
            "count": dbHandler.getTagPageContext(),
            "categories": data,
            "accountID": request.user.authDetails?.account.uniqueID ?? "",
            "authenticated": request.user.authenticated

        ]
        
        response.renderWithDate(template: "admin/manage", context: context)
    }
    
    open static func makeStoryInsertGET(request: HTTPRequest, _ response: HTTPResponse){
        
        let tags = dbHandler.getCategory()
        let context: [String: Any] = [
            "accountID": request.user.authDetails?.account.uniqueID ?? "",
            "authenticated": request.user.authenticated,
            "tags": tags
        ]
        response.renderWithDate(template: "admin/prepare", context: context)
    }
    open static func makeStoryInsertPOST(request: HTTPRequest, _ response: HTTPResponse){
        guard let title = request.param(name: "title"), let body = request.param(name: "body"), !title.isEmpty, !body.isEmpty else{
            response.renderWithDate(template: "admin/prepare", context: ["flash": "请输入标题与正文"])
            return
        }
        dbHandler.setStory((title, body))
        response.redirect(path: "/story/\(title.transformToLatinStripDiacritics().slugify())")
    }
    open static func deleteTag(request: HTTPRequest, _ response: HTTPResponse){
        let rmTag = request.urlVariables["tag"] ?? ""
        dbHandler.deleteTag(tag: rmTag)
        response.redirect(path: "/admin/manage")
        
    }
    open static func makeManageList(request: HTTPRequest, _ response: HTTPResponse){
        let page = request.urlVariables["page"] ?? "1"
        guard page.isNumeric() else{
            response.renderWithDate(template: "admin/storymanage", context: ["flash": "页码不合法","count": dbHandler.getStoryPageContext()])
            return
        }
        let data = dbHandler.getListForManageByPage(page: page)
        let context: [String: Any] = [
            "count": dbHandler.getStoryPageContext(),
            "stories": data,
            "accountID": request.user.authDetails?.account.uniqueID ?? "",
            "authenticated": request.user.authenticated
        ]
        response.renderWithDate(template: "admin/storymanage", context: context)
    }
    open static func editTag(request: HTTPRequest, _ response: HTTPResponse){
        let tag = request.urlVariables["tag"] ?? ""
        guard tag != "" else{
            response.renderWithDate(template: "admin/manage", context: ["flash": "新的分类名不合法"])
            return
        }
        dbHandler.editTag(tag: tag)
        response.redirect(path: "/admin/manage")
    }
}
