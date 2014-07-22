//
//  ChoiceViewController.swift
//  iStoryBall
//
//  Created by 정 다정 on 2014. 7. 17..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class ChoiceViewController: SBViewController, UITableViewDelegate, UITableViewDataSource {
    var doc: TFHpple?
    var choiceTitles = [String]()
    var choiceValues = [String]()
    var form: TFHppleElement?
    var tableView: UITableView?
    var label:UILabel?
    
    override func viewWillAppear(animated: Bool)  {
        requestData()
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    func requestData() {
        NetClient.instance.get("/choice", success: {
            (html: String) in
            
            self.doc = html.htmlDocument()

            self.form = self.doc!.itemsWithQuery(".item_form")[0]
            self.initView()
            })
    }
    
    func initView() {
        self.choiceTitles = [String]()
        self.choiceValues = [String]()
        
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
        
        tableView = UITableView(frame: self.view.bounds, style: .Grouped)
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(tableView)
        
        // 중복으로 붙는다...
        
        if var title = label {
            title.removeFromSuperview()
        }
        label = UILabel()
        label!.frame = CGRectMake(0, 0, 0, 0)
        label!.text = doc?.itemsWithQuery(".tit_form")[0].text()
        label!.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(label)
        
        var labelHConst = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label(>=100)]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["label":label!])
        
        var tableHConst = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[table(>=300)]-(0)-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["table": tableView!])
        
        var vConst = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[label(50)]-[table(>=300)]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["label": label!, "table": tableView!])
        
        
        self.view.addConstraints(labelHConst)
        self.view.addConstraints(tableHConst)
        self.view.addConstraints(vConst)

        // 버튼
        
        
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.choiceTitles.count
    }

//    구림 viewForHeaderInSection 으로 커스터마이징 가능
//    func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
//        return doc?.itemsWithQuery(".tit_form")[0].text()
//    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let identifier = "identifier"
        var cell: UITableViewCell = UITableViewCell(style: .Default, reuseIdentifier: identifier)
        var row = indexPath.row
        cell.textLabel.text = self.choiceTitles[row]
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        //선택 된것 확인
        var row = indexPath.row
        var value = choiceValues[row]
        println(value)
        var choiceViewDetailController = ChoiceViewDetailController()
        choiceViewDetailController.url = value
        self.navigationController.pushViewController(choiceViewDetailController, animated: true)
    }
    
}