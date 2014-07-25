//
//  PopularViewController.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 8..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class PopularViewController : SBViewController, DHPageScrollViewDataSource, DHPageScrollViewDelegate, UITableViewDataSource, UITableViewDelegate
{
    var storyType = Array<(name: String, desc: String, id: String)>()
    var storyTypeScroller: DHPageScrollView?
    var storyTableView: UITableView?
    var storyDataList = Dictionary<String, [TFHppleElement]>()
    var presentStoryList: [TFHppleElement]?
    var contentSearchQuery = ".list_product li a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storyType += ("공감순", "공감 1등은 뉴규", "hit")
        storyType += ("공유순", "나만 보기 아까워", "share")
        storyType += ("구독순", "두고두고 볼꺼야", "subscribe")
        storyType += ("판매순", "돈내도 안아까워", "sale")
        
        id = "/story/pop"
        var url = id! + "/" + storyType[0].id
        
        NetClient.instance.get(url) {
            (html: String) in
            self.doc = html.htmlDocument()
            self.layoutSubviews()
        }
    }
    
    func layoutSubviews() {
        var key = storyType[0].id
        var items = doc!.itemsWithQuery(contentSearchQuery)
        storyDataList[key] = items
        presentStoryList = items
        
        createStoryTypeScroller()
        createStoryTableView()
    }
    
    func createStoryTypeScroller() {
        var width = self.view.bounds.size.width / 3 * 2
        storyTypeScroller = DHPageScrollView(frame: CGRectMake(0, 0, width, 43), dataSource: self)
        self.view.addSubview(storyTypeScroller)
        storyTypeScroller!.layoutTopInParentView()
        storyTypeScroller!.clipsToBounds = false
        storyTypeScroller!.delegate = self
    }
    
    func createStoryTableView() {
        var size = self.view.bounds.size
        var height = size.height - storyTypeScroller!.bounds.size.height
        
        storyTableView = UITableView(frame: CGRectMake(0, 0, size.width, height), style: .Plain)
        storyTableView!.dataSource = self
        self.view.addSubview(storyTableView)
        storyTableView!.layoutBottomInParentView()
    }
    
    func updateStoryScrollerPageView(pageView: DHPageView, page: Int) {
        var data = storyType[page]
        var color = UIColor.rgb(76.0, g: 134.0, b: 237.0)
        
        var titleLabel = UILabel.boldFontLabel(data.name, fontSize: 17)
        titleLabel.textColor = color
        pageView.addSubview(titleLabel)
        titleLabel.layoutTopInParentView(.Center, offset: CGPointMake(0, 2))
        
        var descLabel = UILabel.systemFontLabel(data.desc, fontSize: 10)
        descLabel.textColor = color
        pageView.addSubview(descLabel)
        descLabel.layoutBottomFromSibling(titleLabel, horizontalAlign: .Center, offset: CGPointMake(0, 2))
    }
    
    func numberOfPagesInScrollView(scrollView: DHPageScrollView) -> Int {
        return storyType.count
    }
    
    func scrollView(scrollView: DHPageScrollView, pageViewAtPage page: Int) -> DHPageView? {
        var pageView = scrollView.dequeueReusablePageView()
        
        if pageView == nil {
            pageView = DHPageView(frame: scrollView.bounds)
        }
        
        updateStoryScrollerPageView(pageView!, page: page)
        
        return pageView
    }
    
    func scrollView(scrollView: DHPageScrollView!, didChangePage page: Int) {
        var key = storyType[page].id
        var items = storyDataList[key]
        
        if let stories = items {
            presentStoryList = stories
            storyTableView!.reloadData()
        } else {
            var url = id! + "/" + key
            NetClient.instance.get(url) {
                (html: String) in
                var newItems = html.htmlDocument().itemsWithQuery(self.contentSearchQuery)
                self.storyDataList[key] = newItems
                self.presentStoryList = newItems
                self.storyTableView!.reloadData()
            }
        }
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return presentStoryList!.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        return nil
    }
}
