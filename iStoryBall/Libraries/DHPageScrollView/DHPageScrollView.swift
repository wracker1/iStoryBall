//
//  DHPageScrollView.swift
//  DHPageScrollView
//
//  Created by Jesse on 2014. 7. 11..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import UIKit

@objc protocol DHPageScrollViewDataSource
{
    func numberOfPagesInScrollView(scrollView: DHPageScrollView) -> Int
    
    func scrollView(scrollView: DHPageScrollView, pageViewAtPage page: Int) -> DHPageView?
}

@objc protocol DHPageScrollViewDelegate: NSObjectProtocol, UIScrollViewDelegate
{
    optional func scrollView(scrollView: DHPageScrollView!, didChangePage page: Int) -> Void
    
    optional func scrollView(scrollView: DHPageScrollView!, didSelectPageViewAtPage page: Int) -> Void
}

class DHPageView: UIScrollView
{
    var page: Int?
    var touchEndBlock: ((page: Int) -> Void)?
    var _contentView: UIView?
    var contentView: UIView? {
    set {
        if _contentView == nil {
            if let v = newValue {
                _contentView = v
                self.addSubview(v)
            }
        }
    }
    get {
        return _contentView
    }
    }
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.directionalLockEnabled = true
        self.scrollsToTop = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let v = _contentView {
            var selfSize = self.bounds.size
            var viewSize = v.bounds.size
            var x = (selfSize.width - viewSize.width) / 2
            var y = (selfSize.height - viewSize.height) / 2
            
            v.frame = CGRectMake(CGFloat(x), CGFloat(y), viewSize.width, viewSize.height)
        }
    }
    
    func removeContentView() {
        if let view = contentView {
            view.removeFromSuperview()
            _contentView = nil
        }
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        if let block = touchEndBlock {
            block(page: page!)
        }
    }
}

class DHPageScrollView: UIScrollView, NSCoding
{
    weak var dataSource: DHPageScrollViewDataSource!
    weak var _delegate: DHPageScrollViewDelegate!

    var currentPage = 0
    var reloadFinishBlock: (() -> Void)?
    var bufferSize = 2
    var pageViews: [DHPageView] = []
    var pageViewDict = Dictionary<String, DHPageView>()
    var page: Int {
    get {
        let width = self.bounds.size.width
        var p = Int((self.contentOffset.x + (width / 2)) / width)
        
        if p < 0 {
            p = 0
        }
        return p
    }
    }
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, dataSource: DHPageScrollViewDataSource) {
        super.init(frame: frame)
        
        self.pagingEnabled = true
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.scrollsToTop = false
        self.dataSource = dataSource
        self.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.New, context: nil)
        
        forcedChangePage(0)
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafeMutablePointer<()>) {
        if page != currentPage {
            changePage(page)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var p = numberOfPages()
        var cSize = contentSizeByPages(p)
        
        if !CGSizeEqualToSize(cSize, self.contentSize) {
            self.contentSize = cSize
            
            if let finish = reloadFinishBlock {
                finish()
            }
        }
    }
    
    func changePage(page: Int) {
        if currentPage != page {
            _changePage(page)
        }
    }
    
    func forcedChangePage(page: Int) {
        _changePage(page)
    }
    
    func _changePage(page: Int) {
        var numberOfPages = dataSource?.numberOfPagesInScrollView(self)
        
        if page < numberOfPages {
            currentPage = page
            
            requestPageViewAtPage(currentPage)
            checkContentLeft(currentPage - 1)
            checkContentRight(currentPage + 1)
            
            if let d = _delegate {
                d.scrollView?(self, didChangePage: page)
            }
        }
    }
    
    func checkContentLeft(page: Int) {
        if (page > -1) {
            var minIdx = currentPage - bufferSize
            
            if page < minIdx {
                dettachPageViewAtPage(page)
            } else {
                requestPageViewAtPage(page)
            }
            
            checkContentLeft(page - 1)
        }
    }
    
    func checkContentRight(page: Int) {
        if page < numberOfPages() {
            var maxIdx = currentPage + bufferSize
            
            if page > maxIdx {
                dettachPageViewAtPage(page)
            } else {
                requestPageViewAtPage(page)
            }
            
            checkContentRight(page + 1)
        }
    }
    
    func requestPageViewAtPage(page: Int) {
        var key = "\(page)"
        var old = pageViewDict[key]
        
        if old == nil {
            if let d = dataSource {
                var pageView = d.scrollView(self, pageViewAtPage: page)
                
                if let item = pageView {
                    item.page = page
                    item.touchEndBlock = {
                        (page: Int) in
                        
                        if let d = self._delegate {
                            d.scrollView?(self, didSelectPageViewAtPage: page)
                        }
                    }
                    
                    if !contains(pageViews, item) {
                        pageViews.append(item)
                    }
                    
                    item.frame = rectByPage(page)
                    self.addSubview(item)
                    
                    pageViewDict[key] = item
                }
            }
        }
    }
    
    func dettachPageViewAtPage(page: Int) {
        var key = "\(page)"
        var pageView = pageViewDict[key]
        
        if let item = pageView {
            if item.superview != nil {
                item.removeContentView()
                item.removeFromSuperview()
                item.page = nil
                pageViewDict.removeValueForKey(key)
            }
        }
    }
    
    func scrollToPage(page: Int, animated: Bool) {
        if page > -1 && page < numberOfPages() {
            var rect = rectByPage(page)
            changePage(page)
            self.scrollRectToVisible(rect, animated: animated)
        }
    }
    
    func rectByPage(page: Int) -> CGRect {
        var size = self.bounds.size
        return CGRectMake(CGFloat(page) * size.width, 0, size.width, size.height)
    }
    
    func contentSizeByPages(pages: Int) -> CGSize {
        var size = self.bounds.size
        return CGSizeMake(size.width * CGFloat(pages), size.height)
    }
    
    func numberOfPages() -> Int {
        var count = 0
        
        if let d = dataSource {
            count = d.numberOfPagesInScrollView(self)
        }
        
        return count
    }
    
    func dequeueReusablePageView() -> DHPageView? {
        var pageView: DHPageView?
        
        for item in pageViews {
            if item.page == nil {
                pageView = item
                break
            }
        }
        return pageView
    }
    
    func reloadData(finishBlock: (() -> Void)?) {
        var p = numberOfPages()
        reloadFinishBlock = finishBlock
        
        for i in 0 ..< pageViews.count {
            dettachPageViewAtPage(i)
            
            if i >= p {
                pageViews.removeAtIndex(i)
            }
        }
        
        forcedChangePage(currentPage)
        setNeedsLayout()
    }
}