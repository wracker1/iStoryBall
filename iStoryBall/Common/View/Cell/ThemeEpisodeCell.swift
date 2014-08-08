//
//  ThemeEpisodeCell.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 28..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class ThemeEpisodeCell: UICollectionViewCell
{
    var maxTitleLabelFrame = CGRectZero
    var thumbnailView: UIImageView?
    var titleLabel: UILabel?
    var sympathiesCountButton: UIButton?
    var shareCountButton: UIButton?
    var finishedLabel: UILabel?
    
    var title: String {
    get {
        return titleLabel!.text
    }
    set {
        titleLabel!.text = newValue
        titleLabel!.frame = maxTitleLabelFrame
        titleLabel!.sizeToFit()
        
        titleLabel!.layoutBottomFromSibling(thumbnailView!, horizontalAlign: .Left, offset: CGPointMake(5.0, 10.0))
    }
    }
    
    var sympathies: String {
    get {
        return sympathiesCountButton!.titleLabel.text
    }
    set {
        var inset = UIEdgeInsetsMake(0, 7, 0, 0)
        sympathiesCountButton!.setTitle(newValue, forState: .Normal)
        sympathiesCountButton!.sizeToFit()
        sympathiesCountButton!.titleEdgeInsets = inset
        var frame = sympathiesCountButton!.frame
        frame.size.width += (inset.left + inset.right)
        sympathiesCountButton!.frame = frame
        
        sympathiesCountButton!.layoutBottomInParentView(.Left, offset: CGPointMake(3, -5))
    }
    }
    
    var share: String {
    get {
        return shareCountButton!.titleLabel.text
    }
    set {
        var inset = UIEdgeInsetsMake(0, 7, 0, 0)
        shareCountButton!.setTitle(newValue, forState: .Normal)
        shareCountButton!.sizeToFit()
        shareCountButton!.titleEdgeInsets = inset
        var frame = shareCountButton!.frame
        frame.size.width += (inset.left + inset.right)
        shareCountButton!.frame = frame
        shareCountButton!.layoutRightFromSibling(sympathiesCountButton!, verticalAlign: .Center, offset: CGPointMake(5, 0))
    }
    }
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let thumbHeight: CGFloat = 110.0
        let bottomGap: CGFloat = 50.0
        let size = frame.size
        
        maxTitleLabelFrame = CGRectMake(0, 0, size.width - 10.0, size.height - (thumbHeight + bottomGap))
        thumbnailView = UIImageView(frame: CGRectMake(0, 0, size.width, thumbHeight))
        
        titleLabel = UILabel.systemFontLabel("", fontSize: SBFontSize.cellTitle.valueOf())
        titleLabel!.numberOfLines = 0
        titleLabel!.textAlignment = .Left
        titleLabel!.frame = maxTitleLabelFrame
        
        finishedLabel = UILabel.boldFontLabel("완결", fontSize: SBFontSize.cellSubTitle.valueOf())
        finishedLabel!.textColor = UIColor.whiteColor()
        finishedLabel!.backgroundColor = UIColor.rgba(0, g: 0, b: 0, a: 0.6)
        finishedLabel!.padding(UIEdgeInsetsMake(2, 4, 2, 4))
        finishedLabel!.hidden = true
        finishedLabel!.layer.cornerRadius = 3.0
        finishedLabel!.clipsToBounds = true
        
        sympathiesCountButton = UIButton.buttonWithType(.Custom) as UIButton!
        sympathiesCountButton!.titleLabel.font = UIFont.systemFontOfSize(SBFontSize.font1.valueOf())
        sympathiesCountButton!.setTitleColor(UIColor.grayColor(), forState: .Normal)
        sympathiesCountButton!.setImage(UIImage(named: "ico_empathy"), forState: .Normal)
        sympathiesCountButton!.userInteractionEnabled = false
        
        shareCountButton = UIButton.buttonWithType(.Custom) as UIButton!
        shareCountButton!.titleLabel.font = UIFont.systemFontOfSize(SBFontSize.font1.valueOf())
        shareCountButton!.setTitleColor(UIColor.grayColor(), forState: .Normal)
        shareCountButton!.setImage(UIImage(named: "ico_share"), forState: .Normal)
        shareCountButton!.userInteractionEnabled = false
        
        self.addSubview(thumbnailView!)
        self.addSubview(titleLabel!)
        self.addSubview(finishedLabel!)
        self.addSubview(sympathiesCountButton!)
        self.addSubview(shareCountButton!)
        
    }
}
