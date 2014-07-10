//
//  Article.swift
//  iStoryBall
//
//  Created by AhnEunHa on 2014. 7. 9..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//


class Article
{
    var id: String
    var title: String?
    var subtitle: String?
    var imageUrl: String?
    var like: String?
    
    init(id: String) {
        self.id = id
    }

    func getRealId() -> String {
        println("self : \(self.id)")
        return self.id.stringByReplacingOccurrencesOfString("e", withString: "",
            options: nil, range: nil)
    }
}
