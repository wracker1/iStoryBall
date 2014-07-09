//
//  DHDomParser.swift
//  DHDomParser
//
//  Created by Jesse on 2014. 7. 7..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import Foundation

struct DHQueryCache {
    static var DHQueryCache = Dictionary<String, NSRegularExpression>()
    
    static func set(key: String, value: NSRegularExpression) {
        DHQueryCache[key] = value
    }
    
    static func get(key: String) -> NSRegularExpression? {
        return DHQueryCache["\(key)"]
    }
}

struct DomItem {
    let text: String?
    var tagName: String {
    get {
        return substringWithPattern("<(\\S*).*\\1>", capturingIndex: 1)
    }
    }
    
    var html: String {
    get {
        return substringWithPattern("<(\\S*)[^>]*>([\\s\\S]*?)<\\/\\s*\\1>", capturingIndex: 2)
    }
    }
    
    var attributes: Dictionary<String, String> {
    get {
        var attr = Dictionary<String, String>()
        let tag = openTag()
        let regex = DHDomParser.regexWithPattern("(\\S*)=[\'\"](\\S*)[\'\"]")
        let all = DHDomParser.entireRangeWithString(tag)
        regex.enumerateMatchesInString(tag, options: NSMatchingOptions(0), range: all) {
            (result: NSTextCheckingResult!, _, _) in
            let temp = tag as NSString
            let key = temp.substringWithRange(result.rangeAtIndex(1))
            let value = temp.substringWithRange(result.rangeAtIndex(2))
            attr[key] = value
        }
        return attr
    }
    }
    
    func openTag() -> String {
        let regex = DHDomParser.regexWithPattern("<[^>]*>")
        let all = DHDomParser.entireRangeWithString(text!)
        let first = regex.firstMatchInString(text, options: NSMatchingOptions(0), range: all)
        let temp = text! as NSString
        return temp.substringWithRange(first.range)
    }
    
    func substringWithPattern(pattern: String, capturingIndex: Int) -> String {
        let regex = DHDomParser.regexWithPattern(pattern)
        let all = DHDomParser.entireRangeWithString(text!)
        let result = regex.firstMatchInString(text, options: NSMatchingOptions(0), range: all)
        let temp = text! as NSString
        return temp.substringWithRange(result.rangeAtIndex(capturingIndex))
    }
    
    init(text: String) {
        self.text = text;
    }
}

class DHDomParser {
    enum SelectorType {
        case IdSelector, ClassSelector, TagSelector
    }
    
    class func selectorTypeWithQuery(query: String) -> SelectorType {
        switch query {
        case let x where x.hasPrefix("#"): return .IdSelector
        case let x where x.hasPrefix("."): return .ClassSelector
        default: return .TagSelector
        }
    }
    
    class func entireRangeWithString(str: String) -> NSRange {
        return NSMakeRange(0, countElements(str))
    }
    
    class func itemsWithQuery(domString: String, query: String) -> DomItem[] {
        let regex = DHDomParser.regexWithQuery(query)
        let all = entireRangeWithString(domString)
        var items: DomItem[] = []
        
        regex.enumerateMatchesInString(domString, options: NSMatchingOptions(0), range: all) {
            (result: NSTextCheckingResult!, _, _) in
            let range = result.rangeAtIndex(result.numberOfRanges - 2)
            let temp = domString as NSString
            let content = temp.substringWithRange(range)
            items += DomItem(text: content)
        }
        
        return items
    }
    
    class func regexWithQuery(query: String) -> NSRegularExpression {
        if let cache = DHQueryCache.get(query) {
            return cache
        } else {
            let queries = query.componentsSeparatedByString(" ")
            let pattern = patternWithQueries(queries)
            let regex = regexWithPattern(pattern)
            DHQueryCache.set(query, value: regex)
            return regex
        }
    }
    
    class func patternWithQueries(queries: String[]) -> String {
        var pattern = ""
        var count = 0
        
        for var i = queries.count; i-- > 0; {
            let q = queries[i]
            let type = selectorTypeWithQuery(q);
            let capturingNumber = count == 0 ? i + 2 : i + 1
            let temp = patternWithQuery(q, capturingNum: capturingNumber)
            
            if count == 0 {
                let joined = "".join(temp.map{"\($0)"})
                pattern = "(\(joined))"
            } else {
                pattern = temp[0] + pattern + "[\\s\\S]*?" + temp[1]
            }
            
            count++
        }
        
        return pattern
    }
    
    class func patternWithQuery(query: String, capturingNum: Int = 1) -> String[] {
        let type = selectorTypeWithQuery(query)
        
        switch type {
        case .IdSelector:
            var idName = query.substringFromIndex(1)
            return patternWithId(idName, capturingNum: capturingNum)
        case .ClassSelector:
            var className = query.substringFromIndex(1)
            return patternWithClassName(className, capturingNum: capturingNum)
        default:
            return patternWithTagName(query, capturingNum: capturingNum)
        }
    }
    
    class func regexWithPattern(pattern: String) -> NSRegularExpression {
        return NSRegularExpression.regularExpressionWithPattern(pattern, options: NSRegularExpressionOptions(0), error: nil)
    }
    
    class func patternWithTagName(tagName: String, capturingNum: Int? = 1) -> String[] {
        return ["<(\(tagName))\\b[\\s\\S]*?", "\\\(capturingNum)>"]
    }
    
    class func patternWithId(idName: String, capturingNum: Int? = 1) -> String[] {
        return ["<([\\S]*)[^>]*id=[\'\"]\(idName)[\'\"][\\s\\S]*?", "\\\(capturingNum)>"]
    }
    
    class func patternWithClassName(className: String, capturingNum: Int? = 1) -> String[] {
        return ["<([\\S]*)[^>]*class=[\'\"]\(className)[\'\"][\\s\\S]*?", "\\\(capturingNum)>"]
    }
}

extension String {
    func itemsWithQuery(query: String) -> DomItem[] {
        return DHDomParser.itemsWithQuery(self, query: query)
    }
}