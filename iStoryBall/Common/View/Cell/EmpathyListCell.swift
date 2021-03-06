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
    var iconImageView: UIImageView
    var iconImage: UIImage
    
    override init() {
        var width = UIScreen.mainScreen().bounds.width
        thumbnailView = UIImageView(frame: CGRectMake(10, 10, width - 20, 115))
        
        titleLabel = UILabel.boldFontLabel("", fontSize: SBFontSize.cellTitle.valueOf())
        titleLabel.textAlignment = .Left
        
        rankLabel = UILabel.boldFontLabel("", fontSize: SBFontSize.cellSubTitle.valueOf())
        iconImage = UIImage(named:"ico_empathy")
        iconImageView = UIImageView(image: iconImage)
        
        super.init(style: .Default, reuseIdentifier: EpisodeListCell.reuseIdentifier())
        
        self.addSubview(thumbnailView)
        self.addSubview(titleLabel)
        iconImageView.addSubview(rankLabel)
        thumbnailView.addSubview(iconImageView)
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
            iconImageView.frame = CGRectMake(0, 0, 42, 40)
            iconImageView.backgroundColor = UIColor.clearColor()
            iconImageView.layoutBottomInParentView(.Right, offset:CGPointMake(-5, -5))
            
            rankLabel.text = sympathy_count as NSString
            rankLabel.sizeToFit()
            rankLabel.textColor = UIColor.whiteColor()
            rankLabel.layoutCenterInParentView(CGPointMake(0, -3))
        }
    }
    
    override func titleString() -> NSString? {
        return data?.itemWithQuery(".tit_empathy")?.text().trim()
    }
    
    override func thumbnailUrl() -> NSString? {
        var imageElement = data?.itemWithQuery(".thumb_img")
        return imageElement?.imageUrlFromHppleElement()
    }
    
    func sympathyCount() -> NSString? {
        return data?.itemWithQuery(".ico_sympathy")?.text().trim()
    }
}