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
                var newItem = html.htmlDocument().itemWithQuery("#writerLayerTemplate")
                println(newItem!.content)
            }
        }
        
        initView()
    }
    
    func initView() {
        println("initView")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: Selector("dismiss"))
    }
    
    func closeView() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}