//
//  StoryListCell.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 25..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class StoryListCell: SBTableViewCell {
    var thumbnailView: UIImageView
    var titleLabel: UILabel
    var rankLabel: UILabel
    
    override init() {
        thumbnailView = UIImageView(frame: CGRectMake(0, 0, 55, 43))
        
        titleLabel = UILabel.boldFontLabel("", fontSize: SBFontSize.cellTitle.valueOf())
        titleLabel.textAlignment = .Left
        
        rankLabel = UILabel.boldFontLabel("", fontSize: SBFontSize.cellSubTitle.valueOf())
        rankLabel.textColor = UIColor.whiteColor()
        
        super.init(style: .Default, reuseIdentifier: EpisodeListCell.reuseIdentifier())
        
        self.addSubview(thumbnailView)
        self.addSubview(titleLabel)
        self.addSubview(rankLabel)
    }
    
    override func update(model: SBModel) {
        super.update(model)
     
        let story = model as Story
        
        if let image = story.thumbnailView?.image {
            thumbnailView.image = image
        } else {
            thumbnailView.setImageWithURL(NSURL(string: story.imageUrl!))
        }
        
        if let title = story.title {
            titleLabel.text = title
            titleLabel.sizeToFit()
            titleLabel.layoutRightFromSibling(thumbnailView, verticalAlign: .Center, offset: CGPointMake(5, 0))
        }
        
        var rank = indexPath!.row + 1
        rankLabel.backgroundColor = rank < 4 ? UIColor.rgba(76, g: 134, b: 237, a: 0.6) : UIColor.rgba(0, g: 0, b: 0, a: 0.6)
        rankLabel.text = "\(rank)"
        rankLabel.sizeToFit()
        rankLabel.padding(UIEdgeInsetsMake(2, 4, 2, 4))
        rankLabel.layoutTopInParentView(.Left)
    }
}
