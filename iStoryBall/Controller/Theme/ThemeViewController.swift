//
//  ThemeViewController.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 8..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class ThemeViewController : SBViewController
{
    var themeScroller: UIScrollView?
    var themeItemList = Array<TFHppleElement>()
    var selectedButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeTitleView("테마")
        
        NetClient.instance.get("/story/list") {
            (html: String) in
            self.doc = html.htmlDocument()
            self.layoutSubviews()
        }
    }
    
    func layoutSubviews() {
        createThemeScroller()
    }
    
    func createThemeScroller() {
        themeItemList = doc!.itemsWithQuery(".list_genre li")
        var size = self.view.bounds.size
        var height: CGFloat = 60.0
        
        themeScroller = UIScrollView(frame: CGRectMake(0, 0, size.width, height))
        themeScroller!.showsHorizontalScrollIndicator = false
        self.view.addSubview(themeScroller)
        themeScroller!.layoutTopInParentView()
        
        var sibling: UIButton?
        
        for var i = 0; i < themeItemList.count; i++ {
            var item = themeItemList[i]
            var imageNode = item.itemWithQuery(".thumb_img")
            var imageUrl = imageNode!.attributes["src"] as NSString
            var title = item.itemWithQuery(".tit_genre")?.text()?.trim()
            
            var button = UIButton.buttonWithType(.Custom) as UIButton
            button.frame = CGRectMake(0, 0, 55, 50)
            button.setImageForState(.Normal, withURL: NSURL(string: imageUrl))
            button.setTitle(title!, forState: .Normal)
            button.setTitleColor(UIColor.grayColor(), forState: .Normal)
            button.titleLabel.font = UIFont.systemFontOfSize(8)
            button.tag = i + 100
            button.verticalAlignContent(CGSizeMake(34, 30))
            button.addTarget(self, action: Selector("themeButtonTouched:"), forControlEvents: UIControlEvents.TouchUpInside)
            themeScroller!.addSubview(button)
            
            if let s = sibling {
                button.layoutRightFromSibling(s, verticalAlign: .Center, offset: CGPointMake(10, 0))
            } else {
                button.layoutLeftInParentView(.Top, offset: CGPointMake(0, 0))
                selectThemeButton(button)
            }
            
            sibling = button
        }
        
        var sFrame = sibling!.frame
        themeScroller!.contentSize = CGSizeMake(sFrame.origin.x + sFrame.size.width, height)
    }
    
    func selectThemeButton(button: UIButton) {
        if let b = selectedButton {
            b.setTitleColor(UIColor.grayColor(), forState: .Normal)
            b.titleLabel.font = UIFont.systemFontOfSize(8)
        }
        
        button.setTitleColor(UIColor.pointColor(1.0), forState: .Normal)
        button.titleLabel.font = UIFont.boldSystemFontOfSize(8)
        selectedButton = button
    }
    
    func themeButtonTouched(button: UIButton) {
        var index = button.tag - 100
        
        selectThemeButton(button)
    }
}
