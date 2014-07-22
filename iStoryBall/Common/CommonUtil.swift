//
//  Common.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 14..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import Foundation

class CommonUtil {
    class func imageUrlFromHppleElement(element: TFHppleElement) -> String? {
        var url: String?
        var info = element.attributes["style"] as NSString
        
        if info != nil {
            // |background:url\\(([^)]+) 만 추가하면 될 줄 알았는데 안됨...
            var regex = NSRegularExpression.regularExpressionWithPattern("background-image:url\\(([^)]+)", options: NSRegularExpressionOptions(0), error: nil)
            var result = regex.firstMatchInString(info, options: NSMatchingOptions(0), range: NSMakeRange(0, info.length))
            println(result)
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
        return navigator.navigationBar.bounds.size.height.swValue()
    }
    
    class func statusBarHeight() -> Float {
        return UIApplication.sharedApplication().statusBarFrame.size.height.swValue()
    }
    
    class func commonTopMargin() -> Float {
        return statusBarHeight() + navigationBarHeight()
    }
}

extension UIColor {
    class func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return self.rgba(r, g: g, b: b, a: 1.0)
    }
    
    class func rgba(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
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

extension String {
    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
}