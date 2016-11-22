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
