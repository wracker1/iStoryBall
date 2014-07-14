//
//  DHPageScrollView.swift
//  DHPageScrollView
//
//  Created by Jesse on 2014. 7. 11..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import UIKit

@class_protocol protocol DHPageScrollViewDataSource
{
    func numberOfPagesInScrollView(scrollView: DHPageScrollView) -> Int
    
    func scrollViewContentViewAtPage(scrollView: DHPageScrollView, contentViewAtPage page: Int) -> UIView?
}

@class_protocol protocol DHPageScrollViewDelegate
{
    func scrollViewDidChangePage(scrollView: DHPageScrollView?, didChangePage page: Int) -> Void
}

class DHPageScrollViewContainer: UIScrollView
{
    var page = 0
    var bufferSize = 2
    
    var _contentView: UIView?
    var contentView: UIView? {
    set {
        if _contentView == nil {
            if let v = newValue {
                _contentView = v
                self.addSubview(v)
                
                var parentSize = self.bounds.size
                var size = v.bounds.size
                var origin = CGPointMake((parentSize.width - size.width) / 2, (parentSize.height - size.height) / 2)
                v.frame = CGRectMake(origin.x, origin.y, size.width, size.height)
                v.autoresizingMask = ~UIViewAutoresizing.None
            }
        }
    }
    get {
        return _contentView
    }
    }
    
    weak var _scrollView: DHPageScrollView!
    var scrollView: DHPageScrollView {
    set {
        _scrollView = newValue
        _scrollView.addObserver(self, forKeyPath: "currentPage", options: NSKeyValueObservingOptions.New, context: nil)
    }
    get {
        return _scrollView
    }
    }
    
    init(frame: CGRect) {
        super.init(frame: frame)
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.directionalLockEnabled = true
        self.scrollsToTop = false
    }
    
    deinit {
        _scrollView.removeObserver(self, forKeyPath: "currentPage", context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafePointer<()>) {
        var dict = change as Dictionary
        var present: AnyObject? = dict["new"]
        
        if let p = present as? Double {
            checkcurrentPage(p)
        }
    }
    
    func checkcurrentPage(currentPage: Double) {
        var diff = fabs(currentPage - Double(page))
        
        if Int(diff) > bufferSize {
            removeContentView()
        } else {
            var content = self.scrollView.loadPageScrollViewContentViewAtPage(page)
            self.contentView = content
            self.contentSize = self.bounds.size
        }
    }
    
    func removeContentView() {
        if let view = contentView {
            view.removeFromSuperview()
            _contentView = nil
        }
    }
}

class DHPageScrollView: UIScrollView, UIScrollViewDelegate
{
    var dataSource: DHPageScrollViewDataSource!
    var delegator: DHPageScrollViewDelegate!
    var useZoom = false
    var currentPage = 0
    var pages = 0
    var pageViews: [DHPageScrollViewContainer] = []
    
    var page: Int {
    get {
        let width = self.bounds.size.width
        var p = Int((self.contentOffset.x + (width / 2)) / width)
        let max = pages - 1
        
        if max < p {
            p = max
        } else if p < 0 {
            p = 0
        }
        return p
    }
    }
    
    init(frame: CGRect, dataSource: DHPageScrollViewDataSource) {
        super.init(frame: frame)
        
        self.pagingEnabled = true
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.scrollsToTop = false
        self.delegate = self
        self.dataSource = dataSource
    }
    
    func reloadData() {
        pages = numberOfPage()
        var diff = pages - pageViews.count
        
        if diff > 0 {
            createPageView(diff)
        } else if diff < 0 {
            diff *= -1
            removePageView(diff)
        }
        
        if diff > 0 {
            for var i = 0; i < pageViews.count; i++ {
                var pageView = pageViews[i]
                pageView.page = i
            }
        }
        
        var size = self.bounds.size
        var contentSize = CGSizeMake(size.width * CGFloat(pages), size.height)
        
        if !CGSizeEqualToSize(contentSize, self.contentSize) {
            self.contentSize = contentSize
            layoutPageViews()
            
            /**
            * currentPage를 DHPageScrollViewContainer아 옵저버를 하고 있기 때문에 페이지 확인 후 컨텐츠를 불러오게 된다.
            */
            var temp = currentPage
            currentPage = temp
        }
    }
    
    func createPageView(count: Int) {
        var size = self.bounds.size
        
        for var i = 0; i < count; i++ {
            var pageView = DHPageScrollViewContainer(frame: self.bounds)
            pageView.scrollView = self
            self.addSubview(pageView)
            pageViews.append(pageView)
        }
    }
    
    func removePageView(count: Int) {
        var i = 0
        
        while i < count {
            var pageView = pageViews.removeLast()
            pageView.removeFromSuperview()
            i++
        }
    }
    
    func layoutPageViews() {
        var size = self.bounds.size
        
        for var i = 0; i < pageViews.count; i++ {
            var pageView = pageViews[i]
            pageView.frame = CGRectMake(Float(i) * size.width, 0, size.width, size.height)
            pageView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleLeftMargin
        }
    }
    
    func loadPageScrollViewContentViewAtPage(page: Int) -> UIView? {
        return dataSource?.scrollViewContentViewAtPage(self, contentViewAtPage: page)
    }
    
    func numberOfPage() -> Int {
        var count = 0
        
        if let d = dataSource {
            count = d.numberOfPagesInScrollView(self)
        }
        
        return count
    }
    
    func changePage(page: Int) {
        if currentPage != page {
            currentPage = page
            
            if let d = delegator {
                d.scrollViewDidChangePage(self, didChangePage: page)
            }
        }
    }
    
    //    UIScrollViewDelegate
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView!) {
        changePage(self.page)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView!) {
        changePage(self.page)
    }
}