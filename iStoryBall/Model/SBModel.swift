//
//  SBModel.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 29..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class SBModel
{
    var data: Dictionary<String, AnyObject>?
    var hppleElement: TFHppleElement?
    
    init(data: Dictionary<String, AnyObject>) {
        self.data = data
    }
    
    init (hppleElement: TFHppleElement) {
        self.hppleElement = hppleElement
    }
    
    func thumbnailUrl() -> NSString? {
        return hppleElement?.itemWithQuery(".thumb_view")?.attributes["src"] as? NSString
    }
    
    func titleString() -> NSString? {
        return hppleElement?.itemWithQuery(".tit_product")?.text().trim()
    }
    
    func subTitleString() -> String? {
        return hppleElement?.attributes["title"] as? NSString
    }
}
