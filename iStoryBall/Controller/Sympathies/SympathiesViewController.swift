//
//  SympathiesViewController.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 8..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import UIKit

class SympathiesViewController : SBViewController, UITableViewDataSource, UITableViewDelegate
{
    var tableView: UITableView?
    var articleList: Article[] = Article[]()
    
    override func viewDidLoad() {
        initView()
        requestSympathiesData()
    }
    
    func initView() {
        tableView = UITableView(frame: self.view.frame, style: .Plain)
        tableView!.delegate = self
        tableView!.dataSource = self
        self.view.addSubview(tableView)
    }
    
    func requestSympathiesData() {

        NetClient.instance.get(url: "http://m.storyball.daum.net/episode/hit/1000", parameters: nil, success: {
            (html: String) in
                var items = DHDomParser.itemsWithQuery(html, query:".list_empathy li")
                var index = 0
                for item in items {
                    println("item : \(item)")
                    println("item.text : \(item.text)")
                    println("item.html : \(item.html)")
                    println("item.attributes : \(item.attributes)")
                    println("item.tagName : \(item.tagName)")
                    println("index : \(index)")
                    ++index
                    
                    var article = Article(id: item.attributes["id"] as String)
                    
                    var titleItems = DHDomParser.itemsWithQuery(html, query:".tit_empathy")
                    var imageItems = DHDomParser.itemsWithQuery(html, query:".thumb_img")
                    
                    println("imageItems \(imageItems[0].attributes)") //attributes style attribute 안가져온다.. -- 이미지 url 가져와야돼 수정좀
                    if !titleItems.isEmpty {
                        article.title = titleItems[0].html
                    }
                    if !imageItems.isEmpty {
                        var style = imageItems[0].attributes["style"]
                        println("style \(style)")
//                        article.imageUrl = imageItems[0].html
                    }
                    
                    self.articleList.append(article)
                    
                }
                self.tableView!.reloadData()
            
            }, failure: nil)
        
        
    }
    
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.articleList.count
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 70.0
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var item = self.articleList[indexPath.row];
        var cell = UITableViewCell(style: .Default, reuseIdentifier: "test_cell")

        cell.textLabel.text = item.title
        cell.textLabel.numberOfLines = 2
        cell.imageView.frame = CGRect(x:100, y:100, width:100, height:100)
//        cell.imageView.image = UIImage(named: item.imageUrl)
        
        var data = NSData(contentsOfURL: NSURL.URLWithString("http://i1.daumcdn.net/svc/image/U03/storyBall/51F28A5C0409C40001"))
        cell.imageView.image = UIImage(data: data)
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var item = self.articleList[indexPath.row];
        
        println("selected cell : \(indexPath.row)")
        
        // TODO url 정리 필요
        var baseUrl = "http://m.storyball.daum.net/episode";
        var targetUrl = baseUrl.stringByAppendingFormat("/%@", item.getRealId())
        
        var detailViewController = DetailViewController(title:item.title as String, urlString: targetUrl)
        self.navigationController.pushViewController(detailViewController, animated: true)
    }
}
