//
//  CommonUI.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 17..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import Foundation

enum SBFontSize: Int {
    case font1 = 12, font2 = 14, font3 = 16, font4 = 18, font5 = 20
    
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
            button.titleLabel.font = UIFont.systemFontOfSize(12)
            button.setTitleColor(UIColor.grayColor(), forState: .Normal)
        }
        
        if let i = image {
            button.setImage(i, forState: .Normal)
        }
        
        button.addTarget(target, action: selector, forControlEvents: .TouchUpInside)
        button.sizeToFit()

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
    
//    top
    func activateConstraintsTopInParentView() {
        self.activateConstraintsTopInParentView(.Center)
    }
    
    func activateConstraintsTopInParentView(horizontalAlign: UIViewHorizontalAlign) {
        self.activateConstraintsTopInParentView(horizontalAlign, offset: CGPointZero)
    }
    
    func activateConstraintsTopInParentView(horizontalAlign: UIViewHorizontalAlign, offset: CGPoint) {
        var topMargin = offset.y
        var visualFormat = "V:|-(\(topMargin))-[view(\(self.bounds.size.height))]"
        var vConst = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat,
            options: NSLayoutFormatOptions(0),
            metrics: nil,
            views: ["view": self]
        )
        
        addVerticalConstraintsWithSibling(nil, horizontalAlign: horizontalAlign, offset: offset, verticalConstraint: vConst)
    }
    
//    bottom
    func activateConstraintsBottomInParentView() {
        self.activateConstraintsBottomInParentView(.Center)
    }
    
    func activateConstraintsBottomInParentView(horizontalAlign: UIViewHorizontalAlign) {
        self.activateConstraintsBottomInParentView(horizontalAlign, offset: CGPointZero)
    }
    
    func activateConstraintsBottomInParentView(horizontalAlign: UIViewHorizontalAlign, offset: CGPoint) {
        var bottomMargin = -offset.y
        var visualFormat = "V:[view(\(self.bounds.size.height))]-(\(bottomMargin))-|"
        var vConst = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat,
            options: NSLayoutFormatOptions(0),
            metrics: nil,
            views: ["view": self]
        )
        
        addVerticalConstraintsWithSibling(nil, horizontalAlign: horizontalAlign, offset: offset, verticalConstraint: vConst)
    }
    
//    left
    func activateConstraintsLeftInParentView() {
        self.activateConstraintsLeftInParentView(.Center)
    }
    
    func activateConstraintsLeftInParentView(verticalAlign: UIViewVerticalAlign) {
        self.activateConstraintsLeftInParentView(verticalAlign, offset: CGPointZero)
    }
    
    func activateConstraintsLeftInParentView(verticalAlign: UIViewVerticalAlign, offset: CGPoint) {
        var leftMargin = offset.x
        var visualFormat = "H:|-(\(leftMargin))-[view(\(self.bounds.size.width))]"
        var hConst = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat,
            options: NSLayoutFormatOptions(0),
            metrics: nil,
            views: ["view": self]
        )
        
        addHorizontalConstraintsWithSibling(nil, verticalAlign: verticalAlign, offset: offset, horizontalConstraint: hConst)
    }
    
//    right
    func activateConstraintsRightInParentView() {
        self.activateConstraintsRightInParentView(.Center)
    }
    
    func activateConstraintsRightInParentView(verticalAlign: UIViewVerticalAlign) {
        self.activateConstraintsRightInParentView(verticalAlign, offset: CGPointZero)
    }
    
    func activateConstraintsRightInParentView(verticalAlign: UIViewVerticalAlign, offset: CGPoint) {
        var rightMargin = (offset.x * -1)
        var visualFormat = "H:[view(\(self.bounds.size.width))]-(\(rightMargin))-|"
        var hConst = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat,
            options: NSLayoutFormatOptions(0),
            metrics: nil,
            views: ["view": self]
        )
        
        addHorizontalConstraintsWithSibling(nil, verticalAlign: verticalAlign, offset: offset, horizontalConstraint: hConst)
    }
    
//    top
    func activateConstraintsTopFromSibling(sibling: UIView) {
        self.activateConstraintsTopFromSibling(sibling, horizontalAlign: .Center)
    }
    
    func activateConstraintsTopFromSibling(sibling: UIView, horizontalAlign: UIViewHorizontalAlign) {
        self.activateConstraintsTopFromSibling(sibling, horizontalAlign: horizontalAlign, offset: CGPointZero)
    }
    
    func activateConstraintsTopFromSibling(sibling: UIView, horizontalAlign: UIViewHorizontalAlign, offset: CGPoint) {
        self.activateConstraintsTopFromSibling(sibling, horizontalAlign: horizontalAlign, offset: offset, flexible: false)
    }
    
    func activateConstraintsTopFromSibling(sibling: UIView, horizontalAlign: UIViewHorizontalAlign, offset: CGPoint, flexible: Bool) {
        var bottomMargin = offset.y
        var sizeFormat = flexible ? ">=\(self.bounds.size.height)" : "\(self.bounds.size.height)"
        var visualFormat = "V:[v(\(sizeFormat))]-(\(bottomMargin))-[s]"
        var vConst = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat,
            options: NSLayoutFormatOptions(0),
            metrics: nil,
            views: ["v": self, "s": sibling]
        )
        
        addVerticalConstraintsWithSibling(sibling, horizontalAlign: horizontalAlign, offset: offset, verticalConstraint: vConst)
    }
    
//    bottom
    func activateConstraintsBottomFromSibling(sibling: UIView) {
        self.activateConstraintsBottomFromSibling(sibling, horizontalAlign: .Center)
    }
    
    func activateConstraintsBottomFromSibling(sibling: UIView, horizontalAlign: UIViewHorizontalAlign) {
        self.activateConstraintsBottomFromSibling(sibling, horizontalAlign: horizontalAlign, offset: CGPointZero)
    }
    
    func activateConstraintsBottomFromSibling(sibling: UIView, horizontalAlign: UIViewHorizontalAlign, offset: CGPoint) {
        self.activateConstraintsBottomFromSibling(sibling, horizontalAlign: horizontalAlign, offset: offset, flexible: false)
    }
    
    func activateConstraintsBottomFromSibling(sibling: UIView, horizontalAlign: UIViewHorizontalAlign, offset: CGPoint, flexible: Bool) {
        var topMargin = offset.y
        var sizeFormat = flexible ? ">=\(self.bounds.size.height)" : "\(self.bounds.size.height)"
        var visualFormat = "V:[s]-(\(topMargin))-[v(\(sizeFormat))]"
        var vConst = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat,
            options: NSLayoutFormatOptions(0),
            metrics: nil,
            views: ["v": self, "s": sibling]
        )
        
        addVerticalConstraintsWithSibling(sibling, horizontalAlign: horizontalAlign, offset: offset, verticalConstraint: vConst)
    }
    
//    left
    func activateConstraintsLeftFromSibling(sibling: UIView) {
        self.activateConstraintsLeftFromSibling(sibling, verticalAlign: .Center)
    }
    
    func activateConstraintsLeftFromSibling(sibling: UIView, verticalAlign: UIViewVerticalAlign) {
        self.activateConstraintsLeftFromSibling(sibling, verticalAlign: verticalAlign, offset: CGPointZero)
    }
    
    func activateConstraintsLeftFromSibling(sibling: UIView, verticalAlign: UIViewVerticalAlign, offset: CGPoint) {
        self.activateConstraintsLeftFromSibling(sibling, verticalAlign: verticalAlign, offset: offset, flexible: false)
    }
    
    func activateConstraintsLeftFromSibling(sibling: UIView, verticalAlign: UIViewVerticalAlign, offset: CGPoint, flexible: Bool) {
        var rightMargin = -offset.x
        var sizeFormat = flexible ? ">=\(self.bounds.size.width)" : "\(self.bounds.size.width)"
        var visualFormat = "H:[v(\(sizeFormat))]-(\(rightMargin))-[s]"
        var hConst = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat,
            options: NSLayoutFormatOptions(0),
            metrics: nil,
            views: ["v": self, "s": sibling]
        )
        
        addHorizontalConstraintsWithSibling(sibling, verticalAlign: verticalAlign, offset: offset, horizontalConstraint: hConst)
    }
    
//    right
    func activateConstraintsRightFromSibling(sibling: UIView) {
        self.activateConstraintsRightFromSibling(sibling, verticalAlign: .Center)
    }
    
    func activateConstraintsRightFromSibling(sibling: UIView, verticalAlign: UIViewVerticalAlign) {
        self.activateConstraintsRightFromSibling(sibling, verticalAlign: verticalAlign, offset: CGPointZero)
    }
    
    func activateConstraintsRightFromSibling(sibling: UIView, verticalAlign: UIViewVerticalAlign, offset: CGPoint) {
        self.activateConstraintsRightFromSibling(sibling, verticalAlign: verticalAlign, offset: offset, flexible: false)
    }
    
    func activateConstraintsRightFromSibling(sibling: UIView, verticalAlign: UIViewVerticalAlign, offset: CGPoint, flexible: Bool) {
        var leftMargin = offset.x
        var sizeFormat = flexible ? ">=\(self.bounds.size.width)" : "\(self.bounds.size.width)"
        var visualFormat = "H:[s]-(\(leftMargin))-[v(\(sizeFormat))]"
        var hConst = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat,
            options: NSLayoutFormatOptions(0),
            metrics: nil,
            views: ["v": self, "s": sibling]
        )
        
        addHorizontalConstraintsWithSibling(sibling, verticalAlign: verticalAlign, offset: offset, horizontalConstraint: hConst)
    }
    
//    constraints align util
    
    func addVerticalConstraintsWithSibling(sibling: UIView?, horizontalAlign: UIViewHorizontalAlign, offset: CGPoint, verticalConstraint: [AnyObject]) {
        NSLayoutConstraint.activateConstraints(verticalConstraint)
        activateHorizontalConstraintWithTarget(horizontalAlign, offset: offset)
    }
    
    func addHorizontalConstraintsWithSibling(sibling: UIView?, verticalAlign: UIViewVerticalAlign, offset: CGPoint, horizontalConstraint: [AnyObject]) {
        NSLayoutConstraint.activateConstraints(horizontalConstraint)
        activateVerticalConstraintWithTarget(verticalAlign, offset: offset)
    }
    
    func activateVerticalConstraintWithTarget(verticalAlign: UIViewVerticalAlign, offset: CGPoint) {
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        var parentSize = self.superview.bounds.size
        var topMargin = 0.0
        var bottomMargin = 0.0
        var height = Double(self.bounds.size.height)
        
        switch verticalAlign {
        case .Center:
            topMargin = (Double(parentSize.height) - height) / 2.0
            bottomMargin = topMargin
        case .Bottom:
            topMargin = Double(parentSize.height) - height
            bottomMargin = 0.0
        default:
            topMargin = 0.0
            bottomMargin = Double(parentSize.height) - height
        }
        
        topMargin += Double(offset.y)
        bottomMargin -= Double(offset.y)
        
        var vConst = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(\(topMargin))-[view(\(height))]-(\(bottomMargin))-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["view": self])
        NSLayoutConstraint.activateConstraints(vConst)
    }
    
    func activateHorizontalConstraintWithTarget(horizontalAlign: UIViewHorizontalAlign, offset: CGPoint) {
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        var parentSize = self.superview.bounds.size
        var leftMargin = 0.0
        var rightMargin = 0.0
        var width = Double(self.bounds.size.width)
        
        switch horizontalAlign {
        case .Center:
            leftMargin = (Double(parentSize.width) - width) / 2.0
            rightMargin = leftMargin
        case .Right:
            leftMargin = Double(parentSize.width) - width
            rightMargin = 0.0
        default:
            leftMargin = 0.0
            rightMargin = Double(parentSize.width) - width
        }
        
        leftMargin += Double(offset.x)
        rightMargin -= Double(offset.x)
        
        var hConst = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(\(leftMargin))-[view(\(self.bounds.size.width))]-(\(rightMargin))-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["view": self])
        NSLayoutConstraint.activateConstraints(hConst)
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
        var parentSize = self.superview.bounds.size
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