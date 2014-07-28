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
    var storyType = Array<(id: String, name: String, desc: String, page: Int)>()
    var storyDataList = Dictionary<String, [TFHppleElement]>()
    
    var storyTypeScroller: DHPageScrollView?
    var storyTableView: UITableView?
    var storyTableViewManager: DHScrollViewManager?
    
    var presentStoryList: [TFHppleElement]?
    var contentSearchQuery = ".list_empathy li a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeTitleView("인기")
        
        storyType += ("1000","천공", "천개의 공감", 1)
        storyType += ("soon", "곧천공", "공감 하나만 굽신", 1)
        storyType += ("5000", "오천공", "오천개의 공감", 1)
        storyType += ("all", "올천공", "모두 천공 달성", 1)
        
        id = "/episode/hit"
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
        var width = self.view.bounds.size.width / 2.0
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
        storyTableView!.delegate = self
        storyTableViewManager = DHScrollViewManager(scrollView: storyTableView!, viewController: self)
        storyTableViewManager!.addTarget(self, bottomLoaderAction: Selector("loadMorePage"))
        self.view.addSubview(storyTableView)
        storyTableView!.layoutBottomInParentView()
    }
    
    func loadMorePage() {
        storyTableViewManager!.startBottomLoader()
        var page = storyTypeScroller!.page
        var data = storyType[page]
        
        loadData(data.id, page: data.page + 1, filter: nil) {
            (items: [TFHppleElement]) in
            
            self.didFinishLoadDataAtPage(items, page: page)
        }
    }
    
    func didFinishLoadDataAtPage(items: [TFHppleElement], page: Int) {
        var data = storyType[page]
        var stories = self.storyDataList[data.id] as Array
        var indexPaths = Array<NSIndexPath>()
        var rowNum = stories.count
        
        for item in items {
            stories += item
            indexPaths += NSIndexPath(forRow: rowNum++, inSection: 0)
        }
        
        storyDataList[data.id] = stories
        presentStoryList = stories
        
        data.page += 1
        storyType[page] = data
        
        storyTableView!.insertRowToBottom(indexPaths)
        storyTableViewManager!.endBottomLoader()
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
        var data = storyType[page]
        var key = data.id
        var storyList = storyDataList[key]
        
        storyTableView!.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
        
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
            var title = data.itemWithQuery(".tit_empathy")
            var episodeViewController = EpisodeViewController(title: title!.text().trim())
            episodeViewController.id = link
            self.navigationController.pushViewController(episodeViewController, animated: true)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 155
    }
}
