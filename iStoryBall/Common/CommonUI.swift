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
    
//    parent basis layout
    
//    top
    func layoutTopInParentView() {
        self.layoutTopInParentView(.Center)
    }
    
    func layoutTopInParentView(horizontalAlign: UIViewHorizontalAlign) {
        self.layoutTopInParentView(horizontalAlign, offset: CGPointZero)
    }
    
    func layoutTopInParentView(horizontalAlign: UIViewHorizontalAlign, offset: CGPoint) {
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
    func layoutBottomInParentView() {
        self.layoutBottomInParentView(.Center)
    }
    
    func layoutBottomInParentView(horizontalAlign: UIViewHorizontalAlign) {
        self.layoutBottomInParentView(horizontalAlign, offset: CGPointZero)
    }
    
    func layoutBottomInParentView(horizontalAlign: UIViewHorizontalAlign, offset: CGPoint) {
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
    func layoutLeftInParentView() {
        self.layoutLeftInParentView(.Center)
    }
    
    func layoutLeftInParentView(verticalAlign: UIViewVerticalAlign) {
        self.layoutLeftInParentView(verticalAlign, offset: CGPointZero)
    }
    
    func layoutLeftInParentView(verticalAlign: UIViewVerticalAlign, offset: CGPoint) {
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
    func layoutRightInParentView() {
        self.layoutRightInParentView(.Center)
    }
    
    func layoutRightInParentView(verticalAlign: UIViewVerticalAlign) {
        self.layoutRightInParentView(verticalAlign, offset: CGPointZero)
    }
    
    func layoutRightInParentView(verticalAlign: UIViewVerticalAlign, offset: CGPoint) {
        var rightMargin = (offset.x * -1)
        var visualFormat = "H:[view(\(self.bounds.size.width))]-(\(rightMargin))-|"
        var hConst = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat,
            options: NSLayoutFormatOptions(0),
            metrics: nil,
            views: ["view": self]
        )
        
        addHorizontalConstraintsWithSibling(nil, verticalAlign: verticalAlign, offset: offset, horizontalConstraint: hConst)
    }
    
//    sibling basis layout
    
//    top
    func layoutTopFromSibling(sibling: UIView) {
        self.layoutTopFromSibling(sibling, horizontalAlign: .Center)
    }
    
    func layoutTopFromSibling(sibling: UIView, horizontalAlign: UIViewHorizontalAlign) {
        self.layoutTopFromSibling(sibling, horizontalAlign: horizontalAlign, offset: CGPointZero)
    }
    
    func layoutTopFromSibling(sibling: UIView, horizontalAlign: UIViewHorizontalAlign, offset: CGPoint) {
        self.layoutTopFromSibling(sibling, horizontalAlign: horizontalAlign, offset: offset, flexible: false)
    }
    
    func layoutTopFromSibling(sibling: UIView, horizontalAlign: UIViewHorizontalAlign, offset: CGPoint, flexible: Bool) {
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
    func layoutBottomFromSibling(sibling: UIView) {
        self.layoutBottomFromSibling(sibling, horizontalAlign: .Center)
    }
    
    func layoutBottomFromSibling(sibling: UIView, horizontalAlign: UIViewHorizontalAlign) {
        self.layoutBottomFromSibling(sibling, horizontalAlign: horizontalAlign, offset: CGPointZero)
    }
    
    func layoutBottomFromSibling(sibling: UIView, horizontalAlign: UIViewHorizontalAlign, offset: CGPoint) {
        self.layoutBottomFromSibling(sibling, horizontalAlign: horizontalAlign, offset: offset, flexible: false)
    }
    
    func layoutBottomFromSibling(sibling: UIView, horizontalAlign: UIViewHorizontalAlign, offset: CGPoint, flexible: Bool) {
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
    func layoutLeftFromSibling(sibling: UIView) {
        self.layoutLeftFromSibling(sibling, verticalAlign: .Center)
    }
    
    func layoutLeftFromSibling(sibling: UIView, verticalAlign: UIViewVerticalAlign) {
        self.layoutLeftFromSibling(sibling, verticalAlign: verticalAlign, offset: CGPointZero)
    }
    
    func layoutLeftFromSibling(sibling: UIView, verticalAlign: UIViewVerticalAlign, offset: CGPoint) {
        self.layoutLeftFromSibling(sibling, verticalAlign: verticalAlign, offset: offset, flexible: false)
    }
    
    func layoutLeftFromSibling(sibling: UIView, verticalAlign: UIViewVerticalAlign, offset: CGPoint, flexible: Bool) {
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
    func layoutRightFromSibling(sibling: UIView) {
        self.layoutRightFromSibling(sibling, verticalAlign: .Center)
    }
    
    func layoutRightFromSibling(sibling: UIView, verticalAlign: UIViewVerticalAlign) {
        self.layoutRightFromSibling(sibling, verticalAlign: verticalAlign, offset: CGPointZero)
    }
    
    func layoutRightFromSibling(sibling: UIView, verticalAlign: UIViewVerticalAlign, offset: CGPoint) {
        self.layoutRightFromSibling(sibling, verticalAlign: verticalAlign, offset: offset, flexible: false)
    }
    
    func layoutRightFromSibling(sibling: UIView, verticalAlign: UIViewVerticalAlign, offset: CGPoint, flexible: Bool) {
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
    
//    align & util
    
    func addVerticalConstraintsWithSibling(sibling: UIView?, horizontalAlign: UIViewHorizontalAlign, offset: CGPoint, verticalConstraint: [AnyObject]) {
        NSLayoutConstraint.activateConstraints(verticalConstraint)
        layoutHorizontalWithTarget(horizontalAlign, offset: offset)
    }
    
    func addHorizontalConstraintsWithSibling(sibling: UIView?, verticalAlign: UIViewVerticalAlign, offset: CGPoint, horizontalConstraint: [AnyObject]) {
        NSLayoutConstraint.activateConstraints(horizontalConstraint)
        layoutVerticalWithTarget(verticalAlign, offset: offset)
    }
    
    func layoutVerticalWithTarget(verticalAlign: UIViewVerticalAlign, offset: CGPoint) {
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
    
    func layoutHorizontalWithTarget(horizontalAlign: UIViewHorizontalAlign, offset: CGPoint) {
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
}