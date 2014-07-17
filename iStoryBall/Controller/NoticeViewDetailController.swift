//
//  NoticeViewDetailController.swift
//  iStoryBall
//
//  Created by 정 다정 on 2014. 7. 15..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class NoticeDetailViewController : SBViewController {
    var url:String = "/"
    var doc: TFHpple?
    var notices: [TFHppleElement]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getNoticeContentData()
    }
    
    func getNoticeContentData() {
        println("url: " + url)
        NetClient.instance.get(url, success: {
            (html: String) in
            
            self.doc = html.htmlDocument()
            self.notices = self.doc!.itemsWithQuery(".box_notice")
            self.initView()
            })
    }
    
    func initView() {
//        var screenBounds = UIScreen.mainScreen().bounds
//        var frameHeight:Float = screenBounds.size.height
//        var topMargin:Float = Common.commonTopMargin()
//        var bottomMargin:Float  = self.tabBarController.tabBar.frame.size.height
//        var titleHeight:Float = 50
//        var contentHeight:Float = frameHeight - topMargin - bottomMargin - titleHeight
//        var titleLabel = UILabel(frame: CGRectMake(0, topMargin, 320, titleHeight))
//        
//        var notice:TFHppleElement = self.notices![0]
//        
//        var titleEl = notice.itemsWithQuery(".tit_info")
//        var title = ""
//        if titleEl.count > 0 {
//            var el = titleEl[0] as TFHppleElement
//            title = el.text()
//        }
//        
//        titleLabel.text = title
//        self.view.addSubview(titleLabel)
//        
//        var contentEl = notice.itemsWithQuery(".desc_notice")
//        var content = ""
//        if contentEl.count > 0 {
//            var el = contentEl[0] as TFHppleElement
//            content = el.raw
//        }
//
//        var html = "<html><head><title></title></head><body style=\"background:transparent;\">"
//        html += content
//        html += "</body></html>"
//        
//        var webView = UIWebView(frame: CGRectMake(0, topMargin + titleHeight, 320, contentHeight))
//        webView.backgroundColor = UIColor.clearColor()
//        webView.loadHTMLString(html, baseURL: nil)
//        self.view.addSubview(webView)
//
//        println("title: " + title);
//        println("content: " + content)
    }
    
}