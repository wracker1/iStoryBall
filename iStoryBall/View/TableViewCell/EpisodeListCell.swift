//
//  EpisodeListCell.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 23..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import UIKit

class EpisodeListCell: UITableViewCell {
    class func reuseIdentifier() -> String {
        return "EpisodeListCell"
    }
    
    var thumbnailView: UIImageView
    var titleLabel: UILabel
    var subTitleLabel: UILabel
    
    init() {
        thumbnailView = UIImageView(frame: CGRectMake(0, 0, 55, 43))
        titleLabel = UILabel.boldFontLabel("", fontSize: 11)
        titleLabel.textAlignment = .Left
        titleLabel.numberOfLines = 0
        
        subTitleLabel = UILabel.systemFontLabel("", fontSize: 9)
        subTitleLabel.textAlignment = .Left
        subTitleLabel.textColor = UIColor.grayColor()
        
        super.init(style: .Default, reuseIdentifier: EpisodeListCell.reuseIdentifier())
        
        self.addSubview(thumbnailView)
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
    }
    
    func update(data: TFHppleElement) {
        var size = self.bounds.size
        var imageNode = data.itemWithQuery(".thumb_view")
        var imageUrlString = imageNode.attributes["src"] as? NSString
        thumbnailView.setImageWithURL(NSURL(string:imageUrlString))

        var titleNode = data.itemWithQuery(".tit_product")
        titleLabel.text = titleNode.text().trim()
        titleLabel.frame = CGRectMake(0, 0, size.width - 60, 0)
        titleLabel.sizeToFit()
        
        var subTitle = data.attributes["title"] as? NSString
        
        if let s = subTitle {
            subTitleLabel.text = s
            subTitleLabel.sizeToFit()
            
            titleLabel.layoutRightFromSibling(thumbnailView, verticalAlign: .Top, offset: CGPointMake(5, 8))
            subTitleLabel.layoutBottomFromSibling(titleLabel, horizontalAlign: .Left, offset: CGPointMake(0, 3))
        } else {
            titleLabel.layoutRightFromSibling(thumbnailView, verticalAlign: .Center, offset: CGPointMake(5, 0))
        }
    }
}
