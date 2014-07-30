//
//  WriterViewController.swift
//  iStoryBall
//
//  Created by 정 다정 on 2014. 7. 29..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import Foundation
class WriterViewController : SBViewController, UITableViewDataSource, UITableViewDelegate
{
    
    var writerDataList = Array<Writer>()
    var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = id {
            NetClient.instance.get(url + "#layer/writer") {
                (html: String) in
                var d = html.htmlDocument().itemWithQuery("#writerLayerTemplate")
                if let data = d {
                    var raw = data.raw as NSString
                    var error: NSError?
                    var exp = DHRegEx.classSelector("(writer_on|cp_on)", error: nil)
                    

                    var result = exp.matchesInString(html, options: NSMatchingOptions(0), range:html.range())
                    for match in result as [NSTextCheckingResult] {
                        var r = (html as NSString).substringWithRange(match.range) as String
                        var writer = Writer(raw: r)
                        // 완성
                    }
                }
            }
        }
        
        initView()
    }
    
    func initView() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: Selector("dismiss"))
        
        tableView = UITableView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height), style: .Plain)
        tableView!.dataSource = self
        tableView!.delegate = self
        self.view.addSubview(tableView!)
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return writerDataList.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cellId = WriterCell.reuseIdentifier()
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? WriterCell
        
        if cell == nil {
            cell = WriterCell()
        }
        
        var data = writerDataList[indexPath.row]
        cell!.update(data)
        
        return cell
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        var data = writerDataList[indexPath.row]
        return WriterCell.heightForRowWithModel(data)
    }
}