//
//  MenuViewController.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 9..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class MenuViewController : SBViewController, UITableViewDelegate, UITableViewDataSource
{
    var menus: [TFHppleElement]?
    var refinedMenu: [TFHppleElement]?
    let exceptiveMenuUrl = ["/story/pop", "/episode/hit", "/story/list"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeTitleView("더보기")
        
        requestMenuData()
    }
    
    func isValidMenu(url: String) -> Bool {
        var isValid = true;
        for exceptiveUrl in exceptiveMenuUrl {
            if url == exceptiveUrl {
                isValid = false
                break
            }
        }
        return isValid
    }
    
    func refineMenus(menus: [TFHppleElement]?) -> [TFHppleElement] {
        var refined = [TFHppleElement]()
        var count = menus!.count
        
        for i in 0 ..< count {
            var menu = menus![i]
            var url = menu.attributes["href"] as NSString
            if isValidMenu(url) {
                refined.append(menu)
            }
        }
        
        return refined
    }
    
    func requestMenuData() {
        NetClient.instance.get("/", success: {
            (html: String) in
            
            self.doc = html.htmlDocument()
            self.menus = self.refineMenus(self.doc!.itemsWithQuery(".link_menu"))

            println(self.menus!.count)
            println("\n")
            self.initView()
            })
    }
    
    func initView() {
        var tableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(tableView)
        
        var tableHConst = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[table(>=300)]-(0)-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["table": tableView])
        
        var vConst = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[table(>=300)]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["table": tableView])
        
        
        self.view.addConstraints(tableHConst)
        self.view.addConstraints(vConst)
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.menus!.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let identifier = "identifier"
        var cell: UITableViewCell = UITableViewCell(style: .Default, reuseIdentifier: identifier)
        var row = indexPath.row
        var menu = self.menus![row]
        var name = menu.text()
        var link = menu.attributes["href"] as NSString
        
        if !menu.firstChild.isTextNode() {
            var textnode = menu.firstChildWithClassName("txt_menu")
            name = textnode.text()
        }
        
        cell.textLabel.text = name
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var row = indexPath.row
        var menu = self.menus![row]
        var link = menu.attributes["href"] as NSString
        
        
        switch row {
        case 1: // 구매 스토리
            println(indexPath.row)
        case 2: // 공감 스토리
            println(indexPath.row)
        case 3: // 맞춤한 스토리
            var choiceViewController = ChoiceViewController()
            self.navigationController.pushViewController(choiceViewController, animated: true)
            println(indexPath.row)
        case 4: // 설레는 이벤트 - ListViewController
            println(indexPath.row)
            
            var listViewController = ListViewController(title: "설레는 이벤트")
            listViewController.id = link as String
            self.navigationController.pushViewController(listViewController, animated: true)
        case 5: // 스토리볼 페이스북
            println(indexPath.row)
            var urlString:String? = "http://www.facebook.com/daumstoryball"
            var url = NSURL(string: urlString)
            UIApplication.sharedApplication().openURL(url)
        case 6: // 스토리볼 사용 설명서 - ListViewController
            println(indexPath.row)
            
            var listViewController = ListViewController(title: "스토리볼 사용 설명서")
            listViewController.id = link as String
            self.navigationController.pushViewController(listViewController, animated: true)
        case 7: // 스토리볼 공지
            println(indexPath.row)
            var noticeViewController = NoticeViewController()
            self.navigationController.pushViewController(noticeViewController, animated: true)
        case 8: // 스토리볼 연재 제안
            println(indexPath.row)
        default:
            println(indexPath.row)
        }
    }

}
