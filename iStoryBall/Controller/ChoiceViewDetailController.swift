//
//  ChoiceViewDetailController.swift
//  iStoryBall
//
//  Created by 정 다정 on 2014. 7. 21..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import Foundation

class ChoiceViewDetailController: SBViewController{
    var doc: TFHpple?
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

        var image = imageElement.imageUrlFromHppleElement()
        var title = recommend.attributes["title"] as NSString

        var label = UILabel()
        label.frame = CGRectMake(0, 0, 320, 70)
        label.text = title
        self.view.addSubview(label)
    }
    
}
