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
import PerfectLogger
import Foundation

public struct RenderHandler: MustachePageHandler{
    var context: [String: Any]
    public func extendValuesForResponse(context contxt: MustacheWebEvaluationContext, collector: MustacheEvaluationOutputCollector) {
        contxt.extendValues(with: context)
        let t: [String: Any] = ["year": Date().getYear() ?? 0, "webtitle": "天真男的博客"]
        contxt.extendValues(with: t)
        do{
            contxt.webResponse.setHeader(.contentType, value: "text/html")
            try contxt.requestCompleted(withCollector: collector)
        }catch{
            let response = contxt.webResponse
            response.status = .internalServerError
            response.appendBody(string: "\(error)")
            response.completed()
        }
    }
    public init(context: [String: Any] = [String: Any]()){
        self.context = context
    }
}

extension HTTPResponse {
    public func renderWithDate(template: String, context: [String: Any] = [String: Any]()){
        mustacheRequest(request: self.request, response: self, handler: RenderHandler(context: context), templatePath: request.documentRoot + "/views/\(template).mustache")
    }
}
