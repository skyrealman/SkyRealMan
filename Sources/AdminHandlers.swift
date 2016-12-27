//
//  BlogAdmin.swift
//  SkyRealMan
//
//  Created by SongZhen on 2016/11/26.
//
//

import PerfectHTTP
import StORM
import SQLiteStORM
import Foundation
import TurnstilePerfect
import Turnstile
import TurnstileCrypto
import TurnstileWeb
import PerfectLogger
import PerfectMustache
import PerfectLib
public class BlogAdmin{
    open static func makeLoginGET(request: HTTPRequest, _ response: HTTPResponse){
        response.renderWithDate(template: "login")
    }
    
    open static func makeLoginPOST(request: HTTPRequest, _ response: HTTPResponse){
        guard let username = request.param(name: "username"), let password = request.param(name: "password") else{
            response.renderWithDate(template: "login", context: ["flash": "请输入用户名和密码"])
            return
        }
        let credentials = UsernamePassword(username: username, password: password)
        do {
            try request.user.login(credentials: credentials, persist: true)
            response.redirect(path: "/")
        }catch{
            response.renderWithDate(template: "login", context: ["flash": "用户名或密码错误"])
        }
    }
    
    open static func makeRegisterGET(request: HTTPRequest, _ response: HTTPResponse){
        response.renderWithDate(template: "register")
    }
    
    open static func makeRegisterPOST(request: HTTPRequest, _ response: HTTPResponse){
        guard let username = request.param(name: "username"), let password = request.param(name: "password") else{
            response.renderWithDate(template: "register", context: ["flash": "请输入用户名和密码"])
            return
        }
        let credentials = UsernamePassword(username: username, password: password)
        do{
            try request.user.register(credentials: credentials)
            try request.user.login(credentials: credentials, persist: true)
            response.redirect(path: "/")
        }catch let e as TurnstileError{
            response.renderWithDate(template: "register", context: ["flash": e.description])
        }catch {
            response.renderWithDate(template: "register", context: ["flash": "未知错误"])
        }
    }
    
    open static func makeLogout(request: HTTPRequest, _ response: HTTPResponse){
        request.user.logout()
        response.redirect(path: "/")
    }
    
    open static func makeTagGET(request: HTTPRequest, _ response: HTTPResponse){
        let page = request.urlVariables["page"] ?? "1"
        guard page.isNumeric() else{
            response.redirect(path: "/admin/manage")
            return
        }
        let categoryPageCount = dbHandler.getCategoryPageCount()
        let data = dbHandler.getCategoryByPage(page: page)
        let scratchPad = request.scratchPad
        var context: [String: Any] = [
            "count": dbHandler.getCategoryPageContext(),
            "previous": {(previous: String, context: MustacheEvaluationContext) -> String in
                return String(Int(page)! - 1 <= 0 ? 1 : Int(page)! - 1)
            },
            "next": {(next: String, context: MustacheEvaluationContext) -> String in
                return String(Int(page)! + 1 >= categoryPageCount ? categoryPageCount : Int(page)! + 1)
            },
            "categories": data,
            "accountID": request.user.authDetails?.account.uniqueID ?? "",
            "authenticated": request.user.authenticated
            ]
        for key in scratchPad.keys {
            context[key] = scratchPad[key]
        }
        response.renderWithDate(template: "admin/manage", context: context)
    }
    
    open static func makeTagPOST(request: HTTPRequest, _ response: HTTPResponse){
        response.setHeader(.contentType, value: "text/html")
        guard let category = request.param(name: "category"), category.trimmed() != "" else{
            let contxt: [String: Any] = [
                "flash": "标签名不能为空",
            ]
            for key in contxt.keys {
                response.request.scratchPad[key] = contxt[key]
            }
            makeTagGET(request: request, response)
            return

        }
        guard !dbHandler.isCategoryExist(tag: category) else{
            let contxt: [String: Any] = [
                "flash": "标签名已经存在",
            ]
            for key in contxt.keys {
                response.request.scratchPad[key] = contxt[key]
            }
            makeTagGET(request: request, response)
            return
        }
        if category.characters.count > 0{
            let _ = dbHandler.setCategory(category)
        }
        makeTagGET(request: request, response)
    }
    
    open static func makeStoryInsertGET(request: HTTPRequest, _ response: HTTPResponse){
        
        let tags = dbHandler.getCategory()
        var context: [String: Any] = [
            "accountID": request.user.authDetails?.account.uniqueID ?? "",
            "authenticated": request.user.authenticated,
            "tags": tags
        ]
        if request.scratchPad.keys.contains("title"){
            context["title"] = request.scratchPad["title"]
        }
        response.renderWithDate(template: "admin/prepare", context: context)
    }
    open static func makeStoryInsertPOST(request: HTTPRequest, _ response: HTTPResponse){
        guard let title = request.param(name: "title"), let body = request.param(name: "body"), !title.isEmpty, !body.isEmpty else{
            response.renderWithDate(template: "admin/prepare", context: ["flash": "请输入标题与正文"])
            return
        }
        guard let tag = request.param(name: "tag"), !tag.isEmpty else{
            response.renderWithDate(template: "admin/prepare", context: ["flash": "请选择分类"])
            return
        }
        let isTopped = request.param(name: "istopped") ?? "0"
        let isComment = request.param(name: "iscomment") ?? "0"
        let userId = request.user.authDetails?.account.uniqueID ?? ""
        let rbody = body.replacingOccurrences(of: "\n", with: "<br>")
        print(rbody)
        dbHandler.setStory((title: title, body: rbody, tag: tag, userId: userId, isTopped: isTopped, isComment: isComment))
        
        let params = request.postParams
        for param in params{
            if param.0.contains("file"){
                let str = param.1.split("|")
                dbHandler.setAttachment(attach: (uniqueID:str[2], oldName: str[1], fileSize: str[0], title.transformToLatinStripDiacritics().slugify()))
            }
        }
        
        response.redirect(path: "/story/\(title.transformToLatinStripDiacritics().slugify())")
    }
    open static func deleteTag(request: HTTPRequest, _ response: HTTPResponse){
        let rmTag = request.urlVariables["tag"] ?? ""
        dbHandler.deleteCategory(tag: rmTag)
        response.redirect(path: "/admin/manage")
        
    }
    open static func makeManageList(request: HTTPRequest, _ response: HTTPResponse){
        let page = request.urlVariables["page"] ?? "1"
        guard page.isNumeric() else{
            response.renderWithDate(template: "admin/storymanage", context: ["flash": "页码不合法","count": dbHandler.getStoryPageContext()])
            return
        }
        let data = dbHandler.getListForManageByPage(page: page)
        let context: [String: Any] = [
            "count": dbHandler.getStoryPageContext(),
            "stories": data,
            "accountID": request.user.authDetails?.account.uniqueID ?? "",
            "authenticated": request.user.authenticated
        ]
        response.renderWithDate(template: "admin/storymanage", context: context)
    }
    open static func editTag(request: HTTPRequest, _ response: HTTPResponse){
        let oldTag = request.urlVariables["oldtag"] ?? ""
        let newTag = request.urlVariables["newtag"] ?? ""
        guard newTag != "", oldTag != "" else{
            let contxt: [String: Any] = [
            "flash": "标签名不合法",
            ]
            for key in contxt.keys {
                response.request.scratchPad[key] = contxt[key]
            }
            makeTagGET(request: request, response)
            return
        }
        dbHandler.editCategory(oldTag: oldTag, newTag: newTag)
        response.redirect(path: "/admin/manage")
    }
    
    open static func editStory(request: HTTPRequest, _ response: HTTPResponse){
        let title = request.urlVariables["title"] ?? ""
        //let data = dbHandler.getStory(title.transformToLatinStripDiacritics().slugify())
        //response.setHeader(.contentType, value: "application/json")
        let contxt : [String: Any] = [
            "title": title
        ]
        for key in contxt.keys {
            response.request.scratchPad[key] = contxt[key]
        }
        makeStoryInsertGET(request: request, response)
 
    }
    open static func getStoryAPI(request: HTTPRequest, _ response: HTTPResponse){
        let title = request.urlVariables["title"] ?? ""
        let data = dbHandler.getStoryForEdit(title.transformToLatinStripDiacritics().slugify())
        response.setHeader(.contentType, value: "application/json")
        do{
            try response.setBody(json: data)
        }catch{
            print(error)
        }
        response.completed()
    }
    open static func deleteStory(request: HTTPRequest, _ response: HTTPResponse){
        let titlesanitized = request.urlVariables["titlesanitized"] ?? ""
        dbHandler.deleteCommentsByStory(titlesanitized)
        dbHandler.deleteAttachmentByStory(titlesanitized)
        dbHandler.deleteStory(titlesanitized)
        response.redirect(path: "/admin/storymanage")
        
    }
    open static func changeCommentStatus(request: HTTPRequest, _ response: HTTPResponse){
        let titlesanitized = request.urlVariables["titlesanitized"] ?? ""
        dbHandler.changeCommentStatus(by: titlesanitized)
        response.redirect(path: "/admin/storymanage")
    }
    open static func deleteComment(request: HTTPRequest, _ response: HTTPResponse){
        let uniqueID = request.urlVariables["uniqueid"] ?? ""
        let titlesanitized = request.urlVariables["titlesanitized"] ?? ""
        dbHandler.deleteComment(by: uniqueID)
        response.redirect(path: "/story/\(titlesanitized)")
    }
    open static func fileUpload(request: HTTPRequest, _ response: HTTPResponse){
        let fileDir = Dir(Dir.workingDir.path + "files")
        
        do{
            try fileDir.create()
        }catch{
            print(error)
        }
        if let uploads = request.postFileUploads, uploads.count > 0{
            var ary = [[String: Any]]()
            for upload in uploads{
                var fileInfo: [String: Any] = [
                    "fieldName": upload.fieldName,
                    "contentType": upload.contentType,
                    "fileName": upload.fileName,
                    "fileSize": upload.fileSize,
                    "tmpFileName": upload.tmpFileName
                    ]
                do{
                    if(upload.tmpFileName != ""){
                        let thisFile = File(upload.tmpFileName)
                        let tmp = upload.fileName.split(".")
                        let extendName = tmp[tmp.count - 1]
                        let uid = UUID().string
                        let path = "/attachment/" + uid + "." + extendName
                        fileInfo["filePath"] = path
                        fileInfo["fileUID"] = uid
                        let _ = try thisFile.moveTo(path: fileDir.path + uid + "." + extendName, overWrite: true)
                        
                    }
                }catch{
                    print(error)
                }
               ary.append(fileInfo)
            }
            let context = ["file": ary]
            response.setHeader(.contentType, value: "application/json")
            
            do{
                try response.setBody(json: context)
            }catch{
                print(error)
            }
            response.completed()
        }
    }
    open static func deleteFile(request: HTTPRequest, _ response: HTTPResponse){
        let fileDir = Dir(Dir.workingDir.path + "files")
        if fileDir.exists{
            //想想怎么写
        }
    }
}
