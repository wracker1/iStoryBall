//
//  SympathiesViewController.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 8..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import UIKit

class SympathiesViewController : SBViewController, DHPageScrollViewDataSource, DHPageScrollViewDelegate, UITableViewDataSource, UITableViewDelegate
{
    var numberOfItemsPerPage = 20
    
    var storyType = Array<(id: String, name: String, desc: String, page: Int, hasMore: Bool)>()
    var storyDataList = Dictionary<String, [TFHppleElement]>()
    
    var storyTypeScroller: DHPageScrollView?
    var storyTableView: UITableView?
    var storyTableViewManager: DHScrollViewManager?
    var horizontalIndicator: HorizontalScrollIndicator?
    
    var presentStoryList: [TFHppleElement]?
    var contentSearchQuery = "li a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storyType += ("1000","천공", "천개의 공감", 1, true)
        storyType += ("soon", "곧천공", "공감 하나만 굽신", 1, true)
        storyType += ("5000", "오천공", "오천개의 공감", 1, true)
        storyType += ("all", "올천공", "모두 천공 달성", 1, true)
        
        id = "/episode/part/hit"
        var url = id! + "/" + storyType[0].id
        
        NetClient.instance.get(url) {
            (html: String) in
            self.doc = html.htmlDocument()
            self.layoutSubviews()
        }
    }
    
    func layoutSubviews() {
        var items = doc!.itemsWithQuery(contentSearchQuery)
        setPresentStoryListWithIndex(0, items: items)
        
        createStoryTypeScroller()
        createStoryTableView()
    }
    
    func setPresentStoryListWithIndex(index: Int, items: [TFHppleElement]) -> [NSIndexPath] {
        var key = storyType[index].id
        var stories = Array<TFHppleElement>()
        storyType[index].hasMore = items.count == numberOfItemsPerPage
        
        if let list = storyDataList[key] {
            stories = list
        }
        
        var indexPaths = Array<NSIndexPath>()
        var rowNum = stories.count
        
        for item in items {
            stories += item
            indexPaths += NSIndexPath(forRow: rowNum++, inSection: 0)
        }
        
        storyDataList[key] = stories
        presentStoryList = stories
        
        return indexPaths
    }
    
    func createStoryTypeScroller() {
        var width = self.view.bounds.size.width
        var size = CGSizeMake(width, ComponentSize.HorinzontalScrollerHeight.valueOf())
        var frame = CGRect(origin: CGPointZero, size: size)
        
        storyTypeScroller = DHPageScrollView(frame: frame, dataSource: self)
        storyTypeScroller!.delegate = self
        storyTypeScroller!.clipsToBounds = false
        
        horizontalIndicator = HorizontalScrollIndicator(scrollView: storyTypeScroller!)
        self.view.addSubview(horizontalIndicator)
        horizontalIndicator!.layoutTopInParentView()
        
        if let page = storyTypeScroller?.page {
            horizontalIndicator!.didChangePage(page)
        }
    }
    
    func createStoryTableView() {
        var size = self.view.bounds.size
        var height = size.height - storyTypeScroller!.bounds.size.height
        
        storyTableView = UITableView(frame: CGRectMake(0, 0, size.width, height), style: .Plain)
        storyTableView!.dataSource = self
        storyTableView!.delegate = self
        storyTableViewManager = DHScrollViewManager(scrollView: storyTableView!, viewController: self)
        storyTableViewManager!.addTarget(self, bottomLoaderAction: Selector("loadMorePage"))
        self.view.addSubview(storyTableView)
        storyTableView!.layoutBottomInParentView()
    }
    
    func loadMorePage() {
        var page = storyTypeScroller!.page
        
        if storyType[page].hasMore {
            storyTableViewManager!.startBottomLoader()
            var data = storyType[page]
            
            loadData(data.id, page: data.page + 1, filter: nil) {
                (items: [TFHppleElement]) in
                
                self.didFinishLoadDataAtPage(items, page: page)
            }
        }
    }
    
    func didFinishLoadDataAtPage(items: [TFHppleElement], page: Int) {
        var indexPaths = setPresentStoryListWithIndex(page, items: items)
        storyType[page].page += 1
        
        storyTableView!.insertRowToBottom(indexPaths)
        storyTableViewManager!.endBottomLoader()
    }
    
    func updateStoryScrollerPageView(pageView: DHPageView, page: Int) {
        var data = storyType[page]
        var color = UIColor.rgb(76.0, g: 134.0, b: 237.0)
        
        var titleLabel = UILabel.boldFontLabel(data.name, fontSize: SBFontSize.font5.valueOf())
        titleLabel.textColor = color
        pageView.addSubview(titleLabel)
        titleLabel.layoutTopInParentView(.Center, offset: CGPointMake(0, 5))
        
        var descLabel = UILabel.systemFontLabel(data.desc, fontSize: SBFontSize.font2.valueOf())
        descLabel.textColor = color
        pageView.addSubview(descLabel)
        descLabel.layoutBottomFromSibling(titleLabel, horizontalAlign: .Center, offset: CGPointMake(0, 2))
    }
    
    func numberOfPagesInScrollView(scrollView: DHPageScrollView) -> Int {
        var page = storyType.count
        
        if let indicator = horizontalIndicator {
            indicator.numberOfPages = page
        }
        return page
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
        var data = storyType[page]
        var key = data.id
        var storyList = storyDataList[key]
        
        storyTableView!.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
        horizontalIndicator!.didChangePage(page)
        
        if let stories = storyList {
            presentStoryList = stories
            storyTableView!.reloadData()
        } else {
            loadData(key, page: data.page, filter: nil) {
                (items: [TFHppleElement]) in
                
                self.storyDataList[key] = items
                self.presentStoryList = items
                self.storyTableView!.reloadData()
            }
        }
    }
    
    func loadData(key: String, page: Int?, filter: String?, result: ((items: [TFHppleElement]) -> Void)) {
        var url = id! + "/" + key
        
        if let p = page {
            url += "?page=\(p)"
        }
        
        println(url)
        NetClient.instance.get(url) {
            (html: String) in
            var newItems = html.htmlDocument().itemsWithQuery(self.contentSearchQuery)
            
            result(items: newItems)
        }
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return presentStoryList!.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cellId = EmpathyListCell.reuseIdentifier()
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? EmpathyListCell
        
        if cell == nil {
            cell = EmpathyListCell()
        }
        
        var data = presentStoryList![indexPath.row]
        cell!.indexPath = indexPath
        cell!.update(data)
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var data = presentStoryList![indexPath.row]
        var href = data.attributes["href"] as? NSString
        
        if let link = href {
            var isEpisode = link.hasPrefix("/episode")
            var title = data.itemWithQuery(".tit_empathy")?.text()?.trim()
            var viewController: SBViewController?
            
            if isEpisode {
                viewController = EpisodeViewController(title: title!)
            } else {
                viewController = ListViewController(title: title!)
            }
            
            viewController!.id = link
            
            self.navigationController.pushViewController(viewController!, animated: true)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 155
    }
}
