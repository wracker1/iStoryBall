//
//  Writer.swift
//  iStoryBall
//
//  Created by 정 다정 on 2014. 7. 30..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class Writer: SBModel
{
    var description: String
    var name: String
    var imageUrl: String?
    var profileView: UIImageView?
    
    init(raw: String) {
        var data = Dictionary<String, AnyObject>()
//        emoticon = data["emoticon"]! as String
//        description = data["commentContent"]! as String
//        name = data["name"]! as String
        
        
        super.init(data: data)
    }
    
    func loadProfileImage(s: CGSize?, finish: (() -> Void)?) {
        if imageUrl == nil {
            imageUrl = "http://m1.daumcdn.net/img-media/storyball2014/m480/ico_char_140430.png"
        }
        
        if let url = imageUrl {
            var size = s
            if size == nil {
                size = CGSizeMake(37, 37)
            }
            
            if profileView == nil {
                profileView = UIImageView(frame: CGRect(origin: CGPointZero, size: size!))
            }
            
            if let image = profileView!.image {
                if let f = finish {
                    f()
                }
            }
        } else {
            if let f = finish {
                f()
            }
        }
    }
}
