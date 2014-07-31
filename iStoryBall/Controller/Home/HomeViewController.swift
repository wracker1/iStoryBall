//
//  HomeViewController.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 8..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import QuartzCore

class HomeViewController : SBViewController, DHPageScrollViewDataSource, DHPageScrollViewDelegate, UITableViewDataSource, UITableViewDelegate
{
    var recommendStories: [TFHppleElement] = []
    var recommendStoryScrollView: DHPageScrollView?
    var recommendStoryPageControl: UIPageControl?
    
    var dayOfWeeks: [NSDate] = []
    var dayOfWeeksCount = 6
    var dayOfWeekScrollView: DHPageScrollView?
    
    var contentsData = Dictionary<String, [TFHppleElement]>()
    var contentTableView: UITableView?
    var presentContent = Array<TFHppleElement>()
    var allowContentLoad = false
    
    var contentSearchQuery = ".list_product li a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeTitleView("스토리볼")
        
        if recommendStories.count == 0 {
            NetClient.instance.get("/", success: {
                (html: String) in
                self.doc = html.htmlDocument()
                self.layoutSubviews()
                })
        }
    }
    
    func layoutSubviews() {
        recommendStories = doc!.itemsWithQuery(".link_banner")
        createTopFeaturingSlide()
        
        createDayOfWeekScrollView()
        
        var todayStories = doc!.itemsWithQuery(contentSearchQuery)
        var key = contentKeyAtIndex(dayOfWeeksCount)
        contentsData[key] = todayStories
        
        createContentTableView()
    }
    
    func createTopFeaturingSlide() {
        var bounds = self.view.bounds
        recommendStoryScrollView = DHPageScrollView(frame: CGRectMake(1, 0, bounds.width, 90), dataSource: self)
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
    
    func createDayOfWeekScrollView() {
        var components = NSDateComponents()
        var cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        
        for fromNow in 0 ... dayOfWeeksCount {
            components.day = (fromNow * -1)
            var date = cal.dateByAddingComponents(components, toDate: NSDate(), options: NSCalendarOptions(0))
            dayOfWeeks += date
        }
        
        dayOfWeeks = dayOfWeeks.reverse()
        var width = self.view.bounds.size.width
        var scrollView = DHPageScrollView(frame: CGRectMake(0, 0, width, ComponentSize.HorinzontalScrollerHeight.valueOf()), dataSource: self)
        dayOfWeekScrollView = scrollView
        dayOfWeekScrollView!.delegate = self
        dayOfWeekScrollView!.clipsToBounds = false
        self.view.addSubview(dayOfWeekScrollView)
        
        var pageCount = dayOfWeeksCount
        dayOfWeekScrollView!.layoutBottomFromSibling(recommendStoryScrollView!)
        dayOfWeekScrollView!.reloadData {
            scrollView.scrollToPage(pageCount, animated: false)
            self.allowContentLoad = true
            self.loadContentAtIndex(pageCount)
        }
    }

    func createContentTableView() {
        var bounds = self.view.bounds
        var height = bounds.size.height - (recommendStoryScrollView!.bounds.size.height + dayOfWeekScrollView!.bounds.size.height)
        contentTableView = UITableView(frame: CGRectMake(0, 0, bounds.width, height), style: .Plain)
        contentTableView!.dataSource = self
        contentTableView!.delegate = self
        contentTableView!.layer.borderColor = UIColor.rgb(181, g: 182, b: 187).CGColor
        contentTableView!.layer.borderWidth = 1.0
        self.view.addSubview(contentTableView)
        
        contentTableView!.layoutBottomInParentView()
    }
    
    func pageControlDidTouched() {
        var page = self.recommendStoryPageControl!.currentPage
        self.recommendStoryScrollView!.scrollToPage(page, animated: true)
    }
    
    func loadContentAtIndex(index: Int) {
        if allowContentLoad {
            var key = contentKeyAtIndex(index)
            var contents = contentsData[key]
            
            if let c = contents {
                presentContent = c
                contentTableView!.reloadData()
            } else {
                NetClient.instance.get("/episode/part/day/\(key)") {
                    (html: String) in
                    var doc = html.htmlDocument()
                    var items = doc.itemsWithQuery(self.contentSearchQuery)
                    self.contentsData[key] = items
                    self.presentContent = items
                    self.contentTableView!.reloadData()
                }
            }
        }
    }
    
    func contentKeyAtIndex(index: Int) -> String {
        var date = dayOfWeeks[index]
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.stringFromDate(date)
    }
    
    func updateRecommendStoryPageView(pageView: DHPageView, atPage page: Int) {
        var data = recommendStories[page]
        var contentView = UIImageView(frame: recommendStoryScrollView!.bounds)
        contentView.contentMode = UIViewContentMode.ScaleAspectFill
        
        var thumbImageNode = data.itemWithQuery(".thumb_img")
        var imageUrl = thumbImageNode!.imageUrlFromHppleElement()
        contentView.setImageWithURL(NSURL(string: imageUrl))
        
        var title = recommendStoryTitleFromData(data)
        var pointLabel = UILabel.boldFontLabel(title.title, fontSize: SBFontSize.font1.valueOf())
        pointLabel.textColor = UIColor.whiteColor()
        pointLabel.padding(UIEdgeInsetsMake(1, 3, 1, 3))
        pointLabel.backgroundColor = UIColor.redColor()
        pointLabel.layer.masksToBounds = true
        pointLabel.layer.cornerRadius = 5.0
        contentView.addSubview(pointLabel)
        
        var titleLabel = UILabel.systemFontLabel(title.subTitle, fontSize: SBFontSize.font2.valueOf())
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.shadowColor = UIColor.blackColor()
        titleLabel.shadowOffset = CGSizeMake(1, 1)
        contentView.addSubview(titleLabel)

        pointLabel.layoutBottomInParentView(.Left, offset: CGPointMake(7, -15))
        titleLabel.layoutRightFromSibling(pointLabel, verticalAlign: .Center, offset: CGPointMake(3, 0))
        
        pageView.contentView = contentView
    }
    
    func recommendStoryTitleFromData(data: TFHppleElement) -> (title: String, subTitle: String) {
        var titleNode = data.itemWithQuery(".tit_banner")
        var point = titleNode!.itemsWithQuery(".info_txt")[0] as TFHppleElement
        var title = titleNode!.children[2] as TFHppleElement
        return (point.text().trim(), title.content.trim())
    }
    
    func updatedayOfWeekScrollViewPageView(pageView: DHPageView, atPage page: Int) {
        if page < dayOfWeeks.count {
            var data = dayOfWeeks[page]
            var view = UIView(frame: dayOfWeekScrollView!.bounds)
            var color = UIColor.rgb(76.0, g: 134.0, b: 237.0)
            
            var formatter = NSDateFormatter()
            formatter.dateFormat = "EEEE"
            var weekday = formatter.stringFromDate(data)
            var weekdayLabel = UILabel.boldFontLabel(weekday, fontSize: SBFontSize.font5.valueOf())
            weekdayLabel.textColor = color
            view.addSubview(weekdayLabel)
            weekdayLabel.layoutTopInParentView(.Center, offset: CGPointMake(0, 3))
            
            formatter.dateFormat = "M.dd"
            var dateString = page == (dayOfWeeks.count - 1) ? "Today \(formatter.stringFromDate(data))" : "최종업데이트 \(formatter.stringFromDate(data))"
            var dateLabel = UILabel.systemFontLabel(dateString, fontSize: SBFontSize.font2.valueOf())
            dateLabel.padding(UIEdgeInsetsMake(2, 4, 2, 4))
            dateLabel.textColor = color
            dateLabel.layer.borderColor = color.CGColor
            dateLabel.layer.borderWidth = 1.0
            dateLabel.layer.cornerRadius = 5.0
            
            view.addSubview(dateLabel)
            dateLabel.layoutBottomFromSibling(weekdayLabel)
            
            pageView.contentView = view
        }
    }
    
//    DHPageScrollViewDataSource
    func numberOfPagesInScrollView(scrollView: DHPageScrollView) -> Int {
        var count = 0
        
        if scrollView == recommendStoryScrollView {
            count = recommendStories.count
        } else if scrollView === dayOfWeekScrollView {
            count = dayOfWeeks.count
        }
        
        return count
    }
    
    func scrollView(scrollView: DHPageScrollView, pageViewAtPage page: Int) -> DHPageView? {
        var pageView: DHPageView!
        
        pageView = scrollView.dequeueReusablePageView()
        
        if pageView == nil {
            pageView = DHPageView(frame: scrollView.bounds)
        }
        
        if scrollView === recommendStoryScrollView {
            updateRecommendStoryPageView(pageView, atPage: page)
        } else if scrollView === dayOfWeekScrollView {
            updatedayOfWeekScrollViewPageView(pageView, atPage: page)
        }
        
        return pageView
    }
    
//    DHPageScrollViewDelegate
    func scrollView(scrollView: DHPageScrollView?, didChangePage page: Int) -> Void {
        switch scrollView {
        case let x where x! === recommendStoryScrollView:
            recommendStoryPageControl!.currentPage = page
        case let x where x! === dayOfWeekScrollView:
            loadContentAtIndex(page)
        default:
            assert(false)
        }
    }
    
    func scrollView(scrollView: DHPageScrollView!, didSelectPageViewAtPage page: Int) {
        if scrollView === recommendStoryScrollView {
            var data = recommendStories[page]
            var id = data.attributes["href"] as NSString
            var title = recommendStoryTitleFromData(data)
            
            var listViewController = ListViewController(title: title.title)
            listViewController.id = id as String
            
            self.navigationController.pushViewController(listViewController, animated: true)
        }
    }
    
//    UITableViewDataSource
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return presentContent.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cellId = EpisodeListCell.reuseIdentifier()
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? EpisodeListCell
        
        if cell == nil {
            cell = EpisodeListCell()
        }
        
        var data = presentContent[indexPath.row]
        cell!.update(data)
        
        return cell
    }
    
//    UITableViewDelegate
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var data = presentContent[indexPath.row]
        var href = data.attributes["href"] as? NSString
        
        if let link = href {
            var title = data.itemWithQuery(".tit_product")
            var episodeViewController = EpisodeViewController(title: title!.text().trim())
            episodeViewController.id = link
            self.navigationController.pushViewController(episodeViewController, animated: true)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
}