//
//  CommentCell.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 29..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class CommentCell: SBTableViewCell
{
    var profileView: UIImageView?
    var nicknameLabel: UILabel
    var contentLabel: UILabel
    
    class func maxCommentLabelFrame() -> CGRect {
        var size = UIScreen.mainScreen().bounds.size
        var inset = cellContentInset()
        var profileSize = thumbnailSize()
        return CGRectMake(0, 0, size.width - (profileSize.width + inset.left + inset.right), 0)
    }
    
    class func thumbnailSize() -> CGSize {
        return CGSizeMake(37, 34.5)
    }
    
    class func cellContentInset() -> UIEdgeInsets {
        return UIEdgeInsetsMake(3, 7, 3, 4)
    }
    
    class func minHeight() -> CGFloat {
        return 44.0
    }
    
    init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        contentLabel = UILabel.systemFontLabel("", fontSize: SBFontSize.cellTitle.valueOf())
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .Left
        
        nicknameLabel = UILabel.systemFontLabel("", fontSize: SBFontSize.cellSubTitle.valueOf())
        nicknameLabel.textColor = UIColor.grayColor()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.addSubview(contentLabel)
        self.addSubview(nicknameLabel)
    }
    
    override func update(model: SBModel) {
        var commentModel = model as Comment
        
        commentModel.loadProfileImage(CommentCell.thumbnailSize()) {
            if let s = self.profileView {
                s.superview.removeFromSuperview()
            }
            
            self.layout(commentModel)
        }
    }
    
    override class func heightForRowWithModel(model: SBModel) -> CGFloat {
        var commentModel = model as Comment
        
        if let height = commentModel.cellHeight {
            return height
        } else {
            var label = UILabel.systemFontLabel("", fontSize: SBFontSize.cellTitle.valueOf())
            label.textAlignment = .Left
            label.numberOfLines = 0
            label.frame = maxCommentLabelFrame()
            label.text = commentModel.commentContent
            label.sizeToFit()
            
            var inset = self.cellContentInset()
            var calcHeight = label.bounds.size.height + SBFontSize.cellSubTitle.valueOf() + (inset.top * 2 + inset.bottom * 2)
            
            var height = max(calcHeight, CommentCell.minHeight())
            commentModel.cellHeight = height
            return height
        }
    }
    
    func layout(model: Comment) {
        var size = self.bounds.size
        var inset = CommentCell.cellContentInset()
        var profileSize = CommentCell.thumbnailSize()
        
        profileView = model.profileView
        self.addSubview(profileView)
        profileView!.layoutLeftInParentView(.Center, offset: CGPointMake(5, 0))
        
        contentLabel.text = model.commentContent
        contentLabel.frame = CommentCell.maxCommentLabelFrame()
        contentLabel.sizeToFit()
        contentLabel.layoutTopInParentView(.Left, offset: CGPointMake(profileSize.width + inset.left, inset.top))
        
        nicknameLabel.text = model.daumName
        nicknameLabel.sizeToFit()
        nicknameLabel.layoutBottomFromSibling(contentLabel, horizontalAlign: .Left, offset: CGPointMake(0, inset.top))
    }
}
