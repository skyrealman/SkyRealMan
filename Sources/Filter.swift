//
//  Filter.swift
//  SkyRealMan
//
//  Created by SongZhen on 2016/12/9.
//
//

import PerfectHTTP
import Foundation
import PerfectMustache
struct OtherFilter: HTTPResponseFilter{
    func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()){
        
        callback(.continue)
    }
    func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()){

        callback(.continue)
    }
}
struct Filter404: HTTPResponseFilter {
    func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()){
        callback(.continue)
    }
    func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()){
        if case .notFound = response.status{
            response.setBody(string: "")
            response.render(template: "notfound", context: ["error": response.status.description,
                "accountID": response.request.user.authDetails?.account.uniqueID ?? "",
                "authenticated": response.request.user.authenticated
                ])
            response.setHeader(.contentLength, value: "\(response.bodyBytes.count)")
            callback(.done)
        }else{
            callback(.continue)
        }
    }
}
