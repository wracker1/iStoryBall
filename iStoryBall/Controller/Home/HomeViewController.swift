//
//  HomeViewController.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 8..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class HomeViewController : SBViewController, DHPageScrollViewDataSource
{
    var doc: TFHpple?
    var recommendStories: [TFHppleElement] = []
    var recommendStoryScrollView: DHPageScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if recommendStories.count == 0 {
            NetClient.instance.get("/", success: {
                (html: String) in
                self.doc = html.htmlDocument()
                self.recommendStories = self.doc!.itemsWithQuery(".link_banner")
                self.createTopFeaturingSlide()
                })
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func createTopFeaturingSlide() {
        var topMargin = Common.commonTopMargin()
        self.recommendStoryScrollView = DHPageScrollView(frame: CGRectMake(0, topMargin, 320, 90), dataSource: self)
        self.recommendStoryScrollView!.dataSource = self
        self.view.addSubview(self.recommendStoryScrollView)
    }
    
//    DHPageScrollViewDataSource
    func numberOfPagesInScrollView(scrollView: DHPageScrollView) -> Int {
        var count = 0
        
        if scrollView == recommendStoryScrollView {
            count = recommendStories.count
        }
        
        return count
    }
    
    func scrollViewContentViewAtPage(scrollView: DHPageScrollView, contentViewAtPage page: Int) -> UIView? {
        var data: TFHppleElement!

        var button = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button.frame = self.recommendStoryScrollView!.bounds
        button.imageView.contentMode = UIViewContentMode.ScaleAspectFill

        if scrollView == recommendStoryScrollView {
            data = recommendStories[page]
            var results = data.itemsWithQuery(".thumb_img")
            
            if results.count > 0 {
                var thumbImageNode = results[0] as TFHppleElement
                var imageUrl = Common.imageUrlFromHppleElement(thumbImageNode)
                button.setImageForState(UIControlState.Normal, withURL: NSURL(string: imageUrl))
            }
        }
        
        return button
    }
}