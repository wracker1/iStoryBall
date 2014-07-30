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
                var error: NSError?
                var exp = DHRegEx.classSelector("writer_on", error: nil)
                var result = exp.matchesInString(html, options: NSMatchingOptions(0), range: html.range())
                for match in result as [NSTextCheckingResult] {
                    println(html.substringWithRange(match.range))
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