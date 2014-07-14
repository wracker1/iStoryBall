//
//  MenuViewController.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 9..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class MenuViewController : SBViewController, UITableViewDelegate, UITableViewDataSource
{
    var tableView: UITableView?
    var doc: TFHpple?
    var menus: [TFHppleElement]?
    var refinedMenu: [TFHppleElement]?
    let exceptiveMenuUrl = ["/story/pop", "/episode/hit", "/story/list"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestMenuData()
        //initView()
        //self.view.adds
        
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
        
        for i in 0..<count {
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
        tableView = UITableView(frame: self.view.frame, style: .Plain)
        tableView!.delegate = self
        tableView!.dataSource = self
        self.view.addSubview(tableView)
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
        var link = menu.attributes["href"]
        
        if !menu.firstChild.isTextNode() {
            var textnode = menu.firstChildWithClassName("txt_menu")
            name = textnode.text()
        }
        
        cell.textLabel.text = name
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        switch indexPath.row {
        case 1: // 구매 스토리
            println(indexPath.row)
        case 2: // 공감 스토리
            println(indexPath.row)
        case 3: // 맞춤한 스토리
            println(indexPath.row)
        case 4: // 설레는 이벤트
            println(indexPath.row)
        case 5: // 스토리볼 페이스북
            println(indexPath.row)
            var urlString:String? = "http://www.facebook.com/daumstoryball"
            var url = NSURL(string: urlString)
            UIApplication.sharedApplication().openURL(url)
        case 6: // 스토리볼 사용 설명서
            println(indexPath.row)
        case 7: // 스토리볼 공지
            println(indexPath.row)
            // 다시 테이블 뷰 컨트롤러로 만들어야 한다!
            
        case 8: // 스토리볼 연재 제안
            println(indexPath.row)
        default:
            println(indexPath.row)
        }
    }

}
