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
    var dayOfWeeks: [NSDate] = []
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
        recommendStoryScrollView!.reloadData(nil)
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
        var components = NSDateComponents()
        var cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        
        for fromNow in 0 ... 6 {
            components.day = (fromNow * -1)
            var date = cal.dateByAddingComponents(components, toDate: NSDate(), options: NSCalendarOptions(0))
            dayOfWeeks += date
        }
        
        dayOfWeeks = dayOfWeeks.reverse()
        var scrollView = DHPageScrollView(frame: CGRectMake(0, 0, 180, 43), dataSource: self)
        dailyScrollView = scrollView
        dailyScrollView!.delegate = self
        dailyScrollView!.clipsToBounds = false
        self.view.addSubview(dailyScrollView)
        
        var pageCount = dayOfWeeks.count - 1
        dailyScrollView!.layoutBottomFromSibling(recommendStoryScrollView!)
        dailyScrollView!.reloadData {
            scrollView.scrollToPage(pageCount, animated: false)
        }
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
        } else if scrollView === dailyScrollView {
            count = dayOfWeeks.count
        }
        
        return count
    }
    
    func scrollView(scrollView: DHPageScrollView, pageViewAtPage page: Int) -> DHPageView? {
        var pageView: DHPageView!
        
        pageView = scrollView.dequeueReusablePageView()
        
        if pageView == nil {
            pageView = DHPageView()
        }
        
        if scrollView === recommendStoryScrollView {
            updateRecommendStoryPageView(pageView, atPage: page)
        } else if scrollView === dailyScrollView {
            updateDailyScrollViewPageView(pageView, atPage: page)
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
            
            var pointLabel = CommonUI.boldFontLabel(point.text().trim(), fontSize: 8)
            pointLabel.textColor = UIColor.whiteColor()
            pointLabel.padding(UIEdgeInsetsMake(1, 3, 1, 3))
            pointLabel.backgroundColor = UIColor.redColor()
            pointLabel.layer.masksToBounds = true
            pointLabel.layer.cornerRadius = 5.0
            button.addSubview(pointLabel)
            
            var titleLabel = CommonUI.systemFontLabel(title.content.trim(), fontSize: 10)
            titleLabel.textColor = UIColor.whiteColor()
            titleLabel.shadowColor = UIColor.blackColor()
            titleLabel.shadowOffset = CGSizeMake(1, 1)
            button.addSubview(titleLabel)
            
            pointLabel.layoutBottomInParentView(.Left, offset: CGPointMake(7, -15))
            titleLabel.layoutRightFromSibling(pointLabel, verticalAlign: .Bottom, offset: CGPointMake(3, -15))
        }
        
        pageView.contentView = button
    }
    
    func updateDailyScrollViewPageView(pageView: DHPageView, atPage page: Int) {
        var data = dayOfWeeks[page]
        var view = UIView(frame: dailyScrollView!.bounds)
        var color = UIColor.rgb(76.0, g: 134.0, b: 237.0)
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEEE"
        var weekday = formatter.stringFromDate(data)
        var weekdayLabel = CommonUI.boldFontLabel(weekday, fontSize: 17)
        weekdayLabel.textColor = color
        view.addSubview(weekdayLabel)
        weekdayLabel.layoutTopInParentView()
        
        formatter.dateFormat = "M.dd"
        var dateString = page == (dayOfWeeks.count - 1) ? "Today \(formatter.stringFromDate(data))" : "최종업데이트 \(formatter.stringFromDate(data))"
        var dateLabel = CommonUI.systemFontLabel(dateString, fontSize: 10)
        dateLabel.padding(UIEdgeInsetsMake(2, 4, 2, 4))
        dateLabel.textColor = color
        dateLabel.layer.borderColor = color.CGColor
        dateLabel.layer.borderWidth = 1.0
        dateLabel.layer.cornerRadius = 5.0
        
        view.addSubview(dateLabel)
        dateLabel.layoutBottomFromSibling(weekdayLabel)
        
        
        pageView.contentView = view
    }
    
//    DHPageScrollViewDelegate
    func scrollViewDidChangePage(scrollView: DHPageScrollView?, didChangePage page: Int) -> Void {
        if scrollView === self.recommendStoryScrollView {
            self.recommendStoryPageControl!.currentPage = page
        }
    }
}