//
//  HomeViewController.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 8..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class HomeViewController : SBViewController, DHPageScrollViewDataSource, DHPageScrollViewDelegate
{
    var doc: TFHpple?
    var recommendStories: [TFHppleElement] = []
    var recommendStoryScrollView: DHPageScrollView?
    var recommendStoryPageControl: UIPageControl?
    
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
        recommendStoryScrollView = DHPageScrollView(frame: CGRectMake(0, topMargin, 320, 90), dataSource: self)
        recommendStoryScrollView!.setTranslatesAutoresizingMaskIntoConstraints(false)
        recommendStoryScrollView!.dataSource = self
        recommendStoryScrollView!.delegator = self
        self.view.addSubview(recommendStoryScrollView)
        
        var slideDict = Dictionary<String, UIView>()
        slideDict["slide"] = recommendStoryScrollView
        var slideHConst = NSLayoutConstraint.constraintsWithVisualFormat("H:|[slide(>=320)]|", options: NSLayoutFormatOptions(0), metrics: nil, views: slideDict)
        self.view.addConstraints(slideHConst)
        
        var pageControl = UIPageControl()
        pageControl.setTranslatesAutoresizingMaskIntoConstraints(false)
        pageControl.frame = CGRectMake(0, 0, 130, 10)
        pageControl.currentPage = 0
        pageControl.numberOfPages = self.recommendStories.count
        pageControl.currentPageIndicatorTintColor = UIColor.blueColor()
        pageControl.pageIndicatorTintColor = UIColor.grayColor()
        self.view.addSubview(pageControl)
        self.recommendStoryPageControl = pageControl
        
        var pageControlDict = Dictionary<String, UIView>()
        pageControlDict["page"] = pageControl
        var pageHConst = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(>=110)-[page(100)]-(>=110)-|", options: NSLayoutFormatOptions(0), metrics: nil, views: pageControlDict)
        self.view.addConstraints(pageHConst)
        
        var dict = Dictionary<String, UIView>()
        dict["slide"] = recommendStoryScrollView
        dict["pageControl"] = pageControl
        var vConst = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(<=\(topMargin))-[slide(>=90)]-(-25)-[pageControl]", options: NSLayoutFormatOptions(0), metrics: nil, views: dict)
        self.view.addConstraints(vConst)
        
        recommendStoryScrollView!.reloadData()
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
    
//    DHPageScrollViewDelegate
    func scrollViewDidChangePage(scrollView: DHPageScrollView?, didChangePage page: Int) -> Void {
        self.recommendStoryPageControl!.currentPage = page
    }
}