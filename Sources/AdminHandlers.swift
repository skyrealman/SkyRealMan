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
    
    open static func makeTagGET(request: HTTPRequest, _ response: HTTPResponse){

        let dbHandler = DBOrm()
        let data = dbHandler.getCategory()

        let context: [String: Any] = [
            "categories": data,
            "year": Date().getYear() ?? 0,
            "accountID": request.user.authDetails?.account.uniqueID ?? "",
            "authenticated": request.user.authenticated
        ]
        response.render(template: "admin/manage", context: context)
    }
    
    open static func makeTagPOST(request: HTTPRequest, _ response: HTTPResponse){
        response.setHeader(.contentType, value: "text/html")
        let dbHandler = DBOrm()
        let data_f = dbHandler.getCategory()
        
        guard let category = request.param(name: "category"), category.trimmed() != "" else{
            let contxt: [String: Any] = [
                "categories": data_f,
                "flash": "标签名不能为空",
                "year": Date().getYear() ?? 0,
                "accountID": request.user.authDetails?.account.uniqueID ?? "",
                "authenticated": request.user.authenticated
            ]
            response.render(template: "admin/manage", context: contxt)
            return

        }
        
        if category.characters.count > 0 {
            dbHandler.setCategory(category)
        }
        let data = dbHandler.getCategory()

        let context: [String: Any] = [
            "categories": data,
            "year": Date().getYear() ?? 0,
            "accountID": request.user.authDetails?.account.uniqueID ?? "",
            "authenticated": request.user.authenticated

        ]
        
        response.render(template: "admin/manage", context: context)
    }
    
    open static func makeStoryInsertGET(request: HTTPRequest, _ response: HTTPResponse){
        let dbHandler = DBOrm()
        let tags = dbHandler.getCategory()
        let context: [String: Any] = [
            "accountID": request.user.authDetails?.account.uniqueID ?? "",
            "authenticated": request.user.authenticated,
            "year": Date().getYear() ?? 0,
            "tags": tags
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
