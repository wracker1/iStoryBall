//
//  HomeContentCell.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 23..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import UIKit

class HomeContentCell: UITableViewCell {
    class func reuseIdentifier() -> String {
        return "HomeContentCell"
    }
    
    var thumbnailView: UIImageView
    
    init() {
        thumbnailView = UIImageView(frame: CGRectMake(0, 0, 55, 43))
        thumbnailView.backgroundColor = UIColor.redColor()
        
        super.init(style: .Default, reuseIdentifier: HomeContentCell.reuseIdentifier())
        
        self.addSubview(thumbnailView)
        
        
        
//        imageView.frame = CGRectMake(0, 0, 55, 43)
//        imageView.backgroundColor = UIColor.redColor()
    }
    
    func update(data: TFHppleElement) {
//        var imageNode = data.itemWithQuery(".thumb_view")
//        var imageUrlString = imageNode.attributes["src"] as? NSString
//        imageView.setImageWithURL(NSURL(string:imageUrlString))
//        
//        var titleNode = data.itemWithQuery(".tit_product")
//        textLabel.font = UIFont.boldSystemFontOfSize(12)
//        textLabel.text = titleNode.text()
        
//        var subTitle = data.attributes["title"] as NSString
//        detailTextLabel.text = subTitle
//        detailTextLabel.textColor = UIColor.grayColor()
//        detailTextLabel.font = UIFont.systemFontOfSize(9)
    }
}
