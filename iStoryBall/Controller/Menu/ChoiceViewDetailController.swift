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
    
    
    override func viewWillAppear(animated: Bool) {
        if let urlString = url {
            NetClient.instance.get(urlString, success: {
                (html: String) in
                
                self.doc = html.htmlDocument()
                //var recommend = self.doc?.itemsWithQuery(".")
                
                self.initView()
                })
            
        }
        super.viewWillAppear(animated)
    }
    
    func initView() {
        var recommend:TFHppleElement = self.doc?.itemsWithQuery(".link_recomm")[0] as TFHppleElement
        var imageElement:TFHppleElement = recommend.itemsWithQuery(".thumb_img")[0] as TFHppleElement

        var imageUrl = imageElement.imageUrlFromHppleElement()
        var title = recommend.attributes["title"] as NSString

        var label = UILabel()
        label.frame = CGRectMake(0, 0, 320, 70)
        label.text = title
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(label)
        
        var image = UIImage(data: NSData(contentsOfURL: NSURL(string:imageUrl)))
        var imageView = UIImageView(image: image)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(imageView)
        
        var labelHConst = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label(>=200)]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["label": label])
        var imageHConst = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[image(>=200)]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["image": imageView])
        var vConst = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[label(70)]-[image(>=100)]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["label": label, "image": imageView])
        
        self.view.addConstraints(labelHConst)
        self.view.addConstraints(imageHConst)
        self.view.addConstraints(vConst)
        
    }
    
}
