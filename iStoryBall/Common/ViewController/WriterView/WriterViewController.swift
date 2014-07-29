//
//  WriterViewController.swift
//  iStoryBall
//
//  Created by 정 다정 on 2014. 7. 29..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import Foundation
class WriterViewController : SBViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = id {
            NetClient.instance.get(url + "#layer/writer") {
                (html: String) in
                var newItems = html.htmlDocument().itemsWithQuery("#writerLayerTemplate")
                println(newItems.count)
            }
        }
        
        initView()
    }
    
    func initView() {
        println("initView")
        var statusBarFrame = UIApplication.sharedApplication().statusBarFrame
        var height = statusBarFrame.height
        
        var toolbar = UIToolbar()
        toolbar.frame = CGRectMake(0, height, self.view.bounds.width, 40)
        self.view.addSubview(toolbar)
        
        var closeButton = UIButton()
        closeButton.frame = CGRectMake(0, 0, 80, 40)
        closeButton.setTitle("닫기", forState: .Normal)
        closeButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        closeButton.addTarget(self, action: "closeView:", forControlEvents: UIControlEvents.TouchUpInside)
        
        toolbar.addSubview(closeButton)
        closeButton.layoutLeftInParentView()
    }
    
    func closeView(sender:UIButton!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}