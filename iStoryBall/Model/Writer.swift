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
    var imageUrl: String
    var profileView: UIImageView?
    
    init(data: Dictionary<String, AnyObject>) {
        imageUrl = data["imageUrl"]! as String
        description = data["description"]! as String
        name = data["name"]! as String
        
        super.init(data: data)
        
    }
    
    
    func loadProfileImage(s: CGSize?, finish: (() -> Void)?) {
        var size = s
        if size == nil {
            size = CGSizeMake(64, 64)
        }
            
        if profileView == nil {
            profileView = UIImageView(frame: CGRect(origin: CGPointZero, size: size!))
        }
        
        profileView!.layer.cornerRadius = profileView!.frame.height / 2
        profileView!.loadSpriteImageAtPosition(imageUrl, imageSize: nil, position: CGPointZero, finish: finish)
    }
}
