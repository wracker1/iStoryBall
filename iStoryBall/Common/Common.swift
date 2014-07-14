//
//  Common.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 14..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import Foundation

class Common {
    class func imageUrlFromHppleElement(element: TFHppleElement) -> String? {
        var url: String?
        var info = element.attributes["style"] as NSString
        
        if info != nil {
            var regex = NSRegularExpression.regularExpressionWithPattern("background-image:url\\(([^)]+)", options: NSRegularExpressionOptions(0), error: nil)
            var result = regex.firstMatchInString(info, options: NSMatchingOptions(0), range: NSMakeRange(0, info.length))
            url = info.substringWithRange(result.rangeAtIndex(1))
        }
        
        return url
    }
    
    class func mainWindow() -> UIWindow {
        return UIApplication.sharedApplication().windows[0] as UIWindow
    }
    
    class func selectedController() -> UIViewController {
        var tabBarController = mainWindow().rootViewController as UITabBarController
        return tabBarController.selectedViewController
    }
    
    class func navigationBarHeight() -> Float {
        var navigator = selectedController() as UINavigationController
        return navigator.navigationBar.bounds.size.height
    }
    
    class func statusBarHeight() -> Float {
        return UIApplication.sharedApplication().statusBarFrame.size.height
    }
    
    class func commonTopMargin() -> Float {
        return statusBarHeight() + navigationBarHeight()
    }
}