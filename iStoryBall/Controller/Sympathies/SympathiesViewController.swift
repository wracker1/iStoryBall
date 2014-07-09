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
    
    override func viewDidLoad() {
        initView()
    }
    
    func initView() {
        tableView = UITableView(frame: self.view.frame, style: .Plain)
        tableView!.delegate = self
        tableView!.dataSource = self
        self.view.addSubview(tableView)
    }
    
//    func requestSympathiesData() -> {
//    
//    }
    
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell: UITableViewCell = UITableViewCell(style: .Default, reuseIdentifier: "test_cell")
        cell.text = "test"
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        println("selected cell : \(indexPath.row)")
    }
}
