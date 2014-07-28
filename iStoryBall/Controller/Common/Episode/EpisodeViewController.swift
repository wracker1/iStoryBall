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
            contentWebview!.loadHTMLString(html, baseURL: NetClient.instance.manager?.baseURL)
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
