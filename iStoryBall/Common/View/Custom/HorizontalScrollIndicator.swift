//
//  HorizontalScrollIndicator.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 31..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class HorizontalScrollIndicator: UIView {
    var prevArrow: UIButton?
    var nextArrow: UIButton?
    var numberOfPages: Int = 0
    weak var scrollView: DHPageScrollView?
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prevArrow = UIButton.buttonWithType(.Custom) as UIButton!
        prevArrow!.setImage(UIImage(named: "prev_arrow"), forState: .Normal)
        
        nextArrow = UIButton.buttonWithType(.Custom) as UIButton!
        nextArrow!.setImage(UIImage(named: "next_arrow"), forState: .Normal)
        
        prevArrow!.addTarget(self, action: Selector("buttonTouched:"), forControlEvents: UIControlEvents.TouchUpInside)
        nextArrow!.addTarget(self, action: Selector("buttonTouched:"), forControlEvents: UIControlEvents.TouchUpInside)
        prevArrow!.sizeToFit()
        nextArrow!.sizeToFit()
        
        self.addSubview(prevArrow!)
        self.addSubview(nextArrow!)
        
        var inset:CGFloat = 35.0
        prevArrow!.layoutLeftInParentView(.Center, offset: CGPointMake(inset, 0))
        nextArrow!.layoutRightInParentView(.Center, offset: CGPointMake(-inset, 0))
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    convenience init(scrollView: DHPageScrollView) {
        self.init(frame: scrollView.bounds)
        
        self.scrollView = scrollView
        self.addSubview(scrollView)
        
        self.bringSubviewToFront(prevArrow!)
        self.bringSubviewToFront(nextArrow!)
    }
    
    func buttonTouched(button: UIButton) {
        if let s = scrollView {
            var page = s.currentPage
            
            if button === prevArrow {
                s.scrollToPage(page - 1, animated: true)
            } else if button === nextArrow {
                s.scrollToPage(page + 1, animated: true)
            }
        }
    }
    
    func didChangePage(page: Int) {
        prevArrow!.hidden = page == 0
        nextArrow!.hidden = page == (numberOfPages - 1)
    }
}
