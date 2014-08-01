//
//  SBModel.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 29..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class SBModel
{
    var data: Dictionary<String, AnyObject>?
    var hppleElement: TFHppleElement?
    
    init(data: Dictionary<String, AnyObject>) {
        self.data = data
    }
    
    init (hppleElement: TFHppleElement) {
        self.hppleElement = hppleElement
    }
}
