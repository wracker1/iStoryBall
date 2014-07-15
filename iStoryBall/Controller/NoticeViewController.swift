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
    var page = 1
    
    var doc: TFHpple?
    var notices: [TFHppleElement]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initView()
        //self.view.adds
        getNoticeData()
    }
    
    func getNoticeData() {
        var url = "/notice/list_more?page=1"
        NetClient.instance.get(url, success: {
            (html: String) in
            
            self.doc = html.htmlDocument()
            self.notices = self.doc!.itemsWithQuery(".link_notice")
            self.initView()
            })
    }
    
    func initView() {
        tableView = UITableView(frame: self.view.frame, style: .Plain)
        tableView!.delegate = self
        tableView!.dataSource = self
        self.view.addSubview(tableView)
        
//        var button = UIButton.buttonWithType(UIButtonType.System) as UIButton
//        self.view.addSubview(button)
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.notices!.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let identifier = "identifier"
        var cell: UITableViewCell = UITableViewCell(style: .Default, reuseIdentifier: identifier)
        var row = indexPath.row
        var notice:TFHppleElement = self.notices![row]

        var titleEl = notice.itemsWithQuery(".tit_desc")
        var title = ""
        if titleEl.count > 0 {
            var el = titleEl[0] as TFHppleElement
            title = el.text()
        }
//
//        var date = ""
//        
        cell.textLabel.text = title
        return cell
    }
}