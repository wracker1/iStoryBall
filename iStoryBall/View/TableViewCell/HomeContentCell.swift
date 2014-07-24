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
    var titleLabel: UILabel
    var subTitleLabel: UILabel
    
    init() {
        thumbnailView = UIImageView(frame: CGRectMake(0, 0, 55, 43))
        titleLabel = UILabel.boldFontLabel("", fontSize: 12)
        titleLabel.textAlignment = .Left
        subTitleLabel = UILabel.systemFontLabel("", fontSize: 9)
        subTitleLabel.textAlignment = .Left
        subTitleLabel.textColor = UIColor.grayColor()
        
        super.init(style: .Default, reuseIdentifier: HomeContentCell.reuseIdentifier())
        
        self.addSubview(thumbnailView)
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
    }
    
    func update(data: TFHppleElement) {
        var imageNode = data.itemWithQuery(".thumb_view")
        var imageUrlString = imageNode.attributes["src"] as? NSString
        thumbnailView.setImageWithURL(NSURL(string:imageUrlString))

        var titleNode = data.itemWithQuery(".tit_product")
        titleLabel.text = titleNode.text()
        titleLabel.sizeToFit()
        
        var subTitle = data.attributes["title"] as NSString
        subTitleLabel.text = subTitle
        subTitleLabel.sizeToFit()
        
        titleLabel.layoutRightFromSibling(thumbnailView, verticalAlign: .Top, offset: CGPointMake(5, 8))
        subTitleLabel.layoutRightFromSibling(thumbnailView, verticalAlign: .Bottom, offset: CGPointMake(5, -6))
    }
}
