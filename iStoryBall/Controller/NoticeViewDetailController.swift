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
<<<<<<< HEAD
=======
        var screenBounds = UIScreen.mainScreen().bounds
        var frameHeight:Float = screenBounds.size.height.swValue()
        var topMargin:Float = CommonUtil.commonTopMargin()
        var bottomMargin:Float  = self.tabBarController.tabBar.frame.size.height.swValue()
        var titleHeight:Float = 50
        var contentHeight:Float = frameHeight - topMargin - bottomMargin - titleHeight
        var titleLabel = UILabel(frame: CGRectMake(0, topMargin.cgValue(), 320, titleHeight.cgValue()))
        
>>>>>>> FETCH_HEAD
        var notice:TFHppleElement = self.notices![0]
        
        var titleEl = notice.itemsWithQuery(".tit_info")
        var title = ""
        if titleEl.count > 0 {
            var el = titleEl[0] as TFHppleElement
            title = el.text()
        }
        
        var titleLabel = UILabel(frame: CGRectMake(0, 0, 0, 0))
        titleLabel.text = title
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(titleLabel)
        
        var contentEl = notice.itemsWithQuery(".desc_notice")
        var content = ""
        if contentEl.count > 0 {
            var el = contentEl[0] as TFHppleElement
            content = el.raw
        }

        var html = "<html><head><title></title></head><body style=\"background:transparent;\">"
        html += content
        html += "</body></html>"
        
<<<<<<< HEAD
        var webView = UIWebView(frame: CGRectMake(0, 0, 0, 0))
=======
        var webView = UIWebView(frame: CGRectMake(0, (topMargin + titleHeight).cgValue(), 320, contentHeight.cgValue()))
>>>>>>> FETCH_HEAD
        webView.backgroundColor = UIColor.clearColor()
        webView.loadHTMLString(html, baseURL: nil)
        webView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(webView)
        
        var labelHConst = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label(>=100)]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["label": titleLabel])
        self.view.addConstraints(labelHConst)
        var webViewHConst = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[webview(>=250)]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["webview": webView])
        self.view.addConstraints(webViewHConst)
        var vConst = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[label(50)]-[webview(>=300)]-|", options:NSLayoutFormatOptions(0), metrics: nil, views: ["label": titleLabel, "webview": webView])
        self.view.addConstraints(vConst)
        println("title: " + title);
        println("content: " + content)
    }
    
}