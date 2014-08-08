//
//  StoryPageDat.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 28..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class StoryPageData: SBModel
{
    var episodeId: String
    var pageId: String
    var pageNo: Int
    var imageUrlString: String?
    
    override init(data: Dictionary<String, AnyObject>) {
        var eId = data["episodeId"] as NSNumber
        episodeId = String(eId.integerValue)
        
        var pId = data["pageId"] as NSNumber
        pageId = String(pId.integerValue)
        
        var pNo = data["pageNo"] as NSNumber
        pageNo = pNo.integerValue
        
        super.init(data: data)
    }

    func loadImageUrl(imageUrlBlock: ((imageUrlString: String) -> Void)?) {
        if let url = imageUrlString {
            imageUrlBlock?(imageUrlString: url)
        } else {
            var url = "/episode/part/\(episodeId)/\(pageId)"
            
            NetClient.instance.get(url) {
                (html: String) in
                
                var str = html as NSString
                var exp = NSRegularExpression.regularExpressionWithPattern("<img\\s*src=\".*?storyBall\\/([^\"]+)\"", options: NSRegularExpressionOptions(0), error: nil)
                var range = NSMakeRange(0, str.length)
                var result = exp.firstMatchInString(html, options: NSMatchingOptions(0), range: range)
                var imageKey = str.substringWithRange(result.rangeAtIndex(1))
                
                var urlString = "http://m1.daumcdn.net/thumb/R640x0/U03/storyBall/\(imageKey)"
                self.imageUrlString = urlString
                
                imageUrlBlock?(imageUrlString: urlString)
            }
        }
    }
}
