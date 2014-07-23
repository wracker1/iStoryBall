//
//  DetailViewController.swift
//  iStoryBall
//
//  Created by AhnEunHa on 2014. 7. 9..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class DetailViewController : SBViewController
{
    var urlString: String?
    
    convenience init(title: String, urlString: String)
    {
        self.init(nibName: nil, bundle: nil)
        self.title = title
        self.urlString = urlString
    }
    
    override func viewDidLoad() {
        var webView = UIWebView(frame: self.view.frame)
        webView.loadRequest(NSURLRequest(URL: NSURL(string: urlString)))
        
        self.view.addSubview(webView)
    }
}
