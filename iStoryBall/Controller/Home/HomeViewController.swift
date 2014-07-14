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
    var recommendStoryScrollView: UIScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recommendStoryScrollView = DHPageScrollView(frame: CGRectMake(0, 0, 320, 180))
        recommendStoryScrollView!.backgroundColor = UIColor.redColor()
        self.view.addSubview(recommendStoryScrollView)
        
        NetClient.instance.get("/", success: {
            (html: String) in
            
            self.doc = html.htmlDocument()
            self.recommendStories = self.doc!.itemsWithQuery(".link_banner")
            })
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
}