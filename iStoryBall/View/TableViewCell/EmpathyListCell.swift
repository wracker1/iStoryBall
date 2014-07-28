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
    var titleQuery:String = ".tit_empathy"
    var thumbnailQuery:String = ""
    
    init() {
        thumbnailView = UIImageView(frame: CGRectMake(0, 0, 80, 43))
        
        titleLabel = UILabel.boldFontLabel("", fontSize: 11)
        titleLabel.textAlignment = .Left
        
        rankLabel = UILabel.boldFontLabel("", fontSize: 11)
        rankLabel.textColor = UIColor.whiteColor()
        
        super.init(style: .Default, reuseIdentifier: EpisodeListCell.reuseIdentifier())
        
        self.addSubview(thumbnailView)
        self.addSubview(titleLabel)
        self.addSubview(rankLabel)
    }
    
    override func update(data: TFHppleElement) {
        super.update(data)
        
        if let imageUrl = thumbnailUrl() {
            thumbnailView.setImageWithURL(NSURL(string: imageUrl))
        }
        
        if let title = titleString() {
            titleLabel.text = title
            titleLabel.sizeToFit()
            titleLabel.layoutRightFromSibling(thumbnailView, verticalAlign: .Center, offset: CGPointMake(5, 0))
        }
        
        var rank = indexPath!.row
        rankLabel.backgroundColor = rank < 4 ? UIColor.rgba(76, g: 134, b: 237, a: 0.6) : UIColor.rgba(0, g: 0, b: 0, a: 0.6)
        rankLabel.text = "\(rank)"
        rankLabel.sizeToFit()
        rankLabel.padding(UIEdgeInsetsMake(2, 4, 2, 4))
        rankLabel.layoutTopInParentView(.Left)
    }
    
    override func titleString() -> NSString? {
        return data?.itemWithQuery(".tit_empathy")?.text().trim()
    }
    
    override func thumbnailUrl() -> NSString? {
        var imageElement:TFHppleElement = data?.itemsWithQuery(".thumb_img")[0] as TFHppleElement
        return imageElement.imageUrlFromHppleElement()
    }
}