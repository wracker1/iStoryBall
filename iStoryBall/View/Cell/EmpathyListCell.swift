//
//  EmpathyListCell.swift
//  iStoryBall
//
//  Created by 정 다정 on 2014. 7. 28..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import Foundation

class EmpathyListCell: SBTableViewCell {
    var thumbnailView: UIImageView
    var titleLabel: UILabel
    var rankLabel: UILabel
    
    init() {
        var width = UIScreen.mainScreen().bounds.width
        thumbnailView = UIImageView(frame: CGRectMake(10, 10, width - 20, 115))
        
        titleLabel = UILabel.boldFontLabel("", fontSize: 13)
        titleLabel.textAlignment = .Left
        
        rankLabel = UILabel.boldFontLabel("", fontSize: 13)
        
        super.init(style: .Default, reuseIdentifier: EpisodeListCell.reuseIdentifier())
        
        self.addSubview(thumbnailView)
        self.addSubview(titleLabel)
        thumbnailView.addSubview(rankLabel)
    }
    
    override func update(data: TFHppleElement) {
        super.update(data)
        
        if let imageUrl = thumbnailUrl() {
            thumbnailView.setImageWithURL(NSURL(string: imageUrl))
        }
        
        if let title = titleString() {
            titleLabel.text = title
            titleLabel.sizeToFit()
            titleLabel.layoutBottomFromSibling(thumbnailView, horizontalAlign: .Left, offset: CGPointMake(5, 5))
        }
        
        if let sympathy_count = sympathyCount() {
            rankLabel.text = sympathy_count as NSString
            rankLabel.sizeToFit()
            rankLabel.textColor = UIColor.whiteColor()
            rankLabel.padding(UIEdgeInsetsMake(2, 5, 2, 5))
            rankLabel.backgroundColor = UIColor.redColor()
            rankLabel.layer.masksToBounds = true
            rankLabel.layer.cornerRadius = 10.0
            rankLabel.layoutBottomInParentView(.Right, offset:CGPointMake(-5, -5))
        }
    }
    
    override func titleString() -> NSString? {
        return data?.itemWithQuery(".tit_empathy")?.text().trim()
    }
    
    override func thumbnailUrl() -> NSString? {
        var imageElement:TFHppleElement = data?.itemWithQuery(".thumb_img") as TFHppleElement
        return imageElement.imageUrlFromHppleElement()
    }
    
    func sympathyCount() -> NSString? {
        return data?.itemWithQuery(".ico_sympathy")?.text().trim()
    }
}