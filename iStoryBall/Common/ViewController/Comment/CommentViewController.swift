//
//  CommentViewController.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 29..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class CommentViewController: SBViewController, UITableViewDataSource
{
    var pageIndex: Int = 1
    var pageSize: Int = 20
    var commentImageUrl: String?
    var commentDataList = Array<Comment>()
    var commentTableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSubviews()
    }
    
    func layoutSubviews() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: Selector("dismiss"))
        
        commentTableView = UITableView(frame: self.view.bounds, style: .Plain)
        commentTableView!.dataSource = self
        self.view.addSubview(commentTableView!)
        
        reloadCommentData()
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func commentDataUrlAtPage(page: Int) -> String {
        return "http://news.rhea.media.daum.net/rhea/do/social/json/commentList?bbsId=storyball&articleId=\(id!)&cSortKey=depth&allComment=T&cPageIndex=\(page)&cPageSize=\(pageSize)"
    }
    
    func reloadCommentData() {
        pageIndex = 1
        
        commentDataList.removeAll(keepCapacity: false)
        
        loadCommentDataAtPage(pageIndex) {
            (list: [Comment]) in
            
            self.commentDataList = list
        }
    }
    
    func loadCommentDataAtPage(page: Int, finishBlock: ((list: [Comment]) -> Void)?) {
        var url = commentDataUrlAtPage(page)
        
        NetClient.instance.getWithAbsoluteUrl(url) {
            (result: AnyObject) in
            
            var comments = Array<Comment>()
            var data = result["comments"]
            var list = data as? [Dictionary<String, AnyObject>]
            
            if let items = list {
                for item in items {
                    var comment = Comment(data: item)
                    comments += comment
                }
            }
            
            if let f = finishBlock {
                f(list: comments)
            }
        }
    }
    
//    UITableViewDataSource
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return commentDataList.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        return nil
    }
}
