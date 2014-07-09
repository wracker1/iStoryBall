//
//  HomeViewController.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 8..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class HomeViewController : SBViewController
{
    var displayScrollView: UIScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayScrollView = UIScrollView(frame: CGRectMake(0, 0, 320, 180))
        displayScrollView!.pagingEnabled = true
        
        self.view!.addSubview(displayScrollView)
    }
}