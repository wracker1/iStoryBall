//
//  ChoiceViewController.swift
//  iStoryBall
//
//  Created by 정 다정 on 2014. 7. 17..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class ChoiceViewController: SBViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView?
    var doc: TFHpple?
    var choiceTitles = [String]()
    var choiceValues = [String]()
    var form: TFHppleElement?
    
    override func viewDidLoad() {
        NetClient.instance.get("/choice", success: {
            (html: String) in
            
            self.doc = html.htmlDocument()

            var title = self.doc!.itemsWithQuery(".tit_form")[0].text()
            self.form = self.doc!.itemsWithQuery(".item_form")[0]
            self.initView()
            })
        super.viewDidLoad()
    }
    
    func initView() {
        if let formItem = form {
            var titles = formItem.itemsWithQuery(".txt_form")
            var values = formItem.itemsWithQuery("input")
            
            var count = titles.count
            if count > 0 {
                for i in 0 ..< count {
                    var title:TFHppleElement = titles[i] as TFHppleElement
                    var value:TFHppleElement = values[i] as TFHppleElement
                    self.choiceTitles.append(title.text() as String)
                    self.choiceValues.append(value.attributes["value"] as NSString)
                }
            }
        }
        
        tableView = UITableView(frame: self.view.frame, style: .Plain)
        tableView!.delegate = self
        tableView!.dataSource = self
        
        self.view.addSubview(tableView)
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.choiceTitles.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let identifier = "identifier"
        var cell: UITableViewCell = UITableViewCell(style: .Default, reuseIdentifier: identifier)
        var row = indexPath.row
        cell.textLabel.text = self.choiceTitles[row]
        
        return cell
    }
}