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
    var dailyScrollView: DHPageScrollView?
    
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
        recommendStoryScrollView = DHPageScrollView(frame: CGRectMake(0, 0, 320, 90), dataSource: self)
        recommendStoryScrollView!.setTranslatesAutoresizingMaskIntoConstraints(false)
        recommendStoryScrollView!.delegate = self
        self.view.addSubview(recommendStoryScrollView)
        
        var slideDict = Dictionary<String, UIView>()
        slideDict["slide"] = recommendStoryScrollView
        var slideHConst = NSLayoutConstraint.constraintsWithVisualFormat("H:|[slide(>=320)]|", options: NSLayoutFormatOptions(0), metrics: nil, views: slideDict)
        self.view.addConstraints(slideHConst)
        
        createPageControl()
        
        recommendStoryScrollView!.reloadData()
    }
    
    func createPageControl() {
        var pageControl = UIPageControl()
        
        pageControl.setTranslatesAutoresizingMaskIntoConstraints(false)
        pageControl.frame = CGRectMake(0, 0, 80, 5)
        pageControl.currentPage = 0
        pageControl.numberOfPages = self.recommendStories.count
        pageControl.currentPageIndicatorTintColor = UIColor.blueColor()
        pageControl.pageIndicatorTintColor = UIColor.grayColor()
        pageControl.addTarget(self, action: Selector("pageControlDidTouched"), forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(pageControl)
        self.recommendStoryPageControl = pageControl
        
        var pageControlDict = Dictionary<String, UIView>()
        pageControlDict["page"] = pageControl
        var pageHConst = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(>=110)-[page(100)]-(>=110)-|", options: NSLayoutFormatOptions(0), metrics: nil, views: pageControlDict)
        self.view.addConstraints(pageHConst)
        
        var dict = Dictionary<String, UIView>()
        dict["slide"] = recommendStoryScrollView
        dict["pageControl"] = pageControl
        var vConst = NSLayoutConstraint.constraintsWithVisualFormat("V:|[slide(>=90)]-(-25)-[pageControl]", options: NSLayoutFormatOptions(0), metrics: nil, views: dict)
        self.view.addConstraints(vConst)
    }
    
    func pageControlDidTouched() {
        var page = self.recommendStoryPageControl!.currentPage
        self.recommendStoryScrollView!.scrollToPage(page, animated: true)
    }
    
//    DHPageScrollViewDataSource
    func numberOfPagesInScrollView(scrollView: DHPageScrollView) -> Int {
        var count = 0
        
        if scrollView == recommendStoryScrollView {
            count = recommendStories.count
        }
        
        return count
    }
    
    func scrollView(scrollView: DHPageScrollView, pageViewAtPage page: Int) -> DHPageView? {
        var pageView: DHPageView!
        
        pageView = scrollView.dequeueReusablePageView()
        
        if pageView == nil {
            pageView = DHPageView()
        }
        
        if scrollView == recommendStoryScrollView {
            updateRecommendStoryPageView(pageView, atPage: page)
        }
        
        return pageView
    }
    
    func updateRecommendStoryPageView(pageView: DHPageView, atPage page: Int) {
        var data = recommendStories[page]
        var button = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button.frame = self.recommendStoryScrollView!.bounds
        button.imageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        var imageNode = data.itemsWithQuery(".thumb_img")
        var textNode = data.itemsWithQuery(".tit_banner")
        
        if imageNode.count > 0 {
            var thumbImageNode = imageNode[0] as TFHppleElement
            var imageUrl = thumbImageNode.imageUrlFromHppleElement()
            button.setImageForState(UIControlState.Normal, withURL: NSURL(string: imageUrl))
        }
        
        if textNode.count > 0 {
            var titleNode = textNode[0] as TFHppleElement
            var point = titleNode.itemsWithQuery(".info_txt")[0] as TFHppleElement
            var title = titleNode.children[1] as TFHppleElement
            
            var pointLabel = CommonUI.boldFontLabel(point.text(), fontSize: 9)
            pointLabel.textColor = UIColor.whiteColor()
            pointLabel.backgroundColor = UIColor.redColor()
            button.addSubview(pointLabel)
            
            var titleLabel = CommonUI.systemFontLabel(title.text(), fontSize: 9)
            titleLabel.textColor = UIColor.whiteColor()
            titleLabel.shadowColor = UIColor.blackColor()
            titleLabel.shadowOffset = CGSizeMake(1, 1)
            button.addSubview(titleLabel)
        }
        
        pageView.contentView = button
    }
    
//    DHPageScrollViewDelegate
    func scrollViewDidChangePage(scrollView: DHPageScrollView?, didChangePage page: Int) -> Void {
        self.recommendStoryPageControl!.currentPage = page
    }
}