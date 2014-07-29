//
//  MenuViewController.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 9..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class MenuViewController : SBViewController, UITableViewDelegate, UITableViewDataSource
{
    var menu =  Array<(name: String, membermenu: Bool)>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        storyType += ("hit","공감순", "공감 1등은 뉴규", 1)
        changeTitleView("더보기")
        menu += ("내 구독 스토리", true)
        menu += ("내 구매 스토리", true)
        menu += ("MY공감 스토리", true)
        menu += ("맞춤한 스토리", false)
        menu += ("설레는 이벤트", false)
        menu += ("스토리볼 페이스북", false)
        menu += ("스토리볼 사용설명서", false)
        menu += ("스토리볼 공지", false)
        menu += ("스토리볼 연재 제안", false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    func initView() {
        var tableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.menu.count
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
        cell.textLabel.font = UIFont.systemFontOfSize(12)
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var row = indexPath.row
        var menu = self.menus![row]
        var link = menu.attributes["href"] as NSString
        
        
        switch row {
        case 0: // 구독 스토리
            println(indexPath.row)
//            var url = "https://logins.daum.net/accounts/loginform.do?daumauth=1"
//            var loginViewController = DetailViewController(title: "로그인", urlString: url)
//            self.navigationController.pushViewController(loginViewController, animated: true)
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
