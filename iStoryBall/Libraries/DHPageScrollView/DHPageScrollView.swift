//
//  DHPageScrollView.swift
//  DHPageScrollView
//
//  Created by Jesse on 2014. 7. 11..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import UIKit

protocol DHPageScrollViewDataSource: NSObjectProtocol
{
    func numberOfPagesInScrollView(scrollView: DHPageScrollView) -> Int
    
    func scrollViewContentViewAtPage(scrollView: DHPageScrollView, contentViewAtPage page: Int) -> UIView?
}

protocol DHPageScrollViewDelegate: UIScrollViewDelegate
{
    func scrollViewDidChangePage(scrollView: DHPageScrollView, didChangePage page: Int) -> Void
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
        _scrollView.addObserver(self, forKeyPath: "presentPage", options: NSKeyValueObservingOptions.New, context: nil)
    }
    get {
        return _scrollView
    }
    }
    
    init(frame: CGRect) {
        super.init(frame: frame)
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.scrollsToTop = false
    }
    
    override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafePointer<()>) {
        var dict = change as Dictionary
        var present: AnyObject? = dict["new"]
        
        if let p = present as? Double {
            checkPresentPage(p)
        }
    }
    
    func checkPresentPage(presentPage: Double) {
        var diff = fabs(presentPage - Double(page))
        
        if Int(diff) > bufferSize {
            removeContentView()
        } else {
            var content = self.scrollView.loadPageScrollViewContentViewAtPage(page)
            self.contentView = content
//            self.contentSize = self.bounds.size
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
    var presentPage = 0
    var pageViews: [DHPageScrollViewContainer] = []
    
    var page: Int {
    get {
        let width = self.bounds.size.width
        var p = Int((self.contentOffset.x + (width / 2)) / width)
        let max = numberOfPage() - 1
        
        if max < p {
            p = max
        } else if p < 0 {
            p = 0
        }
        return p
    }
    }
    
    init(frame: CGRect) {
        super.init(frame: frame)
        
        self.pagingEnabled = true
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.scrollsToTop = false
        self.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        syncronizePageView()
    }
    
    func syncronizePageView() {
        var pages = numberOfPage()
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
            * presentPage를 DHPageScrollViewContainer아 옵저버를 하고 있기 때문에 페이지 확인 후 컨텐츠를 불러오게 된다.
            */
            var temp = presentPage
            presentPage = temp
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
//            pageView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleLeftMargin
        }
    }
    
    func loadPageScrollViewContentViewAtPage(page: Int) -> UIView? {
        return dataSource.scrollViewContentViewAtPage(self, contentViewAtPage: page)
    }
    
    func numberOfPage() -> Int {
        return dataSource!.numberOfPagesInScrollView(self)
    }
    
    func changePage(page: Int) {
        if presentPage != page {
            presentPage = page
            
            if let d = delegator {
                d.scrollViewDidChangePage(self, didChangePage: page)
            }
        }
    }
    
    func reloadData() {
        self.setNeedsLayout()
    }
    
    //    UIScrollViewDelegate
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView!) {
        changePage(self.page)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView!) {
        changePage(self.page)
    }
}