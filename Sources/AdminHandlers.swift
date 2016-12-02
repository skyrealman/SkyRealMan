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

public class BlogAdmin{
    open static func makeLoginGET(request: HTTPRequest, _ response: HTTPResponse){
        let context = [
            "year": Date().getYear() ?? 0
        ]
        response.render(template: "login", context: context)
    }
    open static func makeLoginPOST(request: HTTPRequest, _ response: HTTPResponse){
        guard let username = request.param(name: "username"), let password = request.param(name: "password") else{
            response.render(template: "login", context: ["flash": "请输入用户名和密码"])
            return
        }
        let credentials = UsernamePassword(username: username, password: password)
        do {
            try request.user.login(credentials: credentials, persist: true)
            response.redirect(path: "/")
        }catch{
            response.render(template: "login", context: ["flash": "用户名或密码错误"])
        }
    }
    open static func makeRegisterGET(request: HTTPRequest, _ response: HTTPResponse){
        let context = [
            "year": Date().getYear() ?? 0
        ]
        response.render(template: "register", context: context)
    }
    open static func makeRegisterPOST(request: HTTPRequest, _ response: HTTPResponse){
        guard let username = request.param(name: "username"), let password = request.param(name: "password") else{
            response.render(template: "register", context: ["flash": "请输入用户名和密码"])
            return
        }
        let credentials = UsernamePassword(username: username, password: password)
        do{
            try request.user.register(credentials: credentials)
            try request.user.login(credentials: credentials, persist: true)
            response.redirect(path: "/")
        }catch let e as TurnstileError{
            response.render(template: "register", context: ["flash": e.description])
        }catch {
            response.render(template: "register", context: ["flash": "未知错误"])
        }
    }
    open static func makeLogout(request: HTTPRequest, _ response: HTTPResponse){
        request.user.logout()
        response.redirect(path: "/")
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
            "year": Date().getYear() ?? 0,
            "accountID": request.user.authDetails?.account.uniqueID ?? "",
            "authenticated": request.user.authenticated

        ]
        
        response.render(template: "admin/manage", context: context)
    }
    
    open static func makeStoryInsertGET(request: HTTPRequest, _ response: HTTPResponse){
        let context: [String: Any] = [
            "accountID": request.user.authDetails?.account.uniqueID ?? "",
            "authenticated": request.user.authenticated,
            "year":Date().getYear() ?? 0
        ]
        response.render(template: "admin/prepare", context: context)
    }
    open static func makeStoryInsertPOST(request: HTTPRequest, _ response: HTTPResponse){
        guard let title = request.param(name: "title"), let body = request.param(name: "body"), !title.isEmpty, !body.isEmpty else{
            response.render(template: "admin/prepare", context: ["flash": "请输入标题与正文"])
            return
        }
        let dbHandler = DBOrm()
        dbHandler.setStory((title, body))
        response.redirect(path: "/story/\(title.transformToLatinStripDiacritics().slugify())")
    }
}
