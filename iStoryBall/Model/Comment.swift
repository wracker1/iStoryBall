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
    var limitHours = 24 * 60 * 60
    var date: String
    var imageUrl: String?
    var profileView: UIImageView?
    var cellHeight: CGFloat?
    
    init(data: Dictionary<String, AnyObject>) {
        emoticon = data["emoticon"]! as String
        commentContent = data["commentContent"]! as String
        daumName = data["daumName"]! as String
        
        var regdttm = data["regDate"]! as Dictionary<String, NSNumber>
        
        var year = regdttm["year"]
        var month = regdttm["month"]
        var day = regdttm["date"]
        var hour = regdttm["hours"]
        var min = regdttm["minutes"]
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-M-d-H-m"
        var regDate = formatter.dateFromString("20\(year!.integerValue - 100)-\(month!.integerValue + 1)-\(day!)-\(hour!)-\(min!)")
        
        var now = NSDate()
        var diff = now.timeIntervalSinceDate(regDate)
        formatter.dateFormat = Int(diff) > limitHours ? "yy.MM.dd" : "HH:mm"
        date = formatter.stringFromDate(regDate)
        
        super.init(data: data)
    }

    func loadProfileImage(size: CGSize, finish: (() -> Void)?) {
        if imageUrl == nil {
            imageUrl = "http://m1.daumcdn.net/img-media/storyball2014/m480/ico_char_140430.png"
        }
        
        if let url = imageUrl {
            if profileView == nil {
                profileView = UIImageView(frame: CGRect(origin: CGPointZero, size: size))
            }
            
            if let image = profileView!.image {
                if let f = finish {
                    f()
                }
            } else {
                var index = emoticon.toInt()
                var x = CGFloat(index! - 1)
                profileView!.loadSpriteImageAtPosition(url, imageSize: nil, position: CGPointMake(CGFloat(size.width * x), size.height), finish: finish)
            }
        } else {
            if let f = finish {
                f()
            }
        }
    }
}
