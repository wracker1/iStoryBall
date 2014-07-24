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
    let CELL_HEIGHT:Float = 45.0
    var selected = -1
    var question = "질문"
    var buttonWrapper: UIView?
    
    override func viewWillAppear(animated: Bool)  {
        super.viewWillAppear(animated)
        requestData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    

    func requestData() {
        NetClient.instance.get("/choice", success: {
            (html: String) in
            
            self.doc = html.htmlDocument()
            self.form = self.doc!.itemsWithQuery(".item_form")[0]
            self.setData()
            })
    }
    
    func setData() {
        choiceTitles = []
        choiceValues = []
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
        
        
        
        tableView!.reloadData()
        
        var tableHeight:Float = Float(self.choiceTitles.count) * CELL_HEIGHT
        println(tableHeight)
        var vConst = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[label(50)]-[table(\(tableHeight.cgValue()))]-[button(50)]-(>=0)-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["label": label!, "table": tableView!, "button": buttonWrapper!])
        
        NSLayoutConstraint.activateConstraints(vConst)
        label!.text = doc?.itemsWithQuery(".tit_form")[0].text()
        //self.initView()
    }
    
    func initView() {
        var tableHeight:Float = Float(self.choiceTitles.count) * CELL_HEIGHT
        println(tableHeight)
        
        tableView = UITableView(frame: CGRectMake(0, 50, self.view.bounds.size.width, tableHeight.cgValue()), style: .Plain)
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(tableView)
        tableView!.layer.cornerRadius = 10.0
        tableView!.layer.borderColor = UIColor.grayColor().CGColor
        tableView!.layer.borderWidth = 1
        
        label = UILabel(frame:CGRectMake(0, 0, self.view.bounds.size.width, 50))
        label!.text = "질문"
        label!.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(label)
        
        buttonWrapper = UIView(frame: CGRectMake(0, 50 + tableHeight.cgValue(), self.view.bounds.size.width, 50))
        buttonWrapper!.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        var recommendButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        recommendButton.frame = CGRectMake(0, 0, 100, 50)
        recommendButton.setTitle("추천받기", forState: UIControlState.Normal)
        recommendButton.addTarget(self, action: "recommend:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonWrapper!.addSubview(recommendButton)
        recommendButton.activateConstraintsLeftInParentView()
        
        var redoButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        redoButton.frame = CGRectMake(0, 0, 100, 50)
        redoButton.setTitle("다시하기", forState: UIControlState.Normal)
        redoButton.addTarget(self, action: "redo:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonWrapper!.addSubview(redoButton)
        self.view.addSubview(buttonWrapper!)
        redoButton.activateConstraintsRightInParentView()
        
        
    }
    
    func recommend(sender: UIButton!) {
        println("recommend")
        var value = self.choiceValues[self.selected]
        var choiceViewDetailController = ChoiceViewDetailController()
        choiceViewDetailController.url = value
        self.navigationController.pushViewController(choiceViewDetailController, animated: true)
    }
    
    func redo(sender: UIButton!) {
        println("redo")
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
        cell.textLabel.font = UIFont.systemFontOfSize(12)
        
        return cell
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return CELL_HEIGHT.cgValue()
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        //선택 된것 확인
        self.selected = indexPath.row
//        var value = choiceValues[row]
//        var choiceViewDetailController = ChoiceViewDetailController()
//        choiceViewDetailController.url = value
//        self.navigationController.pushViewController(choiceViewDetailController, animated: true)
    }
    
}