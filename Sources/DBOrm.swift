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
        blog.setup()
        category.setup()
    }
    func populate(){
        let blog_data = [
            ["The Big List of Fun Things to Do By Yourself","This is a list of fun things you can do by yourself (or with friends in some cases).","<h3>The Beauty of Being Alone</h3><p>This is a list of fun things you can do by yourself (or with friends in some cases).  I’ve included TONS of links to some GREAT sites that can help get you moving and keep you entertained, so please feel free to share this post with your friends!</p><p>So, what are some things to do by yourself?  Well, there are a lot of things that you can do, but the direction you’ll want to take might depend on your situation.  By the way, there is a big difference between being alone and being lonely.  If you aren’t clear on that, watch this amazing video I came across.  The message can change the way you look at your life!</p><h3>Enjoy Your Day!</h3><p>Are you looking for a break from a busy daily routine?  If so, you might have to actually schedule your alone time.  Maybe you’re at a time in your life when you just don’t have very much to do, or people to do things with.  Don’t fret.  Make the most of your alone time.  Maybe learning to meditate or developing a new skill would be more productive than dropping on to the couch and watching TV.  What follows are some ideas to get you going."],
            ["LED icicle lights","The Basics LED Christmas lights, sometimes referred to as LED icicle lights, have grown rapidly in popularity in recent years. There are actually two distinct types of lights that are popularly known by this name","<p>LED Christmas lights, sometimes referred to as LED icicle lights, have grown rapidly in popularity in recent years. There are actually two distinct types of lights that are popularly known by this name.  First are the tiny lights dangling from wires, which when suspended create a net-like effect. Also widely known as LED icicle lights are LED lights that are actually made to resemble icicles. In order to avoid confusion, some people refer to the former type of light as ‘net’ LED lights.</p><p>LED is an acronym for ‘light emitting diode’, which produces light on a different basic principle than do incandescent or fluorescent lights. Light emitting diode work by the movement of electrons through semiconductor material. They have no filaments as in an incandescent light, nor do they contain gases, as in a fluorescent or neon type light.</p>"],
            ["Find Home Decor Guidance in Interior Design Books","Interior Design Books can help the novice designer as well as the experienced professional in creating unique interior designs to fit any décor.","<p>Interior Design Books can help the novice designer as well as the experienced professional in creating unique interior designs to fit any décor. Whether one wants a traditional or modern interior design, the right books can provide the guidance one needs in creating the perfect living room, bedroom, dining room or any other room in the home. Even business establishments can benefit from interior design ideas in order to make their offices more inviting and productive to employees as well as customers.</p><h3>What Room is Getting the Makeover?</h3><p>When looking for the right books on interior design, it is important to consider what room or rooms need a makeover. For instance, if one wants to give the living room a new twist, a book with furniture ideas such as couches, sofas, coffee tables and other common items found in this area should be first on the list. A book that has ideas for wall art or flooring styles most compatible with a preferred style should also be considered.</p><h3What’s Your Style?<h3><p>It is also possible to look for books based on particular decorating styles. For example, Oriental designs are popular in many households, so finding a book with Oriental design concepts and Asian furniture decorating ideas can be useful. These books can help designers find benches and stools, wooden screens and dividers or cabinets and armoires with distinct Asian designs. One may also find out what Asian inspired art such as ceramic pots, tapestries, carved statues, folding screens, jade pieces and many other decorative accents go best with the chosen decorative motif or theme.</p><h3Interior Design is for Business Too!<h3><p>Businesses also benefit from paying attention to their interior designs. An office’s atmosphere can affect the way business is conducted. Having a comfortable and cozy homelike feel to an office may put potential clients or customers at ease.  The interior design can also say volumes about the business itself from sophisticated and elegant to casual and relaxed. Choosing books that show business owners how to choose and create décor can be a great business asset, especially since first impressions are critical to businesses.</p>"],
            ["How to Make Patio Lanterns","If you are looking to give your patio and backyard some type of mood inducing illumination, your first step is to put up patio lights.  However, these forms of lighting can be a stress on your budget, especially if you are trying to get something that fits your sense of style as well as functionality.","<p>If you are looking to give your patio and backyard some type of mood inducing illumination, your first step is to put up patio lights.  However, these forms of lighting can be a stress on your budget, especially if you are trying to get something that fits your sense of style as well as functionality.  If you are having trouble obtaining inexpensive and attractive lighting options, here are some tips on how to make patio lanterns on your own.hanging patio lanterns</p><p><b>Hanging Jar Lanterns:</b> Fill cleaned glass jars with a variety of candles; the shapes and sizes of both of these can be varied by taste or just by what you happen to have on hand.  Jars with a lip will work best, as you can then bend metal around the opening and hook it over to create a handle, much like an ornament.  These can then be hung from wires or tree branches, and you can replace the candles whenever they run low.</p><p><b>Touch Light Lamps:</b> Touch lights are inexpensive lighting options that you can purchase at an office supply store and are easy to turn on and off.  Create shades out of decorative paper squares, rolling them and fastening them around the touch lights.  You can even cut attractive shapes out of the paper to cast fun shadows onto your patio.  This can be a fun project to that will get the kids involved.</p><p>Concentrated Christmas Lights: Purchase strings of white (or colored, if you desire) lights during the Christmas season, when they are inexpensive.  Wrap bunches of 10-15 little bulbs together and make a paper shade similar to the one mentioned above — just make sure the paper won’t touch the bulbs.  Connect several strings together for more lights.</p>"],
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
                let date = NSDate()
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "yyyy-MM-dd"
                let strNowTime = timeFormatter.string(from: date as Date) as String
                blog.id = try blog.insert(cols: ["title", "titlesanitized", "synopsis", "body", "posttime", "authorid", "categoryid", "readtimes"], params: [blog_data[i][0], blog_data[i][0].transformToLatinStripDiacritics().slugify(), blog_data[i][1], blog_data[i][2], strNowTime, "nhqtfn--2TIKAAAAAAAAAA", 3, 0]
                    ) as? Int
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
    
    func getList() -> [[String: String]]{
        var data = [[String: String]]()
        do{
            let blog = Blog(connect!)
            try blog.select(
                columns: ["title", "synopsis"],
                whereclause: "",
                params: [],
                orderby: []
            )
            if(blog.rows().count > 0){
                for item in blog.rows().reversed(){
                    var contentDict = [String: String]()
                    contentDict["title"] = item.title
                    contentDict["synopsis"] = item.synopsis
                    data.append(contentDict)
                    print(contentDict["synopsis"] ?? "null")
                }

            }
        }catch{
            print(error)
        }
        return data
    }
    func getStory(_ storyid: String) ->[String: String]{
        var data = [String: String]()
        
        do {
            let blog = Blog(connect!)
            let category = Category(connect!)
            try blog.select(columns: ["title", "body", "posttime", "authorid", "categoryid"], whereclause: "titlesanitized = :1", params: [storyid], orderby: [])
            try category.select(columns: ["name"], whereclause: "id = :1", params:[blog.rows()[0].categoryid!], orderby: [])
            data["title"] = blog.rows()[0].title
            data["body"] = blog.rows()[0].body
            data["posttime"] = blog.rows()[0].posttime
            data["user_name"] = blog.rows()[0].authorid
            data["category_name"] = category.rows()[0].name
            
        }catch{
            print(error)
        }
        return data
    }
    func setStory(_ story: (String,String)){
        let date = NSDate()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd"
        let strNowTime = timeFormatter.string(from: date as Date) as String
        do {
            let blog = Blog(connect!)
            let title = story.0
            let titlesanitized = story.0.transformToLatinStripDiacritics().slugify()
            let body = story.1
            var synopsis = ""
            if (body.characters.count <= 50){
                synopsis = body
            }else{
                let index = body.index(body.startIndex, offsetBy: 50)
                synopsis = body.substring(to: index)
            }
            let posttime = strNowTime
            let authorid = "nhqtfn--2TIKAAAAAAAAAA"
            blog.id = try blog.insert(cols: ["title", "titlesanitized", "synopsis", "body", "posttime", "authorid", "categoryid", "readtimes"], params: [title, titlesanitized, synopsis, body, posttime, authorid, 3, 0]) as? Int
        }catch{
            print(error)
        }
    }
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
                    data.append(contentDict)
                }
            }
        }catch{
            print(error)
        }
        return data
    }
    func setCategory(_ name: String){
        do{
            let category = Category(connect!)
            category.id = try category.insert(cols: ["name"], params: [name]) as? Int
        }catch{
            print(error)
        }
    }
    func getCategoryCount() -> Int?{
        var count: Int?
        do {
            let category = Category(connect!)
            try category.findAll()
            count = category.rows().count
        }catch{
            print(error)
        }
        return count
    }
    func getCategoryByPage(page: String) ->[Any]{
        let numPerPage = 10
        let limit = 10
        let thisCursor = StORMCursor(limit: limit, offset: (Int(page)! - 1) * numPerPage)
        var data = [Any]()
        do{
            let category = Category(connect!)
            try category.select(columns:["id", "name"], whereclause: "", params: [], orderby: [], cursor: thisCursor, joins: [], having: [], groupBy: [])
            print(category.rows().count)
            if(category.rows().count > 0){
                for item in category.rows(){
                    var contentDict = [String: Any]()
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
}
