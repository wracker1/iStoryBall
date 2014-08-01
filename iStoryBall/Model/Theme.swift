//
//  Theme.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 8. 1..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class Theme: SBModel
{
    var imageUrl: String?
    var thumbnailView: UIImageView?
    var title: String?
    var link: String?
    var sympathiesCount: Int = 0
    var shareCount: Int = 0
    var finished = false
    
    init(hppleElement: TFHppleElement) {
        super.init(hppleElement: hppleElement)
        
        let imageNode = hppleElement.itemWithQuery(".thumb_img")
        imageUrl = imageNode!.imageUrlFromHppleElement()
        
        if let url = imageUrl {
            thumbnailView = UIImageView(frame: CGRectZero)
            thumbnailView!.setImageWithURL(NSURL(string: url))
        }
        
        let titleNode = hppleElement.itemWithQuery(".tit_strory")
        title = titleNode?.text().trim()
        
        finished = hppleElement.itemWithQuery(".sort_story") != nil
        
        let linkNode = hppleElement.itemWithQuery(".link_story")
        link = linkNode!.attributes["href"] as? NSString
        
        let infoNodes = hppleElement.itemsWithQuery(".item_info")
        
        if infoNodes.count > 1 {
            var sympathiesNode: AnyObject = infoNodes[0]
            var shareNode: AnyObject = infoNodes[1]
            
            if let sympathies = sympathiesNode.children?[1] as? TFHppleElement {
                if let count = sympathies.content.trim().toInt() {
                    sympathiesCount = count
                }
            }
            
            if let share = shareNode.children?[1] as? TFHppleElement {
                if let count = share.content.trim().toInt() {
                    shareCount = count
                }
            }
        }
    }
}
