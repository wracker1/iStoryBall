//
//  Common.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 14..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import Foundation

class CommonUtil {
    class func mainWindow() -> UIWindow {
        return UIApplication.sharedApplication().windows[0] as UIWindow
    }
    
    class func selectedController() -> UIViewController {
        var tabBarController = mainWindow().rootViewController as UITabBarController
        return tabBarController.selectedViewController
    }
    
    class func navigationBarHeight() -> Float {
        var navigator = selectedController() as UINavigationController
        return navigator.navigationBar.bounds.size.height.swValue()
    }
    
    class func statusBarHeight() -> Float {
        return UIApplication.sharedApplication().statusBarFrame.size.height.swValue()
    }
    
    class func commonTopMargin() -> Float {
        return statusBarHeight() + navigationBarHeight()
    }
}

extension CGFloat {
    func swValue() -> Float {
        return Float(self)
    }
}

extension Float {
    func cgValue() -> CGFloat {
        return CGFloat(self)
    }
}