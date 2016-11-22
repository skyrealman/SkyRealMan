//
//  main.swift
//  skyrealman's blog
//
//  Created by sz on 2016-11-06.
//
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectMustache
import StORM
import SQLiteStORM
import PerfectTurnstileSQLite

// Create HTTP server.
let server = HTTPServer()

let pturnstile = TurnstilePerfectRealm()

var dbHandler = DBOrm()
dbHandler.create()
dbHandler.populate()
dbHandler.auth()


let authWebRoutes = makeWebAuthRoutes()
let authJSONRoutes = makeJSONAuthRoutes("/api/v1")
server.addRoutes(authWebRoutes)
server.addRoutes(authJSONRoutes)

var authenticationConfig = AuthenticationConfig()
authenticationConfig.exclude("/api/v1/login")
authenticationConfig.exclude("/api/v1/register")

// Set the webroot directory so static files such as the logo, can be served
server.documentRoot = "./webroot"

// Create the container variable for routes to be added to.
var routes = Routes()

// setting up the database at runtime


// Adding a route to handle the root list
routes.add(method: .get, uri: "/", handler: {
	request, response in

	// Setting the response content type explicitly to text/html
	response.setHeader(.contentType, value: "text/html")
	// Setting the body response to the generated list via Mustache
	mustacheRequest(
		request: request,
		response: response,
		handler: ListHandler(),
		templatePath: request.documentRoot + "/index.mustache"
	)
	// Signalling that the request is completed
	response.completed()
	}
)

// Serve a story
routes.add(method: .get, uris: ["/story","/story/{titleSanitized}"], handler: {
	request, response in

	let titleSanitized = request.urlVariables["titlesanitized"] ?? ""

	// Setting the response content type explicitly to text/html
	response.setHeader(.contentType, value: "text/html")

	if titleSanitized.characters.count > 0 {
		// Setting the body response to the generated list via Mustache
		mustacheRequest(
			request: request,
			response: response,
			handler: StoryHandler(),
			templatePath: request.documentRoot + "/story.mustache"
		)
	} else {
		// Setting the body response to the generated list via Mustache
		emptyStory(request.documentRoot, request: request, response: response)
	}

	// Signalling that the request is completed
	response.completed()
	}
)
//add category
routes.add(method: .get, uri: "/manage", handler: {
    request, response in
    response.setHeader(.contentType, value: "text/html")
    mustacheRequest(
        request: request,
        response: response,
        handler: CategoryHandler(),
        templatePath: request.documentRoot + "/manage.mustache")

    response.completed()
})
routes.add(method: .get, uri: "/api/v1/check", handler: {
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
routes.add(method: .get, uri: "/prepare", handler: {
    request, response in
    response.render(template: "prepare")
})
routes.add(method: .post, uri: "/prepare", handler: {
    request, response in
    guard let title = request.param(name: "title"), let body = request.param(name: "body"), !title.isEmpty, !body.isEmpty else{
        response.render(template: "prepare", context: ["flash": "缺少标题或正文"])
        return
    }
    let dbHandler = DBOrm()
    dbHandler.setStory((title, body))
    response.redirect(path: "/story/\(title.transformToLatinStripDiacritics().slugify())")
})
server.addRoutes(routes)


let authFilter = AuthFilter(authenticationConfig)

server.setRequestFilters([pturnstile.requestFilter])
server.setResponseFilters([pturnstile.responseFilter])

server.setRequestFilters([(authFilter, .high)])

// Set a listen port of 8181
server.serverPort = 8181

do {
	// Launch the HTTP server.
	try server.start()
} catch PerfectError.networkError(let err, let msg) {
	print("Network error thrown: \(err) \(msg)")
}
