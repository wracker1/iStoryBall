//
//  Comment.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 29..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class Comment: SBModel
{
    var emoticon: String
    var commentContent: String
    var daumName: String
    var regDate: Dictionary<String, NSNumber>
    var imageUrl: String?
    var profileView: UIImageView?
    
    init(data: Dictionary<String, AnyObject>) {
        emoticon = data["emoticon"]! as String
        commentContent = data["commentContent"]! as String
        daumName = data["daumName"]! as String
        regDate = data["regDate"]! as Dictionary<String, NSNumber>
        
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
            } else {
                var index = emoticon.toInt()
                var x = CGFloat(index! - 1)
                profileView!.loadSpriteImageAtPosition(url, imageSize: nil, position: CGPointMake(size!.width * x, size!.height), finish: finish)
            }
        } else {
            if let f = finish {
                f()
            }
        }
    }
}
