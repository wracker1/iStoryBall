//
//  CommonUI.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 17..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import Foundation

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
    class func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return self.rgba(r, g: g, b: b, a: 1.0)
    }
    
    class func rgba(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
}

extension UIView {
    enum UIViewHorizontalAlign {
        case Left, Center, Right
    }
    
    enum UIViewVerticalAlign {
        case Top, Center, Bottom
    }
    
    func padding(value: UIEdgeInsets) {
        var top = -value.top
        var right = -value.right
        var bottom = -value.bottom
        var left = -value.left
        self.frame = UIEdgeInsetsInsetRect(self.frame, UIEdgeInsetsMake(top, left, bottom, right))
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
    
    func layoutTopInParentView(horinzontalAlign: UIViewHorizontalAlign, offset: CGPoint) {
        var frame: CGRect!
        var parentSize = self.superview.bounds.size
        var size = self.bounds.size
        var origin = CGPointZero
        
        switch horinzontalAlign {
        case .Center:
            origin.x = (parentSize.width - size.width) / 2.0
        case .Right:
            origin.x = parentSize.width - size.width
        default:
            origin = CGPointZero
        }
        
        origin.x += offset.x
        origin.y += offset.y
        
        self.frame = CGRect(origin: origin, size: size)
    }
}