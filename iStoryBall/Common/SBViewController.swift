//
//  SBViewController.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 8..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import UIKit

class SBViewController : UIViewController
{
    convenience init(title: String)
    {
        self.init(nibName: nil, bundle: nil)
        
        self.title = title
    }
}
