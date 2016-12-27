//
//  SRMString.swift
//  SkyRealMan
//
//  Created by SongZhen on 2016/11/22.
//
//

import Foundation

public extension String{
    func transformToLatinStripDiacritics() -> String{
        let str = NSMutableString(string: self) as CFMutableString
        if CFStringTransform(str, nil, kCFStringTransformToLatin, false){
            if CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false){
                return str as String
            }
            return self
        }
        return self
    }
}

public extension Date{
    func getYear() -> Int?{
        let date = Date()
        let calendar = NSCalendar.current
        let dateCom = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        return dateCom.year
    }
}

public class BlogHelper{
    open static func makeSynopsis(by body: String) -> String{
        var linesArray: [String] = []

        let result = body.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
        result.enumerateLines{line, _ in linesArray.append(line)}
        let synopsis = linesArray.filter{!$0.isEmpty}.joined(separator: "\n")
        
        if synopsis.characters.count <= 100{
            return synopsis
        } else{
            let index = synopsis.index(synopsis.startIndex, offsetBy: 100)
            return (synopsis.substring(to: index) + "...")
        }
    }
}
