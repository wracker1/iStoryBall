//
//  EpisodeViewController.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 24..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class EpisodeViewController: SBViewController, DHPageScrollViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate
{
    var contentWebview: SBWebview?
    var contentScroller: DHPageScrollView?
    var commentCount = 0
    var storyInfo: Dictionary<String, AnyObject>?
    var storyEpisode: Dictionary<String, AnyObject>?
    var imageDataList: [StoryPageData]?
    var scrollViewOffset = CGPointZero
    var imageForShare: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let episodeId = id {
            NetClient.instance.get(episodeId) {
                (html: String) in
                
                self.doc = html.htmlDocument()
                
                var raw = html as NSString
                var error: NSError?
                var exp = NSRegularExpression.regularExpressionWithPattern("<(textarea)[^>]*id=\"dataJSONString\"[^>]*>([\\s\\S]+?)<\\/\\s?\\1>",
                    options: NSRegularExpressionOptions(0),
                    error: &error)
                
                var result = exp.firstMatchInString(raw,
                    options: NSMatchingOptions(0),
                    range: NSMakeRange(0, raw.length))
                
                if let r = result {
                    var json = raw.substringWithRange(r.rangeAtIndex(2))
                    
                    error = nil
                    self.storyInfo = self.jsonObjectFromString(json, error: &error)
                } else {
                    println("유료컨텐츠: \(self.id)")
                }
                
                self.layoutSubviews()
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController.setToolbarHidden(true, animated: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let items = self.toolbarItems {
            self.navigationController.setToolbarHidden(false, animated: true)
        } else {
            requestCommentCount {
                (commentCount: Int) in
                
                self.commentCount = commentCount
                
                var comment = UIButton.barButtonItem("댓글(\(commentCount))", image: nil, target: self, selector: Selector("showComment"))
                var share = UIButton.barButtonItem("공유", image: nil, target: self, selector: Selector("sharePage"))
                var list = UIButton.barButtonItem("목록", image: nil, target: self, selector: Selector("showList"))
                var flex1 = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
                var flex2 = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
                var flex3 = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
                var flex4 = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
                var items = [flex1, comment, flex2, share, flex3, list, flex4]
                
                self.toolbarItems = items
                self.navigationController.setToolbarHidden(false, animated: false)
            }
        }
    }
    
    func gestureRecognizer() -> UITapGestureRecognizer {
        var gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("toggleToolbar"))
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.delegate = self
        return gestureRecognizer
    }
    
    func toggleToolbar() {
        self.navigationController.setToolbarHidden(!self.navigationController.toolbar.hidden, animated: true)
    }
    
    func jsonObjectFromString(jsonString: String, error: NSErrorPointer) -> Dictionary<String, AnyObject>? {
        var data = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        return NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: error) as? Dictionary<String, AnyObject>
    }
    
    func layoutSubviews() {
        var isScroll = true
        var storyPageList: AnyObject?
        
        if let info = storyInfo {
            var episode: AnyObject? = info["storyEpisode"]
            storyEpisode = episode as? Dictionary<String, AnyObject>
            
            storyPageList = info["storyPageList"]
            var episodeType = storyEpisode!["episodeType"] as NSString
            isScroll = episodeType.lowercaseString == "scroll"
        }
        
        if isScroll {
            createContentWebview()
        } else if let list = storyPageList as? [Dictionary<String, AnyObject>]{
            createImageDataList(list)
            createImageSlider()
        }
    }
    
    func requestCommentCount(resultBlock: ((commentCount: Int) -> Void)) {
        if let s = storyEpisode {
            var articleId: NSNumber = s["episodeId"] as NSNumber
            var episodeKey = "EPISODE_\(articleId.integerValue)"
            
            NetClient.instance.getWithAbsoluteUrl("http://news.rhea.media.daum.net/rhea/do/api/getCommentTotalCount?bbsId=storyball&docIds=\(episodeKey)") {
                (result: AnyObject!) in
                
                var data = result as Dictionary<String, AnyObject>
                var count: AnyObject? = data["totalCount"]
                
                if let c: AnyObject = count {
                    var comment: AnyObject? = c[episodeKey]
                    
                    if let numberValue: AnyObject = comment {
                        resultBlock(commentCount: numberValue.integerValue)
                    } else {
                        resultBlock(commentCount: 0)
                    }
                }
            }
        }
    }
    
    func showComment() {
        if let s = storyEpisode {
            var temp: AnyObject? = storyInfo!["story"]
            var data = temp! as Dictionary<String, AnyObject>
            
            var articleId: NSNumber = s["articleId"] as NSNumber
            var commentViewController = CommentViewController(title: "댓글(\(commentCount))")
            commentViewController.id = "\(articleId.integerValue)"
            commentViewController.commentImageUrl = data["commentImageUrl2"] as? NSString
            
            var navigator = SBNavigationController.instanceWithViewController(commentViewController)
            self.presentViewController(navigator, animated: true) {}
        }
    }
    
    func sharePage() {
        var temp: AnyObject? = storyInfo!["story"]
        var data = temp! as Dictionary<String, AnyObject>
        var imageUrl = data["imageUrl1"] as NSString
        
        imageForShare = UIImageView()
        
        var request = NSURLRequest(URL: NSURL(string: imageUrl))
        imageForShare!.setImageWithURLRequest(request, placeholderImage: nil,
            success: {
                (req: NSURLRequest!, res: NSHTTPURLResponse!, image: UIImage!) in
                
                var name = data["name"] as NSString
                var article = self.storyEpisode!["name"] as NSString
                var title = "<스토리볼: \(name)> \(article)"
                var items = [title, image]
                var controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
                self.presentViewController(controller, animated: true, completion: nil)
            },
            failure: nil)
    }
    
    func showList() {
        var index = 0
        var viewControllers = self.navigationController.viewControllers
        
        for var i = 0; i < viewControllers.count; i++ {
            var item: AnyObject = viewControllers[i]
            
            if item is ListViewController {
                index = i
                break
            }
        }
        
        if index > 0 {
            var controller = viewControllers[index] as UIViewController
            self.navigationController.popToViewController(controller, animated: true)
        } else {
            var temp: AnyObject? = storyInfo!["story"]
            var data = temp! as Dictionary<String, AnyObject>
            var title = data["name"] as NSString
            var storyId = data["storyId"] as NSNumber
            
            var listViewController = ListViewController(title: title)
            listViewController.id = "/story/\(storyId.integerValue)"
            
            self.navigationController.pushViewController(listViewController, animated: true)
        }
    }
    
    func createContentWebview() {
        var articleBody = doc!.itemWithQuery("#viewBody")
        var head = doc!.itemWithQuery("head")!.raw.trim()
        
        if let b = articleBody {
            var body = b.raw.trim()
            var html = "<!DOCTYPE html>\(head)<body data-ctpageid=\"storyballView\"><div class=\"cont_view bnr_on fit\" id=\"daumWrap\"><article id=\"daumContent\"><div id=\"cMain\"><article id=\"mArticle\" role=\"main\">\(body)</article></div></article></div></body>"
            var size = self.view.bounds.size
            
            contentWebview = SBWebview(frame: CGRect(origin: CGPointZero, size: size))
            contentWebview!.scrollView.delegate = self
            contentWebview!.addGestureRecognizer(gestureRecognizer())
            self.view.addSubview(contentWebview)
            contentWebview!.layoutTopInParentView()
            contentWebview!.loadHTMLString(html, baseURL: NetClient.instance.relativeManager?.baseURL)
        }
    }
    
    func createImageDataList(list: [Dictionary<String, AnyObject>]) {
        var dataList = Array<StoryPageData>()
        
        for item in list {
            var data = StoryPageData(data: item)
            data.loadImageUrl(nil)
            dataList += data
        }
        
        dataList.sort {
            (a: StoryPageData, b: StoryPageData) in
            return a.pageNo < b.pageNo
        }

        imageDataList = dataList
    }
    
    func createImageSlider() {
        var size = self.view.bounds.size
        contentScroller = DHPageScrollView(frame: CGRect(origin: CGPointZero, size: size), dataSource: self)
        contentScroller!.addGestureRecognizer(gestureRecognizer())
        contentScroller!.delegate = self
        self.view.addSubview(contentScroller)
        
        contentScroller!.reloadData(nil)
    }

    func numberOfPagesInScrollView(scrollView: DHPageScrollView) -> Int {
        return imageDataList!.count
    }
    
    func scrollView(scrollView: DHPageScrollView, pageViewAtPage page: Int) -> DHPageView? {
        var pageView = scrollView.dequeueReusablePageView()
        var frame = self.view.bounds
        
        if pageView == nil {
            pageView = DHPageView(frame: frame)
        }
        
        var data = imageDataList![page]
        data.loadImageUrl {
            (imageUrl: String) in
            
            var imageView = UIImageView(frame: frame)
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            imageView.setImageWithURL(NSURL(string: imageUrl))
            pageView!.contentView = imageView
        }
        
        return pageView
    }
    
//    UIScrollViewDelegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView!) {
        scrollViewOffset = scrollView.contentOffset
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        var diffX = scrollView.contentOffset.x - scrollViewOffset.x
        var diffY = scrollView.contentOffset.y - scrollViewOffset.y
        
        if diffX == 0 {
            if diffY > 0 {
                checkAndHideToolbar()
            } else {
                checkAndShowToolbar()
            }
        } else if diffY == 0 {
            if diffX > 0 {
                checkAndHideToolbar()
            } else {
                checkAndShowToolbar()
            }
        }
    }
    
    func checkAndHideToolbar() {
        if !self.navigationController.toolbar.hidden {
            self.navigationController.setToolbarHidden(true, animated: true)
        }
    }
    
    func checkAndShowToolbar() {
        if self.navigationController.toolbar.hidden {
            self.navigationController.setToolbarHidden(false, animated: true)
        }
    }
    
//    UIGestureRecognizerDelegate
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer!) -> Bool {
        return true
    }
}
