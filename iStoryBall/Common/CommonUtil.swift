//
//  Common.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 14..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import Foundation

func mainWindow() -> UIWindow {
    return UIApplication.sharedApplication().windows[0] as UIWindow
}

func selectedController() -> UIViewController {
    var tabBarController = mainWindow().rootViewController as UITabBarController
    return tabBarController.selectedViewController
}

func navigationBarHeight() -> Float {
    var navigator = selectedController() as UINavigationController
    return navigator.navigationBar.bounds.size.height.swValue()
}

func statusBarHeight() -> Float {
    return UIApplication.sharedApplication().statusBarFrame.size.height.swValue()
}

func commonTopMargin() -> Float {
    return statusBarHeight() + navigationBarHeight()
}

func unique<T: Equatable>(a: [T], b: [T]) -> [T] {
    return a.filter {
        return contains(b, $0)
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
    
    func range() -> NSRange {
        var string = self as NSString
        return NSMakeRange(0, string.length)
    }
}