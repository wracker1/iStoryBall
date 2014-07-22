//
//  CommonUI.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 17..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import Foundation

class CommonUI {
    class func systemFontLabel(text: String, fontSize: CGFloat) -> UILabel {
        var label = UILabel()
        label.font = UIFont.systemFontOfSize(fontSize)
        label.text = text
        label.sizeToFit()
        return label
    }
    
    class func boldFontLabel(text: String, fontSize: CGFloat) -> UILabel {
        var label = UILabel()
        label.font = UIFont.boldSystemFontOfSize(fontSize)
        label.text = text
        label.sizeToFit()
        return label
    }
}

extension UIView {
    enum UIViewHorizontalAlign {
        case Left, Center, Right
    }
    
    enum UIViewVerticalAlign {
        case Top, Center, Bottom
    }
    
//    parent basis layout
    
    func layoutTopInParentView() {
        self.layoutTopInParentView(.Center)
    }
    
    func layoutTopInParentView(horizontalAlign: UIViewHorizontalAlign) {
        self.layoutTopInParentView(horizontalAlign, offset: CGPointZero)
    }
    
    func layoutTopInParentView(horizontalAlign: UIViewHorizontalAlign, offset: CGPoint) {
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        layoutHorizontal(horizontalAlign, offset: offset)

        var topMargin = offset.y
        var vConst = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(\(topMargin))-[view(==\(self.bounds.size.height))]", options: NSLayoutFormatOptions(0), metrics: nil, views: ["view": self])
        self.superview.addConstraints(vConst)
    }
    
    func layoutBottomInParentView() {
        self.layoutBottomInParentView(.Center)
    }
    
    func layoutBottomInParentView(horizontalAlign: UIViewHorizontalAlign) {
        self.layoutBottomInParentView(horizontalAlign, offset: CGPointZero)
    }
    
    func layoutBottomInParentView(horizontalAlign: UIViewHorizontalAlign, offset: CGPoint) {
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        layoutHorizontal(horizontalAlign, offset: offset)
        
        var bottomMargin = offset.y
        var vConst = NSLayoutConstraint.constraintsWithVisualFormat("V:[view(==\(self.bounds.size.height))]-(\(bottomMargin))-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["view": self])
        self.superview.addConstraints(vConst)
    }
    
    func layoutLeftInParentView() {
        self.layoutLeftInParentView(.Center)
    }
    
    func layoutLeftInParentView(verticalAlign: UIViewVerticalAlign) {
        self.layoutLeftInParentView(verticalAlign, offset: CGPointZero)
    }
    
    func layoutLeftInParentView(verticalAlign: UIViewVerticalAlign, offset: CGPoint) {
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        layoutVertical(verticalAlign, offset: offset)
        
        var leftMargin = offset.x
        var hConst = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(\(leftMargin))-[view(\(self.bounds.size.width))]", options: NSLayoutFormatOptions(0), metrics: nil, views: ["view": self])
        self.superview.addConstraints(hConst)
    }
    
    func layoutRightInParentView() {
        self.layoutRightInParentView(.Center)
    }
    
    func layoutRightInParentView(verticalAlign: UIViewVerticalAlign) {
        self.layoutRightInParentView(verticalAlign, offset: CGPointZero)
    }
    
    func layoutRightInParentView(verticalAlign: UIViewVerticalAlign, offset: CGPoint) {
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        layoutVertical(verticalAlign, offset: offset)
        
        var rightMargin = (offset.x * -1)
        var hConst = NSLayoutConstraint.constraintsWithVisualFormat("H:[view(\(self.bounds.size.width))]-(\(rightMargin))-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["view": self])
        self.superview.addConstraints(hConst)
    }
    
//    sibling basis layout
    
    func layoutTopFromSibling(sibling: UIView) {
        self.layoutTopFromSibling(sibling, horizontalAlign: .Center)
    }
    
    func layoutTopFromSibling(sibling: UIView, horizontalAlign: UIViewHorizontalAlign) {
        self.layoutTopFromSibling(sibling, horizontalAlign: horizontalAlign, offset: CGPointZero)
    }
    
    func layoutTopFromSibling(sibling: UIView, horizontalAlign: UIViewHorizontalAlign, offset: CGPoint) {
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        layoutHorizontal(horizontalAlign, offset: offset)
        
        var bottomMargin = offset.y
        var vConst = NSLayoutConstraint.constraintsWithVisualFormat("V:[v(\(self.bounds.size.height))]-(\(bottomMargin))-[s(\(sibling.bounds.size.height))]", options: NSLayoutFormatOptions(0), metrics: nil, views: ["v": self, "s": sibling])
        var target = commonParent(self, sibling: sibling, times: 0)
        target.addConstraints(vConst)
    }
    
    func layoutBottomFromSibling(sibling: UIView) {
        self.layoutBottomFromSibling(sibling, horizontalAlign: .Center)
    }
    
    func layoutBottomFromSibling(sibling: UIView, horizontalAlign: UIViewHorizontalAlign) {
        self.layoutBottomFromSibling(sibling, horizontalAlign: horizontalAlign, offset: CGPointZero)
    }
    
    func layoutBottomFromSibling(sibling: UIView, horizontalAlign: UIViewHorizontalAlign, offset: CGPoint) {
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        layoutHorizontal(horizontalAlign, offset: offset)
        
        var topMargin = offset.y
        var vConst = NSLayoutConstraint.constraintsWithVisualFormat("V:[s(\(sibling.bounds.size.height))]-(\(topMargin))-[v(\(self.bounds.size.height))]", options: NSLayoutFormatOptions(0), metrics: nil, views: ["v": self, "s": sibling])
        var target = commonParent(self, sibling: sibling, times: 0)
        target.addConstraints(vConst)
    }
    
//    align & util
    
    func commonParent(view: UIView, sibling: UIView, times: Int) -> UIView! {
        var odd = (times % 2) == 1
        var a = odd ? view.superview : view
        var b = odd ? sibling : sibling.superview
        
        if a == b {
            return a
        } else {
            return commonParent(a, sibling: b, times: times + 1)
        }
    }
    
    func layoutVertical(verticalAlign: UIViewVerticalAlign, offset: CGPoint) {
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
        self.superview.addConstraints(vConst)
    }
    
    func layoutHorizontal(horizontalAlign: UIViewHorizontalAlign, offset: CGPoint) {
        var parentSize = self.superview.bounds.size
        var leftMargin = 0.0
        var rightMargin = 0.0
        
        switch horizontalAlign {
        case .Center:
            leftMargin = (Double(parentSize.width) - Double(self.bounds.size.width)) / 2.0
            rightMargin = leftMargin
        case .Right:
            leftMargin = Double(parentSize.width) - Double(self.bounds.size.width)
            rightMargin = 0.0
        default:
            leftMargin = 0.0
            rightMargin = Double(parentSize.width) - Double(self.bounds.size.width)
        }
        
        leftMargin += Double(offset.x)
        rightMargin -= Double(offset.x)
        
        var hConst = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(\(leftMargin))-[view(\(self.bounds.size.width))]-(\(rightMargin))-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["view": self])
        self.superview.addConstraints(hConst)
    }
}