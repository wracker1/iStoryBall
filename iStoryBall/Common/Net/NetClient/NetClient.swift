//
//  NetClient.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 8..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import Foundation

class NetClient {
    var manager: AFHTTPRequestOperationManager?
    
    class var instance: NetClient {
        struct Singleton {
            static let instance = NetClient()
        }
        return Singleton.instance
    }
    
    init() {
        manager = AFHTTPRequestOperationManager()
        manager!.responseSerializer.acceptableContentTypes = nil
    }
    
    func get(#url: String, parameters param: AnyObject?, success: ((html: String) -> Void)?, failure: ((error: NSError) -> Void)?) {
        manager!.GET(url, parameters: param,
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
}
