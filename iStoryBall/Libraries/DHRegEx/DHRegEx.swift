//
//  DHRegEx.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 30..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class DHRegEx
{
    class func tagSelector(tagName: String, error: NSErrorPointer) -> NSRegularExpression {
        return NSRegularExpression(pattern: "<(div)[^>]*>[\\s\\S]*?<\\/\\s?\\1>", options: NSRegularExpressionOptions(0), error: error)
    }
    
    class func idSelector(idName: String, error: NSErrorPointer) -> NSRegularExpression {
        return NSRegularExpression(pattern: "<([\\S]+)[^>]*id=(\"|\')\(idName)(\"|\')[^>]*>[\\s\\S]*?<\\/\\s?\\1>", options: NSRegularExpressionOptions(0), error: error)
    }
    
    class func classSelector(className: String, error: NSErrorPointer) -> NSRegularExpression {
        return NSRegularExpression(pattern: "<([\\S]+)[^>]*class=(\"|\')[^\"^\']*?\(className)[^\"^\']*?(\"|\')[^>]*?>[\\s\\S]*?<\\/\\s?\\1>", options: NSRegularExpressionOptions(0), error: error)
    }
}
