//
//  SBNavigationController.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 8..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import UIKit

class SBNavigationController : UINavigationController
{
    class func instanceWithViewController(viewController : UIViewController) -> SBNavigationController {
        return SBNavigationController(rootViewController: viewController)
    }
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(rootViewController: UIViewController!) {
        super.init(rootViewController: rootViewController)
        
        var naviFont = UIFont.boldSystemFontOfSize(14)
        var naviColor = UIColor.blackColor()
        var shadow = NSShadow()
        shadow.shadowBlurRadius = 0.5
        shadow.shadowColor = UIColor.grayColor()
        shadow.shadowOffset = CGSizeMake(0.5, 0.5)
        
        var naviAttr: NSDictionary = [
            NSFontAttributeName: naviFont,
            NSForegroundColorAttributeName: naviColor,
            NSShadowAttributeName: shadow
        ]
        UINavigationBar.appearance().titleTextAttributes = naviAttr
        
        var barFont = UIFont.boldSystemFontOfSize(13)
        var barColor = UIColor.rgb(76.0, g: 134.0, b: 237.0)
        var barAttr: NSDictionary = [ NSFontAttributeName: barFont, NSForegroundColorAttributeName: barColor ]
        
        UIBarButtonItem.appearance().setTitleTextAttributes(barAttr, forState: .Normal)
    }
    
    override func shouldAutorotate() -> Bool {
        return self.topViewController.shouldAutorotate()
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return self.topViewController.supportedInterfaceOrientations()
    }
}