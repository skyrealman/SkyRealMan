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
}
