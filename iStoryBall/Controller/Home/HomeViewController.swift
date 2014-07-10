//
//  HomeViewController.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 8..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class HomeViewController : SBViewController
{
    var doc: TFHpple?
    var recommendStories: [TFHppleElement]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetClient.instance.get("/", success: {
            (html: String) in
            
            self.doc = html.htmlDocument()
            self.recommendStories = self.doc!.itemsWithQuery(".link_banner")
            println(self.recommendStories!.count)
            })
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
}