//
//  NetClient.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 8..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import Foundation

class NetClient {
    var relativeManager: AFHTTPRequestOperationManager?
    var absoluteManager: AFHTTPRequestOperationManager?
    
    class var instance: NetClient {
        struct Singleton {
            static let instance = NetClient()
        }
        return Singleton.instance
    }
    
    init() {
        var baseURL = NSURL(string: "http://m.storyball.daum.net/")
        relativeManager = AFHTTPRequestOperationManager(baseURL: baseURL)
        relativeManager!.responseSerializer.acceptableContentTypes = nil
        
        absoluteManager = AFHTTPRequestOperationManager()
        absoluteManager!.responseSerializer.acceptableContentTypes = nil
    }
    
    func get(url: String, parameters param: AnyObject?, success: ((html: String) -> Void)?, failure: ((error: NSError) -> Void)?) {
        _get(url, parameters: param, success: success, failure: failure)
    }
    
    func get(url: String, success: ((html: String) -> Void)?) {
        _get(url, parameters: nil, success: success, failure: nil)
    }
    
    func _get(url: String, parameters param: AnyObject?, success: ((html: String) -> Void)?, failure: ((error: NSError) -> Void)?) {
        relativeManager!.GET(url, parameters: param,
            success: {
                (operation: AFHTTPRequestOperation!, html: AnyObject!) in
                
                if let s = success{
                    var content = html as String
                    s(html: content)
                }
            },
            
            failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) in
                
                if let f = failure {
                    f(error: error)
                }
            })
    }
    
    func getWithAbsoluteUrl(url: String, success: ((result: AnyObject) -> Void)?) {
        absoluteManager!.GET(url, parameters: nil,
            success: {
                (operation: AFHTTPRequestOperation!, r: AnyObject!) in
                
                if let s = success {
                    s(result: r)
                }
            
            }, failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) in
                
                if let s = success {
                    s(result: error)
                }
            })
    }
}
