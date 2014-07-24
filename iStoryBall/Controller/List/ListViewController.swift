//
//  ListViewController.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 23..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class ListViewController: SBViewController
{
    var doc: TFHpple?
    var headerImageView: UIImageView?
    var descView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let storyId = id {
            NetClient.instance.get(storyId) {
                (html: String) in
                
                self.doc = html.htmlDocument()
                self.layoutSubviews()
            }
        }
    }
    
    func layoutSubviews() {
        createHeaderView()
        createStoryDescView()
    }
    
    func createHeaderView() {
        var thumbImageNode = doc!.itemWithQuery(".intro_img .thumb_img")
        var url = thumbImageNode.imageUrlFromHppleElement()
        headerImageView = UIImageView(frame: CGRectMake(0, 0, self.view.bounds.width, 120))
        self.view.addSubview(headerImageView)
        
        headerImageView!.contentMode = UIViewContentMode.ScaleAspectFill
        headerImageView!.activateConstraintsTopInParentView()
        headerImageView!.setImageWithURL(NSURL(string: url))
        headerImageView!.clipsToBounds = true
    }
    
    func createStoryDescView() {
        var data = doc!.itemWithQuery(".intro_cont")
        descView = UIView()
        var height: CGFloat = 0.0
        
        var title = data.itemWithQuery(".tit_intro")
        var titleLabel = UILabel.boldFontLabel(title.text().trim(), fontSize: 15)
        titleLabel.numberOfLines = 0
        titleLabel.frame = CGRectMake(0, 0, self.view.bounds.size.width, 0)
        titleLabel.sizeToFit()
        height += titleLabel.bounds.size.height
        
        self.view.addSubview(descView)
        descView!.frame = CGRectMake(0, 0, self.view.bounds.size.width, height)
        descView!.activateConstraintsBottomFromSibling(headerImageView!)
        
        descView!.addSubview(titleLabel)
        titleLabel.activateConstraintsBottomInParentView(.Left, offset: CGPointMake(5, 10))
    }
}
