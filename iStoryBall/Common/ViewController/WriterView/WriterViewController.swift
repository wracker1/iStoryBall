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
    var writerTableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if writerTableView == nil {
            layoutSubviews()
        }
        
        reloadWriterData()
    }
    
    func layoutSubviews() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: Selector("dismiss"))
        
        writerTableView = UITableView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height), style: .Plain)
        writerTableView!.dataSource = self
        writerTableView!.delegate = self
        writerTableView!.rowHeight = WriterCell.minHeight()
        writerTableView!.separatorColor = UIColor.clearColor()
        self.view.addSubview(writerTableView!)
    }
    
    func reloadWriterData() {
        if let url = id {
            NetClient.instance.get(url + "#layer/writer") {
                (html: String) in
                
                var regex = DHRegEx.classSelector("list_writer", error: nil)
                var result = regex.firstMatchInString(html, options: NSMatchingOptions(0), range: html.range())
                var content = (html as NSString).substringWithRange(result.rangeAtIndex(4)) as String
                
                var elementArr = content.htmlDocument().itemsWithQuery(".writer_on")
                if elementArr.count == 0 {
                    elementArr = content.htmlDocument().itemsWithQuery(".cp_on")
                }
                
                for element in elementArr as [TFHppleElement] {
                    var data = Dictionary<String, AnyObject>()
                    data["name"] = element.itemWithQuery(".tit_desc")!.text().replace("(\\s)+", replacementPattern: " ").trim()
                    data["description"] = element.itemWithQuery(".txt_desc")!.text().trim()
                    data["imageUrl"] = element.itemWithQuery("img")!.attributes["src"]
                    var writer = Writer(data: data)
                    self.writerDataList += writer
                }
                self.writerTableView!.reloadData()
            }
        }
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