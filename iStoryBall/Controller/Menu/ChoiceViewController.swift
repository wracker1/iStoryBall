//
//  ChoiceViewController.swift
//  iStoryBall
//
//  Created by 정 다정 on 2014. 7. 17..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class ChoiceViewController: SBViewController, UITableViewDelegate, UITableViewDataSource {
    var choiceTitles = [String]()
    var choiceValues = [String]()
    var form: TFHppleElement?
    var tableView: UITableView?
    var label:UILabel?
    let CELL_HEIGHT:Float = 45.0
    let CELL_FONT_SIZE:CGFloat = 12
    
    var lastIndexPath: NSIndexPath?
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
        lastIndexPath = nil
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
        tableView!.frame = CGRectMake(20, 50, self.view.bounds.size.width - 40, tableHeight.cgValue())
        buttonWrapper!.frame = CGRectMake(20, 50 + tableHeight.cgValue(), self.view.bounds.size.width - 40, 50)
        
        label!.text = doc?.itemsWithQuery(".tit_form")[0].text()
        //self.initView()
        // 무조건 첫번째를 선택하도록
        var indexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView!.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.Top)
        tableView(tableView!, didSelectRowAtIndexPath: indexPath)
    }
    
    func initView() {
        var tableHeight:Float = Float(self.choiceTitles.count) * CELL_HEIGHT
        println(tableHeight)
        
        tableView = UITableView(frame: CGRectMake(20, 50, self.view.bounds.size.width - 40, tableHeight.cgValue()), style: .Plain)
        tableView!.delegate = self
        tableView!.dataSource = self
        self.view.addSubview(tableView)
        tableView!.layer.cornerRadius = 5.0
        tableView!.layer.borderColor = UIColor.grayColor().CGColor
        tableView!.layer.borderWidth = 1
        
        label = UILabel(frame:CGRectMake(20, 0, self.view.bounds.size.width - 40, 50))
        label!.text = "질문"
        self.view.addSubview(label)
        
        buttonWrapper = UIView(frame: CGRectMake(20, 70 + tableHeight.cgValue(), self.view.bounds.size.width - 40, 50))
        
        var recommendButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        recommendButton.frame = CGRectMake(0, 0, 100, 30)
        recommendButton.setTitle("추천받기", forState: UIControlState.Normal)
        recommendButton.addTarget(self, action: "recommend:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonWrapper!.addSubview(recommendButton)
        recommendButton.activateConstraintsLeftInParentView()
        recommendButton.layer.cornerRadius = 15.0
        recommendButton.layer.borderColor = UIColor.grayColor().CGColor
        recommendButton.layer.borderWidth = 1

        var redoButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        redoButton.frame = CGRectMake(0, 0, 100, 30)
        redoButton.setTitle("다시하기", forState: UIControlState.Normal)
        redoButton.addTarget(self, action: "redo:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonWrapper!.addSubview(redoButton)
        redoButton.layer.cornerRadius = 15.0
        redoButton.layer.borderColor = UIColor.grayColor().CGColor
        redoButton.layer.borderWidth = 1
        
        self.view.addSubview(buttonWrapper!)
        redoButton.activateConstraintsRightInParentView()
        
        
    }
    
    func recommend(sender: UIButton!) {
        var row = lastIndexPath!.row
        var value = self.choiceValues[row]
        var choiceViewDetailController = ChoiceViewDetailController()
        choiceViewDetailController.url = value
        self.navigationController.pushViewController(choiceViewDetailController, animated: true)
    }
    
    func redo(sender: UIButton!) {
        requestData()
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.choiceTitles.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let identifier = "identifier"
        var cell: UITableViewCell = UITableViewCell(style: .Default, reuseIdentifier: identifier)
        var row = indexPath.row
        cell.textLabel.text = self.choiceTitles[row]
        
        var isSelected = false
        if let last = lastIndexPath {
            if row == last.row {
                isSelected = true
            }
        }
        
        if isSelected {
            cell.textLabel.font = UIFont.boldSystemFontOfSize(CELL_FONT_SIZE)
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.textLabel.font = UIFont.systemFontOfSize(CELL_FONT_SIZE)
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return CELL_HEIGHT.cgValue()
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        //선택 된것 확인
        var row = indexPath.row
        var newCell = tableView!.cellForRowAtIndexPath(indexPath)
        newCell.accessoryType = UITableViewCellAccessoryType.Checkmark
        newCell.textLabel.font = UIFont.boldSystemFontOfSize(CELL_FONT_SIZE)
        
        if let last = lastIndexPath {
            var lastRow = last.row
            if lastRow != row {
                var lastCell = tableView!.cellForRowAtIndexPath(last)
                lastCell.accessoryType = UITableViewCellAccessoryType.None
                lastCell.textLabel.font = UIFont.systemFontOfSize(CELL_FONT_SIZE)
                lastIndexPath = indexPath
            }
        } else {
            lastIndexPath = indexPath
        }
    }
    
}