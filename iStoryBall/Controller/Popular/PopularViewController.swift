//
//  PopularViewController.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 8..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class PopularViewController : SBViewController, DHPageScrollViewDataSource
{
    var storyType = Array<(name: String, desc: String)>()
    var storyTypeScroller: DHPageScrollView?
    var storyTableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storyType += ("공감순", "공감 1등은 뉴규")
        storyType += ("공유순", "나만 보기 아까워")
        storyType += ("구독순", "두고두고 볼꺼야")
        storyType += ("판매순", "돈내도 안아까워")
        
        NetClient.instance.get("/story/pop/hit") {
            (html: String) in
            
        }
        
        layoutSubviews()
    }
    
    func layoutSubviews() {
        createStoryTypeScroller()
    }
    
    func createStoryTypeScroller() {
        var width = self.view.bounds.size.width / 3 * 2
        storyTypeScroller = DHPageScrollView(frame: CGRectMake(0, 0, width, 43), dataSource: self)
        self.view.addSubview(storyTypeScroller)
        storyTypeScroller!.layoutTopInParentView()
        storyTypeScroller!.clipsToBounds = false
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
}
