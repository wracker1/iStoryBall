//
//  DHHTMLStringParser.swift
//  DHHTMLStringParser
//
//  Created by Jesse on 2014. 7. 7..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import Foundation

class DHHTMLStringParser: NSObject, NSXMLParserDelegate {
    class var instance: DHHTMLStringParser {
        struct Singleton {
            static let instance = DHHTMLStringParser()
        }

        return Singleton.instance
    }
    
    func documentWithHTMLString(HTMLString: String) -> TFHpple {
        var item = HTMLString as NSString
        let data = item.dataUsingEncoding(NSUTF8StringEncoding)
        return TFHpple(HTMLData: data)
    }
    
    func itemsWithDocument(document: TFHpple, query: String) -> [TFHppleElement] {
        let pattern = convertFromSizzleQueryToXPathQuery(query)
        var result = document.searchWithXPathQuery(pattern)
        return result as [TFHppleElement]
    }
    
    enum SelectorType {
        case IdSelector, ClassSelector, TagSelector
    }
    
    func selectorTypeWithQuery(query: String) -> SelectorType {
        switch query {
        case let x where x.hasPrefix("#"): return .IdSelector
        case let x where x.hasPrefix("."): return .ClassSelector
        default: return .TagSelector
        }
    }
    
    func convertFromSizzleQueryToXPathQuery(query: String) -> String {
        let queries = query.componentsSeparatedByString(" ")
        return patternWithQueries(queries)
    }
    
    func patternWithQueries(queries: [String]) -> String {
        var pattern = ""
        
        for var i = 0; i < queries.count; i++ {
            var q = queries[i]
            pattern += ((i == 0 ? "//" : "/") + patternWithQuery(q))
        }
        
        return pattern
    }
    
    func patternWithQuery(q: String) -> String {
        var query = q as NSString
        let type = selectorTypeWithQuery(query)
        
        switch type {
        case .IdSelector:
            var idName = query.substringFromIndex(1)
            return patternWithId(idName)
        case .ClassSelector:
            var className = query.substringFromIndex(1)
            return patternWithClassName(className)
        default:
            return patternWithTagName(query)
        }
    }
    
    func patternWithTagName(tagName: String) -> String {
        return "\(tagName)"
    }
    
    func patternWithId(idName: String) -> String {
        return "*[@id=\"\(idName)\"]"
    }
    
    func patternWithClassName(className: String) -> String {
        return "*[contains(concat(\" \", normalize-space(@class), \" \"), \" \(className) \")]"
    }
}

extension String {
    func htmlDocument() -> TFHpple {
        return DHHTMLStringParser.instance.documentWithHTMLString(self)
    }
}

extension TFHpple {
    func itemWithQuery(query: String) -> TFHppleElement? {
        var items = itemsWithQuery(query)
        if items.count > 0 {
            return items[0]
        } else {
            return nil
        }
    }
    
    func itemsWithQuery(query: String) -> [TFHppleElement] {
        return DHHTMLStringParser.instance.itemsWithDocument(self, query: query)
    }
}

extension TFHppleElement {
    func itemWithQuery(query: String) -> TFHppleElement? {
        var q = DHHTMLStringParser.instance.convertFromSizzleQueryToXPathQuery(query)
        var items = self.searchWithXPathQuery(q)
        
        if items.count > 0 {
            return items[0] as? TFHppleElement
        } else {
            return nil
        }
    }
    
    func itemsWithQuery(query: String) -> [AnyObject] {
        var q = DHHTMLStringParser.instance.convertFromSizzleQueryToXPathQuery(query)
        return self.searchWithXPathQuery(q)
    }
    
    func imageUrlFromHppleElement() -> String? {
        var url: String?
        var info = self.attributes["style"] as NSString
        
        if info != nil {
            var regex = NSRegularExpression.regularExpressionWithPattern("background(-image)?:\\s*?url\\(([^)]+)", options: NSRegularExpressionOptions(0), error: nil)
            var result = regex.firstMatchInString(info, options: NSMatchingOptions(0), range: NSMakeRange(0, info.length))
            url = info.substringWithRange(result.rangeAtIndex(2))
        }
        
        return url
    }
}