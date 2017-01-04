//
//  SRMString.swift
//  SkyRealMan
//
//  Created by SongZhen on 2016/11/22.
//
//

import PerfectLib
import Foundation
#if os(Linux)
    import CoreFoundation
    import Glibc
#endif
public extension String {
    func transformToLatinStripDiacritics() -> String{
        let chars = Array(self.utf16)
        let cfStr = CFStringCreateWithCharacters(nil, chars, self.utf16.count)
        let str = CFStringCreateMutableCopy(nil, 0, cfStr)!
        if CFStringTransform(str, nil, kCFStringTransformToLatin, false) {
            if CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false) {
                return String(describing: str)
            }
            return self
        }
        return self
    }
}

public extension Date{
    func getYear() -> Int?{
        let date = Date()
        let calendar = Calendar.current
        let dateCom = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        return dateCom.year
    }
}

public class BlogHelper{
    open static func makeSynopsis(by body: String) -> String{
        var linesArray: [String] = []
        let result = body.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
        //let to = CharacterSet(charactersIn: "\r")
        linesArray = result.components(separatedBy: "\r")
        //linux中 string没有enumerateLines方法
//        result.enumerateLines{line, _ in linesArray.append(line)}
        let synopsis = linesArray.filter{!$0.isEmpty}.joined(separator: "\r")

        if synopsis.characters.count <= 100{
            return synopsis
        } else{
            let index = synopsis.index(synopsis.startIndex, offsetBy: 100)
            return (synopsis.substring(to: index) + "...")
        }
    }
    open static func replace(_ s: String) -> String{
        let tmp = s.unicodeScalars
        let result = tmp.filter{$0.value != 10}.reduce(""){ String($0) + String($1)}
        return result
    }
    //获取搜索结果，保证共100字符
    open static func getSearchResult(body: String, keywords: [String]) -> [String]{
        var arr = [String]()
        var tmp = ""
        for key in keywords{
            let index = self.findStartIndex(body: body, key: key, length: 100)
            if(body[index...body.index(body.endIndex, offsetBy: -1)].characters.count > 100/keywords.count){
                let str = body[index...body.index(index, offsetBy: 100/keywords.count)]
                tmp = tmp + str + "... "
            }else{
                var str = body[body.index(body.endIndex, offsetBy: -1 * (100/keywords.count))...body.index(body.endIndex, offsetBy: -1)]
                let dict: [String] = ["\r", "。", "？", "；", "，", "、"]
                repeat{
                    if(dict.contains(str.substring(to: str.index(str.startIndex, offsetBy: 1)))){
                        str = str.substring(from: str.index(str.startIndex, offsetBy: 1))
                        break
                    }
                    str = str[str.index(str.startIndex, offsetBy: 1)...str.index(str.endIndex, offsetBy: -1)]
                }while(str.startIndex != str.endIndex)
                
                tmp = tmp + str + "... "
            }
           tmp = tmp.replacingOccurrences(of: key, with: "<code>\(key)</code>")
        }
        arr.append(tmp)
        return arr
    }
    //取得查询关键字前方第一个标点符号的位置，搜索结果不会断句
    open static func findStartIndex(body: String, key: String, length: Int) -> String.Index{
        let result = body.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
        var start: String.Index = result.startIndex
        if(result.contains(key)){
            let eIndex: String.Index = result.range(of: key)!.lowerBound
            let sIndex: String.Index = result.characters.distance(from: result.startIndex, to: eIndex) > length/2  ? result.index(eIndex, offsetBy:  -1 * length/2) : result.startIndex
            let dict: [String] = ["\r", "。", "？", "；", "，", "、"]
            if(sIndex != result.startIndex){
                let tmp: String = result[sIndex...eIndex]
                for d in dict{
                    if let idx = tmp.range(of: d, options: .backwards)?.upperBound{
                        start = result.index(idx, offsetBy: result.distance(from: result.startIndex, to: sIndex))
                        return start
                    }
                }
            }
            start = sIndex
            return start
        }
        return start
    }
}
