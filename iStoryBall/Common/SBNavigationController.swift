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
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(rootViewController: UIViewController!) {
        super.init(rootViewController: rootViewController)
        
        var naviFont = UIFont.boldSystemFontOfSize(14)
        var naviColor = UIColor.rgb(76.0, g: 134.0, b: 255.0)
        var shadow = NSShadow()
        shadow.shadowBlurRadius = 0.5
        shadow.shadowColor = UIColor.rgba(0, g: 0, b: 0, a: 0.3)
        shadow.shadowOffset = CGSizeMake(1.0, 1.0)
        
        var naviAttr: NSDictionary = [
            NSFontAttributeName: naviFont,
            NSForegroundColorAttributeName: naviColor,
            NSShadowAttributeName: shadow
        ]
        UINavigationBar.appearance().titleTextAttributes = naviAttr
        
        var barFont = UIFont.systemFontOfSize(14)
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