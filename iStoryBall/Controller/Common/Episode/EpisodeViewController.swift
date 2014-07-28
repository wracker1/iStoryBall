//
//  EpisodeViewController.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 24..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class EpisodeViewController: SBViewController
{
    var contentWebview: SBWebview?
    var storyEpisode: Dictionary<String, AnyObject>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let episodeId = id {
            NetClient.instance.get(episodeId) {
                (html: String) in
                self.doc = html.htmlDocument()
                self.layoutSubviews()
            }
        }
    }
    
    func layoutSubviews() {
        var data = doc!.itemWithQuery("#dataJSONString")!.text().dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        var info = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil) as Dictionary<String, AnyObject>
        
        var episode: AnyObject? = info["storyEpisode"]
        storyEpisode = episode as? Dictionary<String, AnyObject>
        
        var storyPageList: AnyObject? = info["storyPageList"]
        
        var episodeType = storyEpisode!["episodeType"] as NSString
        var isScroll = episodeType.lowercaseString == "scroll"
        
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
            dataList += data
        }
        
        dataList.sort {
            (a: StoryPageData, b: StoryPageData) in
            return a.pageNo < b.pageNo
        }
    }
    
    func createImageSlider() {
        println(id)
        println(storyEpisode)
    }
}
