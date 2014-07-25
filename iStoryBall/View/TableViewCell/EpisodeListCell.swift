//
//  EpisodeListCell.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 23..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import UIKit

class EpisodeListCell: SBTableViewCell {
    var thumbnailView: UIImageView
    var titleLabel: UILabel
    var subTitleLabel: UILabel
    
    init() {
        thumbnailView = UIImageView(frame: CGRectMake(0, 0, 55, 43))
        titleLabel = UILabel.boldFontLabel("", fontSize: 11)
        titleLabel.textAlignment = .Left
        
        subTitleLabel = UILabel.systemFontLabel("", fontSize: 9)
        subTitleLabel.textAlignment = .Left
        subTitleLabel.textColor = UIColor.grayColor()
        
        super.init(style: .Default, reuseIdentifier: EpisodeListCell.reuseIdentifier())
        
        self.addSubview(thumbnailView)
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
    }
    
    override func update(data: TFHppleElement) {
        super.update(data)
        
        var size = self.bounds.size
        
        if let imageUrl = thumbnailUrl() {
            thumbnailView.setImageWithURL(NSURL(string:imageUrl))
        }
        
        if let title = titleString() {
            titleLabel.text = title
            titleLabel.frame = CGRectMake(0, 0, size.width - 60, 0)
            titleLabel.sizeToFit()
        }
        
        if let subTitle = subTitleString() {
            subTitleLabel.text = subTitle
            subTitleLabel.sizeToFit()
            
            titleLabel.layoutRightFromSibling(thumbnailView, verticalAlign: .Top, offset: CGPointMake(5, 8))
            subTitleLabel.layoutBottomFromSibling(titleLabel, horizontalAlign: .Left, offset: CGPointMake(0, 3))
        } else {
            titleLabel.layoutRightFromSibling(thumbnailView, verticalAlign: .Center, offset: CGPointMake(5, 0))
        }
    }
}
