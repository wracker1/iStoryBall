//
//  EpisodeViewController.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 24..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class EpisodeViewController: SBViewController, DHPageScrollViewDataSource
{
    var contentWebview: SBWebview?
    var contentScroller: DHPageScrollView?
    var commentCount = 0
    var storyInfo: Dictionary<String, AnyObject>?
    var storyEpisode: Dictionary<String, AnyObject>?
    var imageDataList: [StoryPageData]?

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
                var share = UIButton.barButtonItem("공유", image: nil, target: self, selector: Selector("showComment"))
                var list = UIButton.barButtonItem("목록", image: nil, target: self, selector: Selector("showComment"))
                var flex1 = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
                var flex2 = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
                var flex3 = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
                var flex4 = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
                var items = [flex1, comment, flex2, share, flex3, list, flex4]
                
                self.toolbarItems = items
                self.navigationController.setToolbarHidden(false, animated: true)
            }
        }
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
            commentViewController.commentImageUrl = data["commentImageUrl1"] as? NSString
            
            var navigator = SBNavigationController.instanceWithViewController(commentViewController)
            self.presentViewController(navigator, animated: true) {}
        }
    }
    
    func sharePage() {
        
    }
    
    func showList() {
        
    }
    
    func createContentWebview() {
        var articleBody = doc!.itemWithQuery("#viewBody")
        var head = doc!.itemWithQuery("head")!.raw.trim()
        
        if let b = articleBody {
            var body = b.raw.trim()
            var html = "<!DOCTYPE html>\(head)<body data-ctpageid=\"storyballView\"><div class=\"cont_view bnr_on fit\" id=\"daumWrap\"><article id=\"daumContent\"><div id=\"cMain\"><article id=\"mArticle\" role=\"main\">\(body)</article></div></article></div></body>"
            var size = self.view.bounds.size
            
            contentWebview = SBWebview(frame: CGRect(origin: CGPointZero, size: size))
            self.view.addSubview(contentWebview)
            contentWebview!.layoutTopInParentView()
            contentWebview!.loadHTMLString(html, baseURL: NetClient.instance.relativeManager?.baseURL)
        }
    }
    
    func createImageDataList(list: [Dictionary<String, AnyObject>]) {
        var dataList = Array<StoryPageData>()
        
        for item in list {
            var episodeId = item["episodeId"] as NSNumber
            var pageId = item["pageId"] as NSNumber
            var pageNo = item["pageNo"] as NSNumber
            
            var data = StoryPageData(episodeId: String(episodeId.integerValue), pageId: String(pageId.integerValue), pageNo: pageNo.integerValue)
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
}
