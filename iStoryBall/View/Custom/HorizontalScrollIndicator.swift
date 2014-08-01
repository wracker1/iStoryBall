//
//  HorizontalScrollIndicator.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 31..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class HorizontalScrollIndicator: UIView {
    var prevArrow: UIImageView
    var nextArrow: UIImageView
    var numberOfPages: Int = 0
    
    init(frame: CGRect) {
        prevArrow = UIImageView(image: UIImage(named: "prev_arrow"))
        nextArrow = UIImageView(image: UIImage(named: "next_arrow"))
        
        super.init(frame: frame)
        
        self.addSubview(prevArrow)
        self.addSubview(nextArrow)
        
        var inset:CGFloat = 35.0
        prevArrow.layoutLeftInParentView(.Center, offset: CGPointMake(inset, 0))
        nextArrow.layoutRightInParentView(.Center, offset: CGPointMake(-inset, 0))
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    func didChangePage(page: Int) {
        prevArrow.hidden = page == 0
        nextArrow.hidden = page == (numberOfPages - 1)
    }
}
