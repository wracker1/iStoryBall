//
//  ChoiceViewDetailController.swift
//  iStoryBall
//
//  Created by 정 다정 on 2014. 7. 21..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import Foundation

class ChoiceViewDetailController: SBViewController{
    var url: String?
    var headline:String = "선택한 값"
    var storytitle:String = "제목"
    var headLabel:UILabel = UILabel() as UILabel
    var titleLabel:UILabel = UILabel() as UILabel
    var imageWrapperView:UIControl = UIControl() as UIControl
    var imageView:UIImageView = UIImageView() as UIImageView
    
    override func viewWillAppear(animated: Bool) {
        requestData()
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        initView()
        super.viewDidLoad()
    }
    
    func requestData() {
        if let urlString = url {
            NetClient.instance.get(urlString, success: {
                (html: String) in
        
                self.doc = html.htmlDocument()
                self.setData()
            })
        }
    }
    
    func setData() {
        println("set data")
        var recommend:TFHppleElement = self.doc?.itemsWithQuery(".link_recomm")[0] as TFHppleElement
        var imageElement:TFHppleElement = recommend.itemsWithQuery(".thumb_img")[0] as TFHppleElement
        
        var imageUrl = imageElement.imageUrlFromHppleElement()
        var title = recommend.attributes["title"] as NSString
        var image = UIImage(data: NSData(contentsOfURL: NSURL(string:imageUrl)))
        imageView.image = image
        imageView.contentMode = UIViewContentMode.ScaleToFill
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        headLabel.text = "\"" + headline + "\""
        titleLabel.text = title
        titleLabel.sizeToFit()
        titleLabel.layoutBottomInParentView()
    }
    
    func initView() {
        headLabel = UILabel.boldFontLabel("\"" + headline + "\"", fontSize: 18)
        headLabel.textColor = UIColor.rgb(0, g: 136, b: 240)
        self.view.addSubview(headLabel)
        headLabel.layoutTopInParentView(.Center, offset: CGPointMake(0, 10))
        
        var descriptionLabel = UILabel.systemFontLabel("선택한 당신을 위한, 스토리는 바로...", fontSize: 13)
        descriptionLabel.textColor = UIColor.blackColor()
        self.view.addSubview(descriptionLabel)
        descriptionLabel.layoutBottomFromSibling(headLabel)
        
        imageWrapperView.frame = CGRectMake(20, 0, self.view.bounds.size.width - 40, 200)
        imageWrapperView.layer.borderColor = UIColor.grayColor().CGColor
        imageWrapperView.layer.borderWidth = 0.5
        imageWrapperView.layer.cornerRadius = 5.0
        self.view.addSubview(imageWrapperView)
        imageWrapperView.layoutBottomFromSibling(descriptionLabel, horizontalAlign: .Center, offset: CGPointMake(0, 10))
        
        imageView.frame = CGRectMake(8, 8, imageWrapperView.bounds.width - 16, imageWrapperView.bounds.height - 50)
        imageWrapperView.addSubview(imageView)
        imageWrapperView.addTarget(self, action: "goStroy:", forControlEvents: UIControlEvents.TouchUpInside)
        
        titleLabel = UILabel.boldFontLabel(storytitle, fontSize: 18)
        titleLabel.textColor = UIColor.blackColor()
        imageWrapperView.addSubview(titleLabel)
        titleLabel.layoutBottomInParentView()
        
        var buttonWrapper = UIView()
        buttonWrapper.frame = CGRectMake(0, 0, imageWrapperView.bounds.width, 50)
        self.view.addSubview(buttonWrapper)
        buttonWrapper.layoutBottomFromSibling(imageWrapperView)

        var shareButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        shareButton.frame = CGRectMake(0, 0, 100, 30)
        shareButton.setTitle("공유하기", forState:UIControlState.Normal)
        shareButton.addTarget(self, action: "share:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonWrapper.addSubview(shareButton)
        shareButton.layer.cornerRadius = 15.0
        shareButton.layer.borderColor = UIColor.grayColor().CGColor
        shareButton.layer.borderWidth = 0.5
        shareButton.layoutLeftInParentView()
        

        var redoButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        redoButton.frame = CGRectMake(0, 0, 100, 30)
        redoButton.setTitle("다시하기", forState:UIControlState.Normal)
        redoButton.addTarget(self, action: "redo:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonWrapper.addSubview(redoButton)
        redoButton.layer.cornerRadius = 15.0
        redoButton.layer.borderColor = UIColor.grayColor().CGColor
        redoButton.layer.borderWidth = 0.5
        redoButton.layoutRightInParentView()
    }
    
    func share(sender: UIButton!) {
        println("share")
    }
    
    func redo(sender: UIButton!) {
        println("redo")
    }
    
    func goStroy(sender: UIControl!) {
        println("go stroy")
    }
    
}
