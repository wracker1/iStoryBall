//
//  EpisodeViewController.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 24..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class EpisodeViewController: SBViewController
{
    var doc: TFHpple?
    var contentWebview: SBWebview?
    
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
        createContentWebview()
    }
    
    func createContentWebview() {
        var articleBody = doc!.itemWithQuery("#viewBody")
        var head = doc!.itemWithQuery("head").raw.trim()
        var body = articleBody.raw.trim()
        var html = "<!DOCTYPE html>\(head)<body data-ctpageid=\"storyballView\"><div class=\"cont_view bnr_on fit\" id=\"daumWrap\"><article id=\"daumContent\"><div id=\"cMain\"><article id=\"mArticle\" role=\"main\">\(body)</article></div></article></div></body>"
        var size = self.view.bounds.size
        
        contentWebview = SBWebview(frame: CGRect(origin: CGPointZero, size: size))
        self.view.addSubview(contentWebview)
        contentWebview!.layoutTopInParentView()
        contentWebview!.loadHTMLString(html, baseURL: NetClient.instance.manager?.baseURL)
    }
}
