//
//  Routes.swift
//  SkyRealMan
//
//  Created by SongZhen on 2016/11/26.
//
//

import PerfectHTTP
import PerfectMustache
import PerfectLib

public func makeRoutes() -> Routes {
    var routes = Routes()
    //首页
    routes.add(method: .get, uri: "/", handler: PageHandlers.makeHome)
    routes.add(method: .get, uri: "/list", handler: PageHandlers.makeYearList)
    //列表
    routes.add(method: .get, uris: ["/story","/story/{titleSanitized}","/story/{titleSanitized}/with/{keys}"], handler: PageHandlers.makeStoryQuery)
    routes.add(method: .get, uri: "/files/**", handler: {
        request, response in
        request.path = request.urlVariables[routeTrailingWildcardKey]!
        let handler = StaticFileHandler(documentRoot: server.documentRoot + "/img")
        handler.handleRequest(request: request, response: response)
    })
    routes.add(method: .get, uri: "/attachment/**", handler: {
        request, response in
        request.path = request.urlVariables[routeTrailingWildcardKey]!
        let handler = StaticFileHandler(documentRoot: Dir.workingDir.path + "/files/")
        handler.handleRequest(request: request, response: response)
    })
    routes.add(method: .post, uri: "/story/{titleSanitized}/comment", handler: PageHandlers.insertComment)
    routes.add(method: .get, uri: "/story/quote/{uniqueid}", handler: PageHandlers.quoteComment)
    routes.add(method: .get, uri: "/list/{tag}", handler: PageHandlers.makeCategoryList)
    routes.add(method: .get, uris: ["/search/{keys}", "/search/"], handler: PageHandlers.makeSearch)
    return routes
}
