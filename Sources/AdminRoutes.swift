//
//  AdminRoutes.swift
//  SkyRealMan
//
//  Created by SongZhen on 2016/11/26.
//
//

import PerfectHTTP
import PerfectTurnstileSQLite
import PerfectMustache

public func makeAdminRoutes() -> Routes{
    var routes = Routes()
    routes.add(method: .get, uri: "/admin/manage", handler: BlogAdmin.makeTag)
    
    routes.add(method: .get, uri: "/admin/prepare", handler: {
        request, response in
        response.render(template: "/admin/prepare")
    })
    routes.add(method: .post, uri: "/admin/prepare", handler: {
        request, response in
        guard let title = request.param(name: "title"), let body = request.param(name: "body"), !title.isEmpty, !body.isEmpty else{
            response.render(template: "admin/prepare", context: ["flash": "缺少标题或正文"])
            return
        }
        let dbHandler = DBOrm()
        dbHandler.setStory((title, body))
        response.redirect(path: "/story/\(title.transformToLatinStripDiacritics().slugify())")
    })
    routes.add(method: .get, uri: "/admin/check", handler: {
        request, response in
        response.setHeader(.contentType, value: "application/json")
        
        var resp = [String: String]()
        resp["authenticated"] = "AUTHED: \(request.user.authenticated)"
        resp["authDetails"] = "DETAILS: \(request.user.authDetails)"
        
        do {
            try response.setBody(json: resp)
        } catch {
            print(error)
        }
        response.completed()
    })
    routes.add(method: .get, uri: "/admin/login", handler: BlogAdmin.makeLogin)
    routes.add(method: .get, uri: "/admin/logout", handler: AuthHandlersWeb.logoutHandler)
    routes.add(method: .get, uri: "/admin/register", handler: BlogAdmin.makeRegister)
    
    return routes
}
