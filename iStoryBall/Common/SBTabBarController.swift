//
//  SBTabBarController.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 8..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import UIKit

class SBTabBarController : UITabBarController
{
    override func shouldAutorotate() -> Bool {
        return self.selectedViewController.shouldAutorotate()
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return self.selectedViewController.supportedInterfaceOrientations()
    }
}