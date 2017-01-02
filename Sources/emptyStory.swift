//
//  emptyStory.swift
//  skyrealman's blog
//
//  Created by sz on 2016-11-06.
//
//

import PerfectMustache
import PerfectHTTP

func emptyStory(_ webRoot: String, request: HTTPRequest, response: HTTPResponse) {
	mustacheRequest(
		request: request, response: response,
		handler: emptyStoryHandler(),
		templatePath: webRoot + "/emptyStory.mustache"
	)

}

struct emptyStoryHandler: MustachePageHandler {

	func extendValuesForResponse(context contxt: MustacheWebEvaluationContext, collector: MustacheEvaluationOutputCollector) {
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
