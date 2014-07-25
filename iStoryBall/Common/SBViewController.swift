//
//  SBViewController.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 8..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import UIKit

class SBViewController : UIViewController
{
    var id: String?
    var doc: TFHpple?
    
    convenience init(title: String)
    {
        self.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.edgesForExtendedLayout = UIRectEdge.None
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.toRaw())
    }
    
    func changeTitleView(title: String) {
        var titleLabel = UILabel.boldFontLabel(title, fontSize: 19)
        titleLabel.shadowColor = UIColor.grayColor()
        titleLabel.shadowOffset = CGSizeMake(0.5, 0.5)
        self.navigationItem.titleView = titleLabel
    }
}
