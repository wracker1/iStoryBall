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
    var titleFontSize: CGFloat = 20.0
    let minFontSize: CGFloat = 14.0
    
    convenience init(title: String)
    {
        self.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    deinit {
        println("### deinit ### \(self)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.edgesForExtendedLayout = UIRectEdge.None
        
        changeTitleView(self.title)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.toRaw())
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func changeTitleView(title: String) {
        self.navigationItem.titleView = titleLabelWithFontSize(titleFontSize)
    }
    
    func titleLabelWithFontSize(fontSize: CGFloat) -> UILabel {
        var maxWidth = self.view.bounds.size.width / 1.8
        var titleLabel = UILabel.boldFontLabel(title, fontSize: fontSize)
        titleLabel.textAlignment = .Left
        titleLabel.shadowColor = UIColor.grayColor()
        titleLabel.shadowOffset = CGSizeMake(0.5, 0.5)
        
        var size = titleLabel.bounds.size
        
        if size.width > maxWidth {
            if fontSize > minFontSize {
                return titleLabelWithFontSize(fontSize - 1.0)
            } else {
                titleLabel.numberOfLines = 0
                titleLabel.sizeToFit()
                return titleLabel
            }
        } else {
            return titleLabel
        }
    }
}
