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

struct DateHandler: MustachePageHandler{
    func extendValuesForResponse(context contxt: MustacheWebEvaluationContext, collector: MustacheEvaluationOutputCollector) {
        var values = MustacheEvaluationContext.MapType()
        values["year"] = Date().getYear() ?? 0
        contxt.extendValues(with: values)
        do{
            try contxt.requestCompleted(withCollector: collector)
        }catch{
            let response = contxt.webResponse
            response.status = .internalServerError
            response.appendBody(string: "\(error)")
            response.completed()
        }
    }
}

struct UploadHandler: MustachePageHandler{
    func extendValuesForResponse(context contxt: MustacheWebEvaluationContext, collector: MustacheEvaluationOutputCollector) {
        #if DEBUG
            print("UploadHandler got request")
        #endif
        var values = MustacheEvaluationContext.MapType()
        let request = contxt.webRequest
        if let uploads = request.postFileUploads, uploads.count > 0 {
            var ary = [[String: Any]]()
            for upload in uploads{
                ary.append([
                    "fieldName": upload.fieldName,
                    "contextType": upload.contentType,
                    "fileName": upload.fileName,
                    "fileSize": upload.fileSize,
                    "tmpFileName": upload.tmpFileName
                    ])
            }
            values["files"] = ary
            values["count"] = ary.count
        }
        let params = request.params()
        if params.count > 0{
            var ary = [[String: Any]]()
            
            for(name, value) in params{
                ary.append([
                    "paramName": name,
                    "paramValue": value
                    ])
            }
            values["params"] = ary
            values["paramsCount"] = ary.count
        }
        contxt.extendValues(with: values)
        do{
            try contxt.requestCompleted(withCollector: collector)
        }catch{
            let response = contxt.webResponse
            response.status = .internalServerError
            response.appendBody(string: "\(error)")
            response.completed()
        }
    }
}
