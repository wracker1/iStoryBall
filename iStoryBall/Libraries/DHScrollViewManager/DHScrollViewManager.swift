//
//  DHScrollViewManager.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 25..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class DHScrollLoader: UIControl {
    
}

class DHScrollViewManager: NSObject {
    enum Subviews: Int {
        case Indicator = 10
    }
    
    let ctx = UnsafeMutablePointer<()>()
    let loaderHeight: CGFloat = 30.0
    let loadOffset: CGFloat = 150.0
    
    weak var scrollView: UIScrollView?
    weak var viewController: UIViewController?
    
    var bottomLoader: DHScrollLoader?
    var bottomEnable = true
    var isLoading = false
    
    init(scrollView: UIScrollView, viewController: UIViewController) {
        self.scrollView = scrollView
        self.viewController = viewController
        
        super.init()
        
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: .Old | .New, context: ctx)
    }
    
    deinit {
        scrollView?.removeObserver(self, forKeyPath: "contentOffset", context: ctx)
    }
    
    override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafeMutablePointer<()>) {
        if (context == ctx) {
            var oldValue = change["old"]!.CGPointValue()
            var newValue = change["new"]!.CGPointValue()
            
            if oldValue.y != newValue.y {
                if let b = bottomLoader {
                    checkBottomLoader(oldValue, n: newValue)
                }
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    func checkBottomLoader(o: CGPoint, n: CGPoint) {
        var diff = o.y - n.y
        
        if diff < 0 && needToLoadBottom(n) {
            bottomLoader?.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        }
        
        if let bottom = bottomLoader {
            if !bottom.hidden {
                bottom.frame = bottomLoaderFrame()
            }
        }
    }
    
    func needToLoadBottom(offset: CGPoint) -> Bool {
        if bottomEnable {
            var o = scrollView!.contentSize.height - scrollView!.frame.size.height - offset.y
            return o < loadOffset && !isLoading
        } else {
            return false
        }
    }
    
    func addTarget(target: AnyObject?, bottomLoaderAction: Selector) {
        if let b = bottomLoader {
            b.removeFromSuperview()
        }
        
        bottomLoader = loader(target, action: bottomLoaderAction)
        scrollView!.addSubview(bottomLoader!)
    }
    
    func loader(target: AnyObject?, action: Selector) -> DHScrollLoader {
        let size = scrollView!.bounds.size
        var loader = DHScrollLoader(frame: CGRectMake(0, 0, size.width, loaderHeight))
        
        loader.addTarget(target, action: action, forControlEvents: UIControlEvents.ValueChanged)
        loader.backgroundColor = scrollView!.backgroundColor
        loader.hidden = true
        
        var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        indicator.tag = Subviews.Indicator.toRaw()
        loader.addSubview(indicator)
        indicator.layoutCenterInParentView()
        
        return loader
    }
    
    func startBottomLoader() {
        if let b = bottomLoader {
            isLoading = true
            
            b.frame = bottomLoaderFrame()
            b.hidden = false
            
            var indicator = activityIndicator(b)
            indicator.startAnimating()
            
            UIView.animateWithDuration(0.3) {
                self.scrollView!.contentInset = UIEdgeInsetsMake(0, 0, self.loaderHeight, 0)
            }
        }
    }
    
    func endBottomLoader() {
        if let b = bottomLoader {
            UIView.animateWithDuration(0.3,
                animations: {
                    self.scrollView!.contentInset = UIEdgeInsetsZero
                }) {
                    (finish: Bool) in
                    
                    var indicator = self.activityIndicator(b)
                    indicator.stopAnimating()
                    
                    b.hidden = true
                    self.isLoading = false
                }
        }
    }
    
    func activityIndicator(loader: DHScrollLoader) -> UIActivityIndicatorView {
        var tag = Subviews.Indicator.toRaw()
        var indicator = loader.viewWithTag(tag)
        return indicator as UIActivityIndicatorView
    }
    
    func bottomLoaderFrame() -> CGRect {
        var cSize = scrollView!.contentSize
        var size = bottomLoader!.frame.size
        return CGRectMake(0, cSize.height, size.width, size.height)
    }
}
