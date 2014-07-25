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
    var imageWrapperView:UIView = UIView() as UIView
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
        var recommend:TFHppleElement = self.doc?.itemsWithQuery(".link_recomm")[0] as TFHppleElement
        var imageElement:TFHppleElement = recommend.itemsWithQuery(".thumb_img")[0] as TFHppleElement
        
        var imageUrl = imageElement.imageUrlFromHppleElement()
        var title = recommend.attributes["title"] as NSString
        
        
        
        var label = UILabel()
        label.frame = CGRectMake(0, 0, 320, 70)
        label.text = title
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        //self.view.addSubview(label)
        
        var image = UIImage(data: NSData(contentsOfURL: NSURL(string:imageUrl)))
        var imageView = UIImageView(image: image)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        //self.view.addSubview(imageView)
    }
    
    func initView() {
        headLabel = UILabel.boldFontLabel("\"" + headline + "\"", fontSize: 18)
        headLabel.textColor = UIColor.blueColor()
        self.view.addSubview(headLabel)
        headLabel.layoutTopInParentView(.Center, offset: CGPointMake(0, 10))
        
        var descriptionLabel = UILabel.systemFontLabel("선택한 당신을 위한, 스토리는 바로...", fontSize: 13)
        descriptionLabel.textColor = UIColor.blackColor()
        self.view.addSubview(descriptionLabel)
        descriptionLabel.layoutBottomFromSibling(headLabel)
        
        imageWrapperView.frame = CGRectMake(0, 0, self.view.bounds.size.width - 10, 200)
        imageWrapperView.layer.borderColor = UIColor.blackColor().CGColor
        imageWrapperView.layer.borderWidth = 0.5
        imageWrapperView.layer.cornerRadius = 5.0
        self.view.addSubview(imageWrapperView)
        imageWrapperView.layoutBottomFromSibling(descriptionLabel, horizontalAlign: .Center, offset: CGPointMake(0, 10))
        
        imageView.frame = CGRectMake(8, 8, imageWrapperView.bounds.width - 16, imageWrapperView.bounds.height - 50)
        imageWrapperView.addSubview(imageView)
        
        titleLabel = UILabel.boldFontLabel(storytitle, fontSize: 18)
        titleLabel.textColor = UIColor.blackColor()
        imageWrapperView.addSubview(titleLabel)
        titleLabel.layoutBottomInParentView()
        
        var buttonWrapper = UIView()
        
        var recommendButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        recommendButton.frame = CGRectMake(0, 0, 100, 30)
        recommendButton.setTitle("추천받기", forState: UIControlState.Normal)
        recommendButton.addTarget(self, action: "recommend:", forControlEvents: UIControlEvents.TouchUpInside)
        //buttonWrapper!.addSubview(recommendButton)
        recommendButton.activateConstraintsLeftInParentView()
        recommendButton.layer.cornerRadius = 15.0
        recommendButton.layer.borderColor = UIColor.grayColor().CGColor
        recommendButton.layer.borderWidth = 1

    }
    
}
