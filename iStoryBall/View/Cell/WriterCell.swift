//
//  WriterCell.swift
//  iStoryBall
//
//  Created by 정 다정 on 2014. 7. 30..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class WriterCell: SBTableViewCell
{
    var profileView: UIImageView?
    var nicknameLabel: UILabel
    var descriptionLabel: UILabel
    var profileSize = CGSizeMake(37, 37)
    
    init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        nicknameLabel = UILabel.systemFontLabel("", fontSize: 12)
        nicknameLabel.numberOfLines = 0
        nicknameLabel.textAlignment = .Left
        
        descriptionLabel = UILabel.systemFontLabel("", fontSize: 10)
        descriptionLabel.textColor = UIColor.grayColor()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(nicknameLabel)
        self.addSubview(descriptionLabel)
    }
    
    override func update(model: SBModel) {
        var writerModel = model as Writer
        
        writerModel.loadProfileImage(nil) {
            if let s = self.profileView {
                s.superview.removeFromSuperview()
            }
            self.layout(writerModel)
        }
    }
    
    class func minHeight() -> CGFloat {
        return 44.0
    }
    
    override class func heightForRowWithModel(model: SBModel) -> CGFloat {
        var writerModel = model as Writer
        var label = UILabel.systemFontLabel("", fontSize: 10)
        label.textAlignment = .Left
        label.numberOfLines = 0
        label.frame = maxCommentLabelFrame()
        label.text = writerModel.description
        label.sizeToFit()
        return max(label.bounds.size.height + 20.0, 39)
    }
    
    class func maxCommentLabelFrame() -> CGRect {
        var size = UIScreen.mainScreen().bounds.size
        var inset = cellContentInset()
        var profileSize = CGSizeMake(37, 37)
        return CGRectMake(0, 0, size.width - (profileSize.width + inset.left + inset.right), 0)
    }
    
    class func cellContentInset() -> UIEdgeInsets {
        return UIEdgeInsetsMake(3, 7, 3, 4)
    }
    
    
    class func thumbnailSize() -> CGSize {
        return CGSizeMake(37, 34.5)
    }
    
    func layout(model: Writer) {
        println("layout")
        var size = self.bounds.size
        var inset = WriterCell.cellContentInset()
        var profileSize = WriterCell.thumbnailSize()
        
        profileView = model.profileView
        self.addSubview(profileView)
        profileView!.layoutLeftInParentView(.Center, offset: CGPointMake(5, 0))
        
        
        nicknameLabel.text = model.name
        println(model.name)
        nicknameLabel.sizeToFit()
        nicknameLabel.layoutTopInParentView(.Left, offset: CGPointMake(profileSize.width + inset.left, inset.top))
        
        descriptionLabel.text = model.description
        descriptionLabel.frame = WriterCell.maxCommentLabelFrame()
        descriptionLabel.sizeToFit()
        descriptionLabel.layoutBottomFromSibling(nicknameLabel, horizontalAlign: .Left, offset: CGPointMake(0, inset.top))
        
    }
}
