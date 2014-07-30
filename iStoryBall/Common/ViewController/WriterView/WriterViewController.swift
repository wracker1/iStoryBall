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
                    var exp = DHRegEx.classSelector("writer_on", error: nil)
                    
//                    var result = exp.firstMatchInString(raw,
//                        options: NSMatchingOptions(0),
//                        range: NSMakeRange(0, raw.length))
                    var result = exp.matchesInString(html, options: NSMatchingOptions(0), ra)
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