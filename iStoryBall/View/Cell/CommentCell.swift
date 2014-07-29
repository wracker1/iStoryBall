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
    var profileSize = CGSizeMake(37, 37)
    
    init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        contentLabel = UILabel.systemFontLabel("", fontSize: 10)
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .Left
        
        nicknameLabel = UILabel.systemFontLabel("", fontSize: 10)
        nicknameLabel.textColor = UIColor.grayColor()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(contentLabel)
        self.addSubview(nicknameLabel)
    }
    
    override func update(model: SBModel) {
        var commentModel = model as Comment
        
        commentModel.loadProfileImage(nil) {
            if let s = self.profileView {
                s.superview.removeFromSuperview()
            }
            
            self.layout(commentModel)
        }
    }
    
    override class func heightForRowWithModel(model: SBModel) -> CGFloat {
        var commentModel = model as Comment
        var label = UILabel.systemFontLabel("", fontSize: 10)
        label.textAlignment = .Left
        label.numberOfLines = 0
        label.frame = maxCommentLabelFrame()
        label.text = commentModel.commentContent
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
    
    func layout(model: Comment) {
        var size = self.bounds.size
        var inset = CommentCell.cellContentInset()
        
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
