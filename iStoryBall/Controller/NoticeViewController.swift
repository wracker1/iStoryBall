//
//  NoticeViewController.swift
//  iStoryBall
//
//  Created by 정 다정 on 2014. 7. 14..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class NoticeViewController : SBViewController, UITableViewDelegate, UITableViewDataSource
{
    var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        //self.view.adds
        
    }
    
    func initView() {
        tableView = UITableView(frame: self.view.frame, style: .Plain)
        tableView!.delegate = self
        tableView!.dataSource = self
        self.view.addSubview(tableView)
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let identifier = "identifier"
        var cell: UITableViewCell = UITableViewCell(style: .Default, reuseIdentifier: identifier)
//        var row = indexPath.row
//        var menu = self.menus![row]
//        var name = menu.text()
//        var link = menu.attributes["href"]
//        
//        if !menu.firstChild.isTextNode() {
//            var textnode = menu.firstChildWithClassName("txt_menu")
//            name = textnode.text()
//        }
        
        cell.textLabel.text = "공지사항"

        return cell
    }
}