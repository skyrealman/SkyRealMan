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
    routes.add(method: .get, uri: "/admin/manage", handler: BlogAdmin.makeTagGET)
    routes.add(method: .post, uri: "/admin/manage", handler: BlogAdmin.makeTagPOST)
    routes.add(method: .get, uri: "/admin/prepare", handler: BlogAdmin.makeStoryInsertGET)
    routes.add(method: .post, uri: "/admin/prepare", handler: BlogAdmin.makeStoryInsertPOST)
    routes.add(method: .get, uri: "/admin/prepare/edit/{title}", handler: BlogAdmin.editStory)
    routes.add(method: .get, uri: "/admin/manage/tag/{page}", handler: BlogAdmin.makeTagGET)
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
    
    routes.add(method: .get, uri: "/login", handler: BlogAdmin.makeLoginGET)
    routes.add(method: .post, uri: "/login", handler: BlogAdmin.makeLoginPOST)
    
    routes.add(method: .get, uri: "/logout", handler: AuthHandlersWeb.logoutHandler)
    
    routes.add(method: .get, uri: "/register", handler: BlogAdmin.makeRegisterGET)
    routes.add(method: .post, uri: "/register", handler: BlogAdmin.makeRegisterPOST)
    routes.add(method: .get, uri: "/admin/manage/delete/{tag}", handler: BlogAdmin.deleteTag)
    routes.add(method: .get, uris: ["/admin/manage/edit/{oldtag}/{newtag}","/admin/manage/edit/{oldtag}/"], handler: BlogAdmin.editTag)
    routes.add(method: .get, uri: "/admin/storymanage", handler: BlogAdmin.makeManageList)
    routes.add(method: .get, uri: "/admin/storymanage/story/{page}", handler: BlogAdmin.makeManageList)
    return routes
}
