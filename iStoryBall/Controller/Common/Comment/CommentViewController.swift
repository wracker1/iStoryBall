//
//  CommentViewController.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 29..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class CommentViewController: SBViewController
{
    var pageIndex: Int = 1
    var pageSize: Int = 20
    var commentImageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadCommentData()
    }
    
    func commentDataUrlAtPage(page: Int) -> String {
        return "http://news.rhea.media.daum.net/rhea/do/social/json/commentList?bbsId=storyball&articleId=\(id)&cSortKey=depth&allComment=T&cPageIndex=\(page)&cPageSize=\(pageSize)"
    }
    
    func reloadCommentData() {
        pageIndex = 1
        
        var url = commentDataUrlAtPage(pageIndex)
        
        NetClient.instance.getWithAbsoluteUrl(url) {
            (result: AnyObject) in
            
            var data = result["comments"]
            
            println("###### \(data)")
        }
    }
    
    func loadCommentData() {
        pageIndex++
        
        var url = commentDataUrlAtPage(pageIndex)
        
        NetClient.instance.getWithAbsoluteUrl(url) {
            (result: AnyObject) in
            
            var data = result["comments"] as? Dictionary<String, AnyObject>
            
            println(result)
        }
    }
}
