//
//  main.swift
//  skyrealman's blog
//
//  Created by sz on 2016-11-06.
//
//
//
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectMustache
import StORM
import SQLiteStORM
import PerfectTurnstileSQLite
import PerfectLogger
import PerfectRequestLogger
import Foundation
// Create HTTP server.
let server = HTTPServer()

let pturnstile = TurnstilePerfectRealm()
LogFile.location = "./log.txt"
LogFile.info("==========服务器启动==========")

#if os(Linux)
    let fileRoot = "~/swift/skyrealman/"
    var httpPort = 8181
#else
    let fileRoot = ""
    var httpPort = 8181
    RequestLogFile.location = "./webLog.log"
#endif
LogFile.info("Http服务器端口: \(httpPort)")


var dbHandler = DBOrm()
dbHandler.create()
//dbHandler.populate()
dbHandler.auth()

//let apiRoute = "/api/v1/"

//let authWebRoutes = makeWebAuthRoutes()

server.addRoutes(makeRoutes())
server.addRoutes(makeAdminRoutes())
//server.addRoutes(authWebRoutes)

let httplogger = RequestLogger()

server.setRequestFilters([(httplogger, .high)])
server.setResponseFilters([(httplogger, .low)])

var authenticationConfig = AuthenticationConfig()
authenticationConfig.include("/admin/*")
authenticationConfig.exclude("/login")
authenticationConfig.exclude("/register")

server.documentRoot = "./webroot"

let authFilter = AuthFilter(authenticationConfig)

server.setRequestFilters([pturnstile.requestFilter])
server.setResponseFilters([pturnstile.responseFilter])
server.setResponseFilters([(Filter404(), .high)])
server.setRequestFilters([(authFilter, .high)])

server.serverPort = UInt16(httpPort)

do {
	try server.start()
} catch PerfectError.networkError(let err, let msg) {
	print("Network error thrown: \(err) \(msg)")
}
