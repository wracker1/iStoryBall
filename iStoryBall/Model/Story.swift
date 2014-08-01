//
//  Story.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 8. 1..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class Story: SBModel
{
    var title: String?
    var link: String?
    var imageUrl: String?
    var thumbnailView: UIImageView?
    
    init(hppleElement: TFHppleElement) {
        super.init(hppleElement: hppleElement)
        
        if let url = thumbnailUrl() {
            imageUrl = url
            thumbnailView = UIImageView(frame: CGRectZero)
            thumbnailView!.setImageWithURL(NSURL(string: url))
        }
        
        title = titleString()
        link = hppleElement.attributes["href"] as? NSString
    }
}
