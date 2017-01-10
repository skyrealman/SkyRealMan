 //
//  DBOrm.swift
//  SkyRealMan
//
//  Created by SongZhen on 2016/11/14.
//
//
import Foundation
import PerfectLib
import SQLite
import PerfectHTTP
import PerfectHTTPServer
import PerfectMustache
import SwiftString
import StORM
import SQLiteStORM
import PerfectTurnstileSQLite
class DBOrm{
    let dbPath = "./database/blog-database"
    func create(){
        connect = SQLiteConnect(dbPath)
        let blog = Blog(connect!)
        let category = Category(connect!)
        let comment = Comment(connect!)
        let attachment = Attachment(connect!)
        blog.setup()
        category.setup()
        comment.setup()
        attachment.setup()
    }
    func populate(){
        let blog_data = [
            ["The Big List of Fun Things to Do By Yourself","This is a list of fun things you can do by yourself (or with friends in some cases).","<h3>The Beauty of Being Alone</h3><p>This is a list of fun things you can do by yourself (or with friends in some cases).  I’ve included TONS of links to some GREAT sites that can help get you moving and keep you entertained, so please feel free to share this post with your friends!</p><p>So, what are some things to do by yourself?  Well, there are a lot of things that you can do, but the direction you’ll want to take might depend on your situation.  By the way, there is a big difference between being alone and being lonely.  If you aren’t clear on that, watch this amazing video I came across.  The message can change the way you look at your life!</p><h3>Enjoy Your Day!</h3><p>Are you looking for a break from a busy daily routine?  If so, you might have to actually schedule your alone time.  Maybe you’re at a time in your life when you just don’t have very much to do, or people to do things with.  Don’t fret.  Make the most of your alone time.  Maybe learning to meditate or developing a new skill would be more productive than dropping on to the couch and watching TV.  What follows are some ideas to get you going."],
            ["习近平在秘鲁国会发表重要演讲","新华社利马11月21日电 国家主席习近平21日在秘鲁国会发表题为《同舟共济、扬帆远航，共创中拉关系美好未来》的重要演讲，强调中拉双方要高举和平发展合作旗帜，共同打造好中拉命运共同体这艘大船，在实现中国梦和拉美梦的道路上精诚合作，推动中拉全面合作伙伴关系实现更高水平发展。","<b>新华社利马11月21日电</b> 国家主席习近平21日在秘鲁国会发表题为《同舟共济、扬帆远航，共创中拉关系美好未来》的重要演讲，强调中拉双方要高举和平发展合作旗帜，共同打造好中拉命运共同体这艘大船，在实现中国梦和拉美梦的道路上精诚合作，推动中拉全面合作伙伴关系实现更高水平发展。习近平强调，中国将始终做世界和平的建设者、全球发展的贡献者、国际秩序的维护者，坚定走和平发展道路。中国将坚持走共同发展道路，继续奉行互利共赢的开放战略，积极践行正确义利观，欢迎各国搭乘中国发展“顺风车”，一起实现共同发展。中国经济发展的前景是光明的，将为全球经济增长作出贡献。中方愿继续同各方共同推动世界经济强劲、可持续、平衡、包容增长。习近平强调，我们要把握时代脉搏、抓住发展机遇，铸就携手共进的中拉命运共同体。演讲结束时，现场听众报以经久不息的掌声。秘鲁副总统阿劳斯，部长会议主席萨瓦拉，宪法法院院长米兰达，政府部长，国会议员，省市长代表，军方代表，驻秘鲁使团、国际组织代表，当地华人华侨和中资机构代表等200余人出席演讲。王沪宁、栗战书、杨洁篪等出席。"]
        ]
        do {
            let blog = Blog(connect!)
            do{
               try blog.sqlExec("DELETE FROM blog")
            }catch{
                print(error)
            }
            
            for i in 0..<blog_data.count{
                let date = Date()
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "yyyy-MM-dd"
                let strNowTime = timeFormatter.string(from: date) as String
                blog.id = try blog.insert(cols: ["title", "titlesanitized", "synopsis", "body", "posttime", "authorid", "categoryid", "readtimes", "istopped"], params: [blog_data[i][0], blog_data[i][0].transformToLatinStripDiacritics().slugify(), blog_data[i][1], blog_data[i][2], strNowTime, "nhqtfn--2TIKAAAAAAAAAA", 3, 0, 0]
                    ) as! Int
            }

        }catch{
            print(error)
        }
    }
    func auth(){
        connect = SQLiteConnect(dbPath)
        let auth = AuthAccount(connect!)
        auth.setup()
        tokenStore = AccessTokenStore(connect!)
        tokenStore?.setup()
    }
    //博客相关的数据库操作
    func getListForView() -> [Any]{
        var data = [Any]()
        do{
            let blog = Blog(connect!)
            try blog.select(
                columns: ["title", "titlesanitized","synopsis", "posttime"],
                whereclause: "",
                params: [],
                orderby: []
            )
            if(blog.rows().count > 0){
                for item in blog.rows().reversed(){
                    var contentDict = [String: String]()
                    contentDict["title"] = item.title
                    contentDict["titlesanitized"] = item.titlesanitized
                    contentDict["synopsis"] = item.synopsis
                    contentDict["posttime"] = item.posttime
                    data.append(contentDict)
                }

            }
        }catch{
            print(error)
        }
        return data
    }
    func getLatestFiveStories() -> [Any]{
        var data = [Any]()
        do{
            let blog = Blog(connect!)
            try blog.select(
                columns: ["title", "titlesanitized","synopsis", "posttime"],
                whereclause: "",
                params: [],
                orderby: []
            )
            if(blog.rows().count > 0){
                var i = 0
                for item in blog.rows().reversed(){
                    var contentDict = [String: String]()
                    contentDict["title"] = item.title
                    contentDict["titlesanitized"] = item.titlesanitized
                    contentDict["synopsis"] = item.synopsis
                    contentDict["posttime"] = item.posttime
                    data.append(contentDict)
                    i += 1
                    if i == 6 { break }
                }
                data.remove(at: 0)
            }
        }catch{
            print(error)
        }
        return data
    }
    func getLatestStory() -> [String: String]{
        var data = [String: String]()
        do{
            let blog = Blog(connect!)
            try blog.select(columns: ["title", "titlesanitized", "synopsis", "posttime", "categoryid"], whereclause: "", params: [], orderby: [])
            if(blog.rows().count > 0){
                let category = Category(connect!)
                try category.select(columns: ["name"], whereclause: "id = :1", params: [blog.rows().reversed()[0].categoryid], orderby: [])
                if(category.rows().count == 1){
                    data["ltitle"] = blog.rows().reversed()[0].title
                    data["ltitlesanitized"] = blog.rows().reversed()[0].titlesanitized
                    data["lsynopsis"] = blog.rows().reversed()[0].synopsis
                    data["lposttime"] = blog.rows().reversed()[0].posttime
                    data["lcategory"] = category.rows()[0].name
                }

            }
        }catch{
            print(error)
        }
        return data
    }
    func getListForManageByPage(page: String) -> [Any]{
        let numPerPage = 10
        let limit = 10
        let thisCursor = StORMCursor(limit: limit, offset: (Int(page)! - 1) * numPerPage)
        var data = [Any]()
        do{
            let blog = Blog(connect!)
            try blog.select(
                columns: ["title","titlesanitized", "posttime","categoryid","iscomment","istopped"],
                whereclause: "",
                params: [],
                orderby: ["id desc"],
                cursor: thisCursor,
                joins: [],
                having: [],
                groupBy: [])
            let category = Category(connect!)
            if(blog.rows().count > 0){
                for (index,item) in blog.rows().enumerated(){
                    var contentDict = [String: String]()
                    contentDict["num"] = String(index + 1)
                    contentDict["title"] = item.title
                    contentDict["posttime"] = item.posttime
                    contentDict["titlesanitized"] = item.titlesanitized
                    contentDict["iscomment"] = String(item.isComment)
                    contentDict["istopped"] = String(item.isTopped)
                    if(item.isComment == 1){
                        contentDict["commentlabel"] = "关闭留言"
                    }else if(item.isComment == 0){
                        contentDict["commentlabel"] = "打开留言"
                    }
                    try category.select(
                        columns: ["name"],
                        whereclause: "id = :1",
                        params: [item.categoryid],
                        orderby: []
                    )
                    contentDict["tag"] = category.name
                    
                    data.append(contentDict)
                    //print(contentDict["tag"] ?? "null")
                }
                
            }
        }catch{
            print(error)
        }
        return data
    }
    
    func getListForYear(year: String) ->[Any]{
        var storyArr = [Any]()
        do{
            let blog = Blog(connect!)
            if(year == "All"){
                try blog.select(columns: ["title", "titlesanitized", "categoryid", "readtimes", "posttime"], whereclause: "", params: [], orderby: [])
            }else{
                let wString = "posttime like '%" + year + "%'"
                try blog.select(columns: ["title", "titlesanitized", "categoryid", "readtimes", "posttime"], whereclause: wString, params: [], orderby: [])
            }
            let category = Category(connect!)
            for item in blog.rows().reversed(){
                try category.select(columns: ["name"], whereclause: "id = :1", params: [item.categoryid], orderby: [])
                var contentDict = [String: Any]()
                contentDict["title"] = item.title
                contentDict["category"] = category.rows()[0].name
                contentDict["readtimes"] = item.readtimes
                contentDict["posttime"] = item.posttime
                contentDict["titlesanitized"] = item.titlesanitized
                storyArr.append(contentDict)
            }
        }catch{
            print(error)
        }
        return storyArr
    }
    func getListForCategory(tag: String) ->[Any]{
        var storyArr = [Any]()
        do{
            let category = Category(connect!)
            print(tag)
            try category.select(columns: ["id"], whereclause: "name = :1", params: [tag], orderby: [])
            print("hoho")
            if(category.rows().count == 1){
                let blog = Blog(connect!)
                try blog.select(columns: ["title", "titlesanitized", "posttime", "readtimes"], whereclause: "categoryid = :1", params: [category.rows()[0].id], orderby: [])
                for item in blog.rows().reversed(){
                    var contentDict = [String: Any]()
                    contentDict["title"] = item.title
                    contentDict["titlesanitized"] = item.titlesanitized
                    contentDict["readtimes"] = item.readtimes
                    contentDict["posttime"] = item.posttime
                    storyArr.append(contentDict)
                }
            }
        }catch{
            print("haha")
            print(error)
        }
        return storyArr
    }
    func getStoryCount() -> Int{
        var count: Int = 0
        do{
            let blog = Blog(connect!)
            try blog.findAll()
            count = blog.rows().count
        }catch{
            print(error)
        }
        return count
    }
    func getStoryPageCount() -> Int{
        let storyCount = self.getStoryCount()
        var pageCount = 0
        if storyCount > 0 {
            pageCount = Int(ceil(Double(storyCount)/10.0))
            return pageCount
        }
        return pageCount
    }
    func getStoryPageContext() -> [Any]{
        var countArr = [Any]()
        for i in 0..<self.getStoryPageCount(){
            countArr.append(["page": 1 + i])
        }
        return countArr
    }
    func getStory(_ storyid: String) ->[String: String]{
        var data = [String: String]()
        
        do {
            let blog = Blog(connect!)
            let category = Category(connect!)
            let users = AuthAccount(connect!)
            try blog.select(columns: ["id", "title", "body", "posttime", "authorid", "categoryid", "istopped", "iscomment", "readtimes"], whereclause: "titlesanitized = :1", params: [storyid], orderby: [])
            try category.select(columns: ["name"], whereclause: "id = :1", params:[blog.rows()[0].categoryid], orderby: [])
            try users.select(columns: [], whereclause: "uniqueID = :1", params: [blog.rows()[0].authorid], orderby: [])
            //print(users)
            data["title"] = blog.rows()[0].title
            
            data["body"] = blog.rows()[0].body.replacingOccurrences(of: "\r", with: "<br>")
            data["posttime"] = blog.rows()[0].posttime
            data["istopped"] = String(blog.rows()[0].isTopped)
            data["iscomment"] = String(blog.rows()[0].isComment)
            data["user_name"] = users.username
            data["category_name"] = category.rows()[0].name
            try blog.update(cols: ["readtimes"], params: [blog.rows()[0].readtimes + 1], idName: "id", idValue: blog.rows()[0].id)
            data["readtimes"] = String(blog.rows()[0].readtimes + 1)
        }catch{
            print(error)
        }
        return data
    }
    
    func getStoryForEdit(_ storyid: String) -> [String: String]{
        var data = [String: String]()
        
        do {
            let blog = Blog(connect!)
            let category = Category(connect!)
            let users = AuthAccount(connect!)
            try blog.select(columns: ["title", "body", "posttime", "authorid", "categoryid", "istopped", "iscomment"], whereclause: "titlesanitized = :1", params: [storyid], orderby: [])
            try category.select(columns: ["name"], whereclause: "id = :1", params:[blog.rows()[0].categoryid], orderby: [])
            try users.select(columns: [], whereclause: "uniqueID = :1", params: [blog.rows()[0].authorid], orderby: [])
            //print(users)
            data["title"] = blog.rows()[0].title
            
            data["body"] = blog.rows()[0].body
            data["posttime"] = blog.rows()[0].posttime
            data["istopped"] = String(blog.rows()[0].isTopped)
            data["iscomment"] = String(blog.rows()[0].isComment)
            data["user_name"] = users.username
            data["category_name"] = category.rows()[0].name
            
            //print("=====" + String(blog.rows()[0].isComment))
        }catch{
            print(error)
        }
        return data
    }
    func setStory(_ story: (title:String, body:String, tag: String, userId: String, isTopped: String, isComment: String)){
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd"
        let strNowTime = timeFormatter.string(from: date) as String
        do {
            let blog = Blog(connect!)
            let category = Category(connect!)
            var tag = 0
            if (!category.exists(story.tag)){
                tag = self.setCategory(story.tag)
            }else{
                try category.select(whereclause: "name = :1", params: [story.tag], orderby: [])
                tag = category.rows()[0].id
            }
            let title = story.title
            let titlesanitized = story.title.transformToLatinStripDiacritics().slugify()
            let body = BlogHelper.replace(story.body)
            let synopsis = BlogHelper.makeSynopsis(by: body)
            let posttime = strNowTime
            let authorid = story.userId
            let isTopped = story.isTopped
            let isComment = story.isComment
            if self.storyExist(title){
                try blog.select(columns: ["id", "posttime", "authorid"], whereclause: "title = :1", params: [title], orderby: [])
                try blog.update(cols: ["title","titlesanitized", "synopsis", "body", "posttime", "authorid", "categoryid", "readtimes", "istopped", "iscomment"], params: [title, titlesanitized, synopsis, body, blog.rows()[0].posttime, blog.rows()[0].authorid, tag, 0, isTopped, isComment], idName: "id", idValue: blog.rows()[0].id)
            }else{
                blog.id = try blog.insert(cols: ["title", "titlesanitized", "synopsis", "body", "posttime", "authorid", "categoryid", "readtimes", "istopped", "iscomment"], params: [title, titlesanitized, synopsis, body, posttime, authorid, tag, 0, isTopped, isComment]) as! Int
            }

        }catch{
            print(error)
        }
    }
    func storyExist(_ title: String) -> Bool{
        do{
            let blog = Blog(connect!)
            try blog.select(columns: [], whereclause: "title = :1", params: [title], orderby: [])
            if blog.rows().count == 1 {
                return true
            }else{
                return false
            }
        }catch{
            print("Exists error: \(error)")
            return false
        }
    }
    func deleteStory(_ titlesanitized: String){
        let blog = Blog(connect!)
        do{
            try blog.select(columns: ["id"], whereclause: "titlesanitized = :1", params: [titlesanitized], orderby: [])
            for story in blog.rows(){
                try blog.delete(story.id)
            }
        }catch{
            print(error)
        }
        
    }
    //分类相关的数据库操作
    func getCategory() ->[Any]{
        var data = [Any]()
        do{
            let category = Category(connect!)
            try category.select(columns: ["id","name"], whereclause: "", params: [], orderby: [])
            if(category.rows().count > 0){
                for item in category.rows(){
                    var contentDict = [String: Any]()
                    contentDict["id"] = item.id
                    contentDict["name"] = item.name
                    contentDict["tagcount"] = getStoryCountByCategory(id: item.id)
                    data.append(contentDict)
                }
            }
        }catch{
            print(error)
        }
        return data
    }
    func getStoryCountByCategory(id: Int) -> Int{
        var count = 0
        do{
            let blog = Blog(connect!)
            try blog.select(columns: [], whereclause: "categoryid = :1", params: [id], orderby: [])
            count = blog.rows().count
        }catch{
            print(error)
            return count
        }
        return count
    }
    //设计有问题，不符合面向函数编程思路，可做为反面例子讲解
    func isCategoryExist(tag: String) -> Bool{
        let category = Category(connect!)
        return category.exists(tag)
    }
    
    func setCategory(_ name: String) -> Int{
        do{
            let category = Category(connect!)
            category.id = try category.insert(cols: ["name"], params: [name]) as! Int
            return category.id
        }catch{
            print(error)
            return 0
        }
    }
    func getCategoryCount() -> Int{
        var count: Int = 0
        do {
            let category = Category(connect!)
            try category.findAll()
            count = category.rows().count
        }catch{
            print(error)
        }
        return count
    }
    func getCategoryPageCount() -> Int{
        let tagCount = self.getCategoryCount()
        var pageCount = 0
        if tagCount > 0 {
            pageCount = Int(ceil(Double(tagCount)/10.0))
            return pageCount
        }
        return pageCount
    }
    
    func getCategoryPageContext() -> [Any]{
        var countArr = [Any]()
        for i in 0..<self.getCategoryPageCount(){
            countArr.append(["page": 1 + i])
        }
        return countArr
    }
    
    func getCategoryByPage(page: String) ->[Any]{
        let numPerPage = 10
        let limit = 10
        let thisCursor = StORMCursor(limit: limit, offset: (Int(page)! - 1) * numPerPage)
        var data = [Any]()
        do{
            let category = Category(connect!)
            try category.select(columns:["id", "name"], whereclause: "", params: [], orderby: [], cursor: thisCursor, joins: [], having: [], groupBy: [])

            if(category.rows().count > 0){
                for (index,item) in category.rows().enumerated(){
                    var contentDict = [String: Any]()
                    contentDict["num"] = index + 1
                    contentDict["id"] = item.id
                    contentDict["name"] = item.name
                    data.append(contentDict)
                }
            }
        }catch{
            print(error)
        }
        return data
    }
    func getBlogYears() -> [String]{
        var yearArr = [String]()

        do{
            let blog = Blog(connect!)
            try blog.select(columns: ["posttime"], whereclause: "", params: [], orderby: [])
            for item in blog.rows(){
                let date = item.posttime.split("-")
                if(!yearArr.contains(date[0])){
                    yearArr.append((date[0]))
                }
            }
        }catch{
            print(error)
        }
        return yearArr
    }

    func deleteCategory(tag: String){
        do{
            let category = Category(connect!)
            let blog = Blog(connect!)
            try category.select(columns: ["id"], whereclause: "name = $1", params: [tag], orderby: [])
            for tag in category.rows(){
                try category.delete(tag.id)
                try blog.select(columns: ["id"], whereclause: "categoryid = $1", params: [tag.id], orderby: [])
                for b in blog.rows(){
                   try blog.delete(b.id)
                }
            }
            }catch{
                print(error)
            }
    }
    //newTag需要先校验，看是否存在，如果不存在再赋给oldTag
    func editCategory(oldTag: String, newTag: String){
        do{
            let category = Category(connect!)
            try category.select(columns: ["id"], whereclause: "name = $1", params: [oldTag], orderby: [])
            for item in category.rows(){
                try category.update(cols: ["name"], params: [newTag], idName: "id", idValue: item.id)
            }

        }catch{
            print(error)
        }
    }
    //评论相关的数据库操作
    func changeCommentStatus(by titleSanitized: String){
        do{
            let blog = Blog(connect!)
            try blog.select(columns: ["id", "iscomment"], whereclause: "titlesanitized = :1", params: [titleSanitized], orderby: [])
            if(blog.rows().count == 1){
                if(blog.rows()[0].isComment == 0){
                    try blog.update(cols: ["iscomment"], params: [1], idName: "id", idValue: blog.rows()[0].id)
                }else{
                    try blog.update(cols: ["iscomment"], params: [0], idName: "id", idValue: blog.rows()[0].id)
                }
                
            }
        }catch{
            print(error)
        }
    }
    
    func setComment(comment: (visitor: String, email: String, cposttime: String, cbody: String, titleSanitized: String, uniqueID: String)){
        do{
            let com = Comment(connect!)
            let blog = Blog(connect!)
            try blog.select(columns: ["id"], whereclause: "titlesanitized = :1", params: [comment.titleSanitized], orderby: [])
            if(blog.rows().count == 1){
                let _ = try com.insert(cols: ["uniqueID", "visitor", "email", "cposttime", "cbody", "blogid"], params: [comment.uniqueID, comment.visitor, comment.email, comment.cposttime, comment.cbody, blog.rows()[0].id])
            }

        }catch{
            print(error)
        }
    }
    func getComments(by titleSanitized: String) -> [String: Any]{
        var comments = [String: Any]()
        do{
            let com = Comment(connect!)
            let blog = Blog(connect!)
            try blog.select(columns: ["id"], whereclause: "titlesanitized = :1", params: [titleSanitized], orderby: [])
            if(blog.rows().count == 1){
                try com.select(columns: [], whereclause: "blogid = $1", params: [blog.rows()[0].id], orderby: [])
                var comment = [Any]()
                for c in com.rows().reversed(){
                    var contentDict = [String: String]()
                    contentDict["visitor"] = c.visitor
                    contentDict["cposttime"] = c.cposttime
                    contentDict["cbody"] = c.cbody
                    contentDict["uniqueid"] = c.uniqueID
                    comment.append(contentDict)
                }
                comments["comments"] = comment
            }
            
        }catch{
            print(error)
        }
        return comments
    }
    func getCommentCount(by titleSanitized: String) -> Int{
        var commentCount = 0
        do{
            let com = Comment(connect!)
            let blog = Blog(connect!)
            try blog.select(columns: ["id"], whereclause: "titlesanitized = :1", params: [titleSanitized], orderby: [])
            if(blog.rows().count == 1){
                try com.select(columns: [], whereclause: "blogid = :1", params: [blog.rows()[0].id], orderby: [])
                commentCount = com.rows().count
            }

        }catch{
            print(error)
        }
        
        return commentCount
    }
    func getComment(by uniqueID: String) -> [String: String]{
        var context = [String: String]()
        do{
            let com = Comment(connect!)
            try com.select(columns: [], whereclause: "uniqueID = :1", params: [uniqueID], orderby: [])
            if(com.rows().count == 1){
                context["quotevisitor"] = com.rows()[0].visitor
                context["quotebody"] = com.rows()[0].cbody
            }
        }catch{
            print(error)
        }
        return context
    }
    func deleteComment(by uniqueID: String){
        do{
            let com = Comment(connect!)
            try com.delete(uniqueID)
        }catch{
            print(error)
        }
    }
    func deleteCommentsByStory(_ titlesanitized: String){
        do{
            let com = Comment(connect!)
            let blog = Blog(connect!)
            try blog.select(columns: ["id"], whereclause: "titlesanitized = :1", params: [titlesanitized], orderby: [])
            if(blog.rows().count == 1){
                try com.select(columns: [], whereclause: "blogid = :1", params: [blog.rows()[0].id], orderby: [])
                for c in com.rows(){
                    try com.delete(c.uniqueID)
                }
            }

        }catch{
            print(error)
        }
    }
    func setAttachment(attach: (uniqueID: String, oldName: String, fileSize: String, titleSanitized: String)){
        do{
            let attachment = Attachment(connect!)
            let blog = Blog(connect!)
            try blog.select(columns: ["id"], whereclause: "titlesanitized = :1", params: [attach.titleSanitized], orderby: [])
            if(blog.rows().count == 1){
                let _ = try attachment.insert(cols: ["uniqueID", "oldname", "filesize", "blogid"], params: [attach.uniqueID, attach.oldName, attach.fileSize, blog.rows()[0].id])
            }
        }catch{
            print(error)
        }
    }
    func deleteAttachmentByStory(_ titlesanitized: String){
        do{
            let blog = Blog(connect!)
            try blog.select(columns: ["id"], whereclause: "titlesanitized = :1", params: [titlesanitized], orderby: [])
            if(blog.rows().count == 1){
                let attach = Attachment(connect!)
                try attach.select(columns: [], whereclause: "blogid = :1", params: [blog.rows()[0].id], orderby: [])
                for a in attach.rows(){
                    try attach.delete(a.uniqueID)
                }
            }
            
        }catch{
            print(error)
        }
    }
    func getSearchResult(by keys: [String]) -> [Any]{
        var context = [Any]()
        do{
            let blog = Blog(connect!)
            var whereclause = " "
            for (index, key) in keys.enumerated(){
                whereclause += "body LIKE '%\(key)%'"
                if(index != keys.count - 1){
                    whereclause += " AND "
                }
            }
            try blog.select(whereclause: whereclause, params: [], orderby: [])
            var tmpIdArr: [Int] = [Int]()
            var tmpKeyArr: [[String]] = [[String]]()
            for b in blog.rows(){
                tmpIdArr.append(b.id)
                tmpKeyArr.append(keys)
            }
            for key in keys{
                try blog.select(whereclause: "body LIKE '%\(key)%'", params: [], orderby: [])
                for b in blog.rows(){
                    if !tmpIdArr.contains(b.id){
                        tmpIdArr.append(b.id)
                        tmpKeyArr.append([key])
                    }
                }
            }
            for (index,id) in tmpIdArr.enumerated(){
                try blog.select(whereclause: "id = :1", params: [id], orderby: [])
                var contentDict = [String: Any]()
                contentDict["stitle"] = blog.title
                contentDict["stitlesanitized"] = blog.titlesanitized
                contentDict["sbody"] = BlogHelper.getSearchResult(body: blog.body, keywords: tmpKeyArr[index])
                contentDict["sposttime"] = blog.posttime
                context.append(contentDict)
            }
            
        }catch{
            print("search error: \(error)")
        }
        return context
    }
}
