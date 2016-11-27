//
//  Routes.swift
//  SkyRealMan
//
//  Created by SongZhen on 2016/11/26.
//
//

import PerfectHTTP
import PerfectMustache


public func makeRoutes() -> Routes {
    var routes = Routes()
    //首页
    routes.add(method: .get, uri: "/index", handler: PageHandlers.makeHome)
    //列表
    routes.add(method: .get, uris: ["/story","/story/{titleSanitized}"], handler: PageHandlers.makeStory)
    

    return routes
}
