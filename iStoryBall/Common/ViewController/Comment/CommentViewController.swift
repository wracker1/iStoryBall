//
//  CommentViewController.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 29..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import QuartzCore

class CommentViewController: SBViewController, UITableViewDataSource, UITableViewDelegate
{
    var pageIndex: Int = 1
    var pageSize: Int = 20
    var commentImageUrl: String?
    var commentDataList = Array<Comment>()
    var commentTableView: UITableView?
    var commentLoader: DHScrollViewManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if commentTableView == nil {
            layoutSubviews()
        }
    }
    
    func layoutSubviews() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: Selector("dismiss"))
        
        commentTableView = UITableView(frame: self.view.bounds, style: .Plain)
        commentTableView!.dataSource = self
        commentTableView!.delegate = self
        self.view.addSubview(commentTableView!)
        
        commentLoader = DHScrollViewManager(scrollView: commentTableView!, viewController: self)
        commentLoader!.addTarget(self, bottomLoaderAction: Selector("loadMoreComment"))
        
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
            self.commentTableView?.reloadData()
        }
    }
    
    func loadMoreComment() {
        commentLoader!.startBottomLoader()
        var page = pageIndex + 1
        
        loadCommentDataAtPage(page) {
            (comments: [Comment]) in
            
            self.didFinishLoadDataAtPage(comments, page: page)
        }
    }
    
    func didFinishLoadDataAtPage(comments: [Comment], page: Int) {
        var indexPaths = Array<NSIndexPath>()
        var rowNum = commentDataList.count
        
        for comment in comments {
            commentDataList += comment
            indexPaths += NSIndexPath(forRow: rowNum++, inSection: 0)
        }
        
        pageIndex = page
        commentLoader!.endBottomLoader()
        commentTableView!.insertRowToBottom(indexPaths)
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
                    comment.imageUrl = self.commentImageUrl
                    comment.loadProfileImage(nil, finish: nil)
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
        var cellId = CommentCell.reuseIdentifier()
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? CommentCell
        
        if cell == nil {
            cell = CommentCell()
        }
        
        var data = commentDataList[indexPath.row]
        cell!.update(data)
        
        return cell
    }
    
//    UITableViewDelegate
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        var data = commentDataList[indexPath.row]
        return CommentCell.heightForRowWithModel(data)
    }
}
