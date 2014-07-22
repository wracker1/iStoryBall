//
//  HomeViewController.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 8..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import QuartzCore

class HomeViewController : SBViewController, DHPageScrollViewDataSource, DHPageScrollViewDelegate
{
    var doc: TFHpple?
    var recommendStories: [TFHppleElement] = []
    var recommendStoryScrollView: DHPageScrollView?
    var recommendStoryPageControl: UIPageControl?
    
    var dailyStories: [TFHppleElement] = []
    var dailyScrollView: DHPageScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if recommendStories.count == 0 {
            NetClient.instance.get("/", success: {
                (html: String) in
                self.doc = html.htmlDocument()
                self.recommendStories = self.doc!.itemsWithQuery(".link_banner")
                self.createTopFeaturingSlide()
                
                self.dailyStories = self.doc!.itemsWithQuery(".list_product li a")
                self.createContentTable()
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
        recommendStoryScrollView!.delegate = self
        self.view.addSubview(recommendStoryScrollView)
        recommendStoryScrollView!.layoutTopInParentView()
        
        createPageControl()
        recommendStoryScrollView!.reloadData()
    }
    
    func createPageControl() {
        recommendStoryPageControl = UIPageControl()
        recommendStoryPageControl!.currentPage = 0
        recommendStoryPageControl!.numberOfPages = recommendStories.count
        recommendStoryPageControl!.currentPageIndicatorTintColor = UIColor.blueColor()
        recommendStoryPageControl!.pageIndicatorTintColor = UIColor.grayColor()
        recommendStoryPageControl!.addTarget(self, action: Selector("pageControlDidTouched"), forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(recommendStoryPageControl)
        
        recommendStoryPageControl!.layoutBottomFromSibling(recommendStoryScrollView!, horizontalAlign: .Center, offset: CGPointMake(0, -7))
    }
    
    func createContentTable() {
        println(self.dailyStories)
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
            var title = titleNode.children[2] as TFHppleElement
            
            var pointLabel = CommonUI.boldFontLabel(point.text().trim(), fontSize: 9)
            pointLabel.textColor = UIColor.whiteColor()
            pointLabel.backgroundColor = UIColor.redColor()
            pointLabel.layer.masksToBounds = true
            pointLabel.layer.cornerRadius = 1.5
            button.addSubview(pointLabel)
            
            var titleLabel = CommonUI.systemFontLabel(title.content.trim(), fontSize: 9)
            titleLabel.textColor = UIColor.whiteColor()
            titleLabel.shadowColor = UIColor.blackColor()
            titleLabel.shadowOffset = CGSizeMake(1, 1)
            button.addSubview(titleLabel)
            
            pointLabel.layoutBottomInParentView(.Left, offset: CGPointMake(7, -15))
            titleLabel.layoutRightFromSibling(pointLabel, verticalAlign: .Bottom, offset: CGPointMake(3, -15))
        }
        
        pageView.contentView = button
    }
    
//    DHPageScrollViewDelegate
    func scrollViewDidChangePage(scrollView: DHPageScrollView?, didChangePage page: Int) -> Void {
        self.recommendStoryPageControl!.currentPage = page
    }
}