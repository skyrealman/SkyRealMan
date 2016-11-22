//
//  Handlers.swift
//  skyrealman's blog
//
//  Created by sz on 2016-11-06.
//
//

import PerfectLib
import SQLite
import PerfectHTTP
import PerfectMustache
import SwiftString

/*
	These are the main Mustache handlers.
	They are called as the handlers from the routes in main.swift
*/


struct ListHandler: MustachePageHandler { // all template handlers must inherit from PageHandler
	// This is the function which all handlers must impliment.
	// It is called by the system to allow the handler to return the set of values which will be used when populating the template.
	// - parameter context: The MustacheWebEvaluationContext which provides access to the HTTPRequest containing all the information pertaining to the request
	// - parameter collector: The MustacheEvaluationOutputCollector which can be used to adjust the template output. For example a `defaultEncodingFunc` could be installed to change how outgoing values are encoded.

	func extendValuesForResponse(context contxt: MustacheWebEvaluationContext, collector: MustacheEvaluationOutputCollector) {
		var values = MustacheEvaluationContext.MapType()
		var ary = [Any]()

		let dbHandler = DBOrm()
		let data = dbHandler.getList()

		for i in 0..<data.count {
			var thisPost = [String:String]()
			thisPost["title"] = data[i]["title"]
			thisPost["synopsis"] = data[i]["synopsis"]
			thisPost["titlesanitized"] = data[i]["title"]!.transformToLatinStripDiacritics().slugify()
			ary.append(thisPost)
		}
		values["posts"] = ary

		contxt.extendValues(with: values)
		do {
			try contxt.requestCompleted(withCollector: collector)
		} catch {
			let response = contxt.webResponse
			response.status = .internalServerError
			response.appendBody(string: "\(error)")
			response.completed()
		}
	}
}




struct StoryHandler: MustachePageHandler { // all template handlers must inherit from PageHandler
	// This is the function which all handlers must impliment.
	// It is called by the system to allow the handler to return the set of values which will be used when populating the template.
	// - parameter context: The MustacheWebEvaluationContext which provides access to the HTTPRequest containing all the information pertaining to the request
	// - parameter collector: The MustacheEvaluationOutputCollector which can be used to adjust the template output. For example a `defaultEncodingFunc` could be installed to change how outgoing values are encoded.

	func extendValuesForResponse(context contxt: MustacheWebEvaluationContext, collector: MustacheEvaluationOutputCollector) {
		var values = MustacheEvaluationContext.MapType()
		let request = contxt.webRequest
		let titleSanitized = request.urlVariables["titlesanitized"] ?? ""

		let dbHandler = DBOrm()
		let data = dbHandler.getStory(titleSanitized)

		if data["title"] == nil {
			values["title"] = "Error"
			values["body"] = "<p>No story found</p>"
            values["posttime"] = ""
		} else {
			values["title"] = data["title"]
			values["body"] = data["body"]
            values["posttime"] = data["posttime"]
            values["user_name"] = data["user_name"]
            values["category_name"] = data["category_name"]
		}

		contxt.extendValues(with: values)
		do {
			try contxt.requestCompleted(withCollector: collector)
		} catch {
			let response = contxt.webResponse
			response.status = .internalServerError
			response.appendBody(string: "\(error)")
			response.completed()
		}
	}
}

struct CategoryHandler: MustachePageHandler {
    func extendValuesForResponse(context contxt: MustacheWebEvaluationContext, collector: MustacheEvaluationOutputCollector) {
        var values = MustacheEvaluationContext.MapType()
        let request = contxt.webRequest
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
        values["categories"] = ary
        
        contxt.extendValues(with: values)
        do {
            try contxt.requestCompleted(withCollector: collector)
        } catch {
            let response = contxt.webResponse
            response.status = .internalServerError
            response.appendBody(string: "\(error)")
            response.completed()
        }
    }
}

