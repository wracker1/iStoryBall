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
    
    override func shouldAutorotate() -> Bool {
        return self.topViewController.shouldAutorotate()
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return self.topViewController.supportedInterfaceOrientations()
    }
}