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
        var font = UIFont.boldSystemFontOfSize(14)
        var color = UIColor.rgb(76.0, g: 134.0, b: 237.0)
        var attr: NSDictionary = [ NSFontAttributeName: font, NSForegroundColorAttributeName: color ]
        
        UINavigationBar.appearance().titleTextAttributes = attr
        UIBarButtonItem.appearance().setTitleTextAttributes(attr, forState: .Normal)
    }
    
    override func shouldAutorotate() -> Bool {
        return self.topViewController.shouldAutorotate()
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return self.topViewController.supportedInterfaceOrientations()
    }
}