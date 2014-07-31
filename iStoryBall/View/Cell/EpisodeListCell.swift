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
    var titleFontSize: CGFloat
    var subTitleFontSize: CGFloat
    
    init() {
        thumbnailView = UIImageView(frame: CGRectMake(0, 0, 55, 43))
        
        titleFontSize = SBFontSize.font3.valueOf()
        titleLabel = UILabel.boldFontLabel("", fontSize: titleFontSize)
        titleLabel.textAlignment = .Left
        titleLabel.lineBreakMode = .ByTruncatingTail
        
        subTitleFontSize = SBFontSize.font1.valueOf()
        subTitleLabel = UILabel.systemFontLabel("", fontSize: subTitleFontSize)
        subTitleLabel.textAlignment = .Left
        subTitleLabel.lineBreakMode = .ByTruncatingTail
        subTitleLabel.textColor = UIColor.grayColor()
        
        super.init(style: .Default, reuseIdentifier: EpisodeListCell.reuseIdentifier())
        
        self.addSubview(thumbnailView)
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
    }
    
    override func update(data: TFHppleElement) {
        super.update(data)
        
        var size = self.bounds.size
        var maxTitleLabelBounds = CGRectMake(0, 0, size.width - 70, titleFontSize)
        var maxSubLabelBounds = CGRectMake(0, 0, size.width - 70, subTitleFontSize)
        
        if let imageUrl = thumbnailUrl() {
            thumbnailView.setImageWithURL(NSURL(string:imageUrl))
        }
        
        if let title = titleString() {
            titleLabel.text = title
            titleLabel.frame = maxTitleLabelBounds
        }
        
        if let subTitle = subTitleString() {
            subTitleLabel.text = subTitle
            subTitleLabel.frame = maxSubLabelBounds
            
            titleLabel.layoutRightFromSibling(thumbnailView, verticalAlign: .Top, offset: CGPointMake(5, 6))
            subTitleLabel.layoutBottomFromSibling(titleLabel, horizontalAlign: .Left, offset: CGPointMake(0, 2))
        } else {
            titleLabel.layoutRightFromSibling(thumbnailView, verticalAlign: .Center, offset: CGPointMake(5, 0))
        }
    }
}
