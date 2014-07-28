//
//  ThemeEpisodeCell.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 28..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class ThemeEpisodeCell: UICollectionViewCell
{
    var maxTitleLabelFrame: CGRect
    var thumbnailView: UIImageView
    var titleLabel: UILabel
    var title: String {
    get {
        return titleLabel.text
    }
    set {
        titleLabel.text = newValue
        titleLabel.frame = maxTitleLabelFrame
        titleLabel.sizeToFit()
        
        titleLabel.layoutBottomFromSibling(thumbnailView, horizontalAlign: .Left, offset: CGPointMake(5.0, 10.0))
    }
    }
    
    init(frame: CGRect) {
        let thumbHeight: CGFloat = 110.0
        let bottomGap: CGFloat = 50.0
        let size = frame.size
        
        maxTitleLabelFrame = CGRectMake(0, 0, size.width, size.height - (thumbHeight + bottomGap))
        thumbnailView = UIImageView(frame: CGRectMake(0, 0, size.width, thumbHeight))
        
        titleLabel = UILabel.systemFontLabel("", fontSize: 12.0)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .Left
        titleLabel.frame = maxTitleLabelFrame
        
        super.init(frame: frame)
        
        self.addSubview(thumbnailView)
        self.addSubview(titleLabel)
    }
}
