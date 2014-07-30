//
//  WriterViewController.swift
//  iStoryBall
//
//  Created by 정 다정 on 2014. 7. 29..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import Foundation
class WriterViewController : SBViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = id {
            NetClient.instance.get(url + "#layer/writer") {
                (html: String) in
                var d = html.htmlDocument().itemWithQuery("#writerLayerTemplate")
                if let data = d {
                    var raw = data.raw as NSString
                    var error: NSError?
                    var exp = NSRegularExpression.regularExpressionWithPattern("<(li)[^>]*class=\"writer_on\"[^>]*>([\\s\\S]*?)<\\/\\s?\\1>",
                        options: NSRegularExpressionOptions(0),
                        error: &error)
                    
//                    var result = exp.firstMatchInString(raw,
//                        options: NSMatchingOptions(0),
//                        range: NSMakeRange(0, raw.length))
                    var result = exp.matchesInString(raw, options: NSMatchingOptions(0), range: NSMakeRange(0, raw.length))
                    println(result.count)
                    for r in result {
                        println(r)
                    }
                }

            }
        }
        
        initView()
    }
    
    func initView() {
        println("initView")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: Selector("dismiss"))
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}