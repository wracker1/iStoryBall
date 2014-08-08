//
//  CommonUI.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 17..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import Foundation

enum SBFontSize: Int {
    case font1 = 11, font2 = 13, font3 = 15, font4 = 17, font5 = 19
    case cellSubTitle = 12, cellTitle = 14
    
    func valueOf() -> CGFloat {
        return CGFloat(self.toRaw())
    }
}

enum ComponentSize: Int {
    case HorinzontalScrollerHeight = 55
    
    func valueOf() -> CGFloat {
        return CGFloat(self.toRaw())
    }
}

extension UITableView {
    func insertRowToBottom(indexPaths: [NSIndexPath]) {
        UIView.setAnimationsEnabled(false)
        self.beginUpdates()
        self.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
        self.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
}

extension UIImageView {
    func loadSpriteImageAtPosition(url: String, imageSize: CGSize?, position: CGPoint, finish: (() -> Void)?) {
        var request = NSURLRequest(URL: NSURL(string: url))
        
        self.setImageWithURLRequest(request,
            placeholderImage: nil,
            success: {
                (req: NSURLRequest!, res: NSHTTPURLResponse!, image: UIImage!) in
                
                var imgSize: CGSize?
                
                self.image = image
                self.contentMode = .ScaleAspectFill
                self.clipsToBounds = true
                
                if let iSize = imageSize {
                    imgSize = iSize
                } else {
                    imgSize = self.bounds.size
                }
                
                var size = self.image.size
                var sizeRate = CGSizeMake(imgSize!.width / size.width, imgSize!.height / size.height)
                var imageOrigin = CGPointMake(sizeRate.width * position.x / imgSize!.width, sizeRate.height * position.y / imgSize!.height)
                
                var origin = self.frame.origin
                self.frame = CGRect(origin: origin, size: imgSize!)
                
                self.layer.contentsRect = CGRect(origin: imageOrigin, size: sizeRate)
                
                if let f = finish {
                    f()
                }
            },
            failure: {
                (req: NSURLRequest!, res: NSHTTPURLResponse!, error: NSError!) in
                
                if let f = finish {
                    f()
                }
            })
    }
}

extension UILabel {
    class func systemFontLabel(text: String, fontSize: CGFloat) -> UILabel {
        var label = UILabel()
        label.font = UIFont.systemFontOfSize(fontSize)
        label.text = text
        label.textAlignment = .Center
        label.sizeToFit()
        return label
    }
    
    class func boldFontLabel(text: String, fontSize: CGFloat) -> UILabel {
        var label = UILabel()
        label.font = UIFont.boldSystemFontOfSize(fontSize)
        label.text = text
        label.textAlignment = .Center
        label.sizeToFit()
        return label
    }
}

extension UIColor {
    class func pointColor(alpha: CGFloat) -> UIColor {
        return self.rgba(76.0, g: 134.0, b: 237.0, a: alpha)
    }
    
    class func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return self.rgba(r, g: g, b: b, a: 1.0)
    }
    
    class func rgba(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
}

extension UIButton {
    func verticalAlignContent(imageSize: CGSize) {
        self.titleLabel.sizeToFit()
        var titleSize = self.titleLabel.bounds.size
        var spacing: CGFloat = 3.0
        self.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0, 0, -titleSize.width)
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageSize.width), -(imageSize.height + spacing), 0)
    }
    
    class func barButtonItem(title: String?, image: UIImage?, target: AnyObject, selector: Selector) -> UIBarButtonItem {
        var button = UIButton.buttonWithType(.Custom) as UIButton
        
        if let t = title {
            button.setTitle(t, forState: .Normal)
            button.titleLabel.font = UIFont.boldSystemFontOfSize(SBFontSize.font2.valueOf())
            button.setTitleColor(UIColor.grayColor(), forState: .Normal)
        }
        
        if let i = image {
            button.setImage(i, forState: .Normal)
        }
        
        button.addTarget(target, action: selector, forControlEvents: .TouchUpInside)
        button.sizeToFit()
        button.padding(UIEdgeInsetsMake(5, 5, 5, 5))

        return UIBarButtonItem(customView: button)
    }
}

extension UIView {
    enum UIViewHorizontalAlign {
        case None, Left, Center, Right
    }
    
    enum UIViewVerticalAlign {
        case None, Top, Center, Bottom
    }
    
    enum UIViewPosition {
        case Top, Right, Bottom, Left, Center
    }
    
    func padding(value: UIEdgeInsets) {
        var top = -value.top
        var right = -value.right
        var bottom = -value.bottom
        var left = -value.left
        self.frame = UIEdgeInsetsInsetRect(self.frame, UIEdgeInsetsMake(top, left, bottom, right))
    }
    
    func sizeThatFits(size: CGSize) -> CGSize {
        var s = size

        for view in self.subviews {
            var frame = view.frame
            s.width = max(s.width, (frame.origin.x + frame.size.width))
            s.height = max(s.height, (frame.origin.y + frame.size.height))
        }
        
        return s
    }
    
//    layout in parent
    
    func layoutTopInParentView() {
        self.layoutTopInParentView(.Center)
    }
    
    func layoutTopInParentView(horinzontalAlign: UIViewHorizontalAlign) {
        self.layoutTopInParentView(horinzontalAlign, offset: CGPointZero)
    }
    
    func layoutTopInParentView(horinzontalAlign: UIViewHorizontalAlign, offset: CGPoint) {
        self.frame = frameInParentView(horinzontalAlign, verticalAlign: .Top, offset: offset)
    }
    
    func layoutBottomInParentView() {
        self.layoutBottomInParentView(.Center)
    }
    
    func layoutBottomInParentView(horinzontalAlign: UIViewHorizontalAlign) {
        self.layoutBottomInParentView(horinzontalAlign, offset: CGPointZero)
    }
    
    func layoutBottomInParentView(horinzontalAlign: UIViewHorizontalAlign, offset: CGPoint) {
        self.frame = frameInParentView(horinzontalAlign, verticalAlign: .Bottom, offset: offset)
    }
    
    func layoutLeftInParentView() {
        self.layoutLeftInParentView(.Center)
    }
    
    func layoutLeftInParentView(verticalAlign: UIViewVerticalAlign) {
        self.layoutLeftInParentView(verticalAlign, offset: CGPointZero)
    }
    
    func layoutLeftInParentView(verticalAlign: UIViewVerticalAlign, offset: CGPoint) {
        self.frame = frameInParentView(.Left, verticalAlign: verticalAlign, offset: offset)
    }
    
    func layoutRightInParentView() {
        self.layoutRightInParentView(.Center)
    }
    
    func layoutRightInParentView(verticalAlign: UIViewVerticalAlign) {
        self.layoutRightInParentView(verticalAlign, offset: CGPointZero)
    }
    
    func layoutRightInParentView(verticalAlign: UIViewVerticalAlign, offset: CGPoint) {
        self.frame = frameInParentView(.Right, verticalAlign: verticalAlign, offset: offset)
    }
    
    func layoutCenterInParentView() {
        self.layoutCenterInParentView(CGPointZero)
    }
    
    func layoutCenterInParentView(offset: CGPoint) {
        self.frame = frameInParentView(.Center, verticalAlign: .Center, offset: offset)
    }
    
    func frameInParentView(horinzontalAlign: UIViewHorizontalAlign, verticalAlign: UIViewVerticalAlign, offset: CGPoint) -> CGRect {
        if let s = self.superview {
            var parentSize = s.bounds.size
            var size = self.bounds.size
            var origin = CGPointZero
            
            switch verticalAlign {
            case .Center:
                origin.y = (parentSize.height - size.height) / 2.0
            case .Bottom:
                origin.y = parentSize.height - size.height
            default:
                origin.y = 0.0
            }
            
            switch horinzontalAlign {
            case .Center:
                origin.x = (parentSize.width - size.width) / 2.0
            case .Right:
                origin.x = parentSize.width - size.width
            default:
                origin.x = 0.0
            }
            
            origin.x += offset.x
            origin.y += offset.y
            
            return CGRect(origin: origin, size: size)
        } else {
            return CGRectZero
        }
    }
    
//    layout from sibling
    
    func layoutTopFromSibling(sibling: UIView) {
        self.layoutTopFromSibling(sibling, horizontalAlign: .Center)
    }
    
    func layoutTopFromSibling(sibling: UIView, horizontalAlign: UIViewHorizontalAlign) {
        self.layoutTopFromSibling(sibling, horizontalAlign: horizontalAlign, offset: CGPointZero)
    }
    
    func layoutTopFromSibling(sibling: UIView, horizontalAlign: UIViewHorizontalAlign, offset: CGPoint) {
        self.frame = frameFromSibling(sibling, position: .Top, horizontalAlign: horizontalAlign, verticalAlign: .None, offset: offset)
    }
    
    func layoutBottomFromSibling(sibling: UIView) {
        self.layoutBottomFromSibling(sibling, horizontalAlign: .Center)
    }
    
    func layoutBottomFromSibling(sibling: UIView, horizontalAlign: UIViewHorizontalAlign) {
        self.layoutBottomFromSibling(sibling, horizontalAlign: horizontalAlign, offset: CGPointZero)
    }
    
    func layoutBottomFromSibling(sibling: UIView, horizontalAlign: UIViewHorizontalAlign, offset: CGPoint) {
        self.frame = frameFromSibling(sibling, position: .Bottom, horizontalAlign: horizontalAlign, verticalAlign: .None, offset: offset)
    }
    
    func layoutRightFromSibling(sibling: UIView) {
        self.layoutRightFromSibling(sibling, verticalAlign: .Center)
    }
    
    func layoutRightFromSibling(sibling: UIView, verticalAlign: UIViewVerticalAlign) {
        self.layoutRightFromSibling(sibling, verticalAlign: verticalAlign, offset: CGPointZero)
    }
    
    func layoutRightFromSibling(sibling: UIView, verticalAlign: UIViewVerticalAlign, offset: CGPoint) {
        self.frame = frameFromSibling(sibling, position: .Right, horizontalAlign: .None, verticalAlign: verticalAlign, offset: offset)
    }
    
    func layoutLeftFromSibling(sibling: UIView) {
        self.layoutLeftFromSibling(sibling, verticalAlign: .Center)
    }
    
    func layoutLeftFromSibling(sibling: UIView, verticalAlign: UIViewVerticalAlign) {
        self.layoutLeftFromSibling(sibling, verticalAlign: verticalAlign, offset: CGPointZero)
    }
    
    func layoutLeftFromSibling(sibling: UIView, verticalAlign: UIViewVerticalAlign, offset: CGPoint) {
        self.frame = frameFromSibling(sibling, position: .Left, horizontalAlign: .None, verticalAlign: verticalAlign, offset: offset)
    }
    
    func frameFromSibling(sibling: UIView, position: UIViewPosition, horizontalAlign: UIViewHorizontalAlign, verticalAlign: UIViewVerticalAlign, offset: CGPoint) -> CGRect {
        var siblingFrame = sibling.frame
        var size = self.bounds.size
        var origin = CGPointZero
        
        switch position {
        case .Top:
            origin.y = siblingFrame.origin.y - size.height
            origin.x = horizontalOriginXFromSibling(sibling, horizontalAlign: horizontalAlign)
        case .Bottom:
            origin.y = siblingFrame.origin.y + siblingFrame.size.height
            origin.x = horizontalOriginXFromSibling(sibling, horizontalAlign: horizontalAlign)
        case .Right:
            origin.x = siblingFrame.origin.x + siblingFrame.size.width
            origin.y = verticalOriginYFromSibling(sibling, verticalAlign: verticalAlign)
        default:
            origin.x = siblingFrame.origin.x - size.width
            origin.y = verticalOriginYFromSibling(sibling, verticalAlign: verticalAlign)
        }
        
        origin.x += offset.x
        origin.y += offset.y
        
        return CGRect(origin: origin, size: size)
    }
    
    func horizontalOriginXFromSibling(sibling: UIView, horizontalAlign: UIViewHorizontalAlign) -> CGFloat {
        var x: CGFloat = 0.0
        var siblingFrame = sibling.frame
        var size = self.bounds.size
        
        switch horizontalAlign {
        case .Left:
            x = siblingFrame.origin.x
        case .Center:
            x = (siblingFrame.size.width - size.width) / 2.0 + siblingFrame.origin.x
        case .Right:
            x = siblingFrame.origin.x + siblingFrame.size.width - size.width
        default:
            x = 0.0
        }
        
        return x
    }
    
    func verticalOriginYFromSibling(sibling: UIView, verticalAlign: UIViewVerticalAlign) -> CGFloat {
        var y: CGFloat = 0.0
        var siblingFrame = sibling.frame
        var size = self.bounds.size
        
        switch verticalAlign {
        case .Top:
            y = siblingFrame.origin.y
        case .Center:
            y = (siblingFrame.size.height - size.height) / 2.0 + siblingFrame.origin.y
        case .Bottom:
            y = siblingFrame.origin.y + siblingFrame.size.height - size.height
        default:
            y = 0.0
        }
        
        return y
    }
}