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
        return self.regexWithPattern("<(div)[^>]*>([\\s\\S]*?)<\\/\\s?\\1>", error: error)
    }
    
    class func idSelector(idName: String, error: NSErrorPointer) -> NSRegularExpression {
        return self.regexWithPattern("<([\\S]+)[^>]*id=(\"|\')\(idName)(\"|\')[^>]*>([\\s\\S]*?)<\\/\\s?\\1>", error: error)
    }
    
    class func classSelector(className: String, error: NSErrorPointer) -> NSRegularExpression {
        return self.regexWithPattern("<([\\S]+)[^>]*class=(\"|\')[^\"^\']*?\(className)[^\"^\']*?(\"|\')[^>]*?>([\\s\\S]*?)<\\/\\s?\\1>", error: error)
    }
    
    class func regexWithPattern(pattern: String, error: NSErrorPointer) -> NSRegularExpression {
        return NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions(0), error: error)
    }
}
