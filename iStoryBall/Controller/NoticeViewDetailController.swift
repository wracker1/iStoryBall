//
//  NoticeViewDetail.swift
//  iStoryBall
//
//  Created by 정 다정 on 2014. 7. 15..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class NoticeDetailViewController : SBViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var label = UILabel()
        label.text = "큐큐"
        self.view.addSubview(label)
    }
}