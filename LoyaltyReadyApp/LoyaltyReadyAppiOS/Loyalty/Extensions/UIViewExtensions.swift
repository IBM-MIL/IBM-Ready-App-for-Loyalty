/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import CoreFoundation
import Foundation
import UIKit

extension UIView{
    var width: CGFloat { return frame.size.width }
    func width(value: CGFloat?) -> UIView {
        setWidth(value ?? 0)
        return self
    }
    
    var height: CGFloat { return frame.size.height }
    func height(value: CGFloat?) -> UIView {
        setHeight(value ?? 0)
        return self
    }
    var size: CGSize  { return frame.size}
    
    var origin: CGPoint { return frame.origin }
    var x: CGFloat { return frame.origin.x }
    var y: CGFloat { return frame.origin.y }
    var centerX: CGFloat { return center.x }
    func centerX(value: CGFloat?) -> UIView {
        setCenterX(value ?? 0)
        return self
    }
    
    var centerY: CGFloat { return center.y }
    
    var left: CGFloat { return frame.origin.x }
    var right: CGFloat { return frame.origin.x + frame.size.width }
    
    var top: CGFloat { return frame.origin.y }
    func top(value: CGFloat?) -> UIView {
        setTop(value ?? 0)
        return self
    }
    
    var bottom: CGFloat { return frame.origin.y + frame.size.height }
    func bottom(value: CGFloat?) -> UIView {
        setBottom(value ?? 0)
        return self
    }
    
    func setWidth(width:CGFloat)
    {
        frame.size.width = width
    }
    
    func setHeight(height:CGFloat)
    {
        frame.size.height = height
    }
    
    func setSize(size:CGSize)
    {
        frame.size = size
    }
    
    func setOrigin(point:CGPoint)
    {
        frame.origin = point
    }
    
    func setOriginX(x:CGFloat)
    {
        frame.origin = CGPointMake(x, frame.origin.y)
    }
    
    func setOriginY(y:CGFloat)
    {
        frame.origin = CGPointMake(frame.origin.x, y)
    }
    
    func setCenterX(x:CGFloat)
    {
        center = CGPointMake(x, center.y)
    }
    
    func setCenterY(y:CGFloat)
    {
        center = CGPointMake(center.x, y)
    }
    
    func roundCorner(radius:CGFloat)
    {
        layer.cornerRadius = radius
    }
    
    func setTop(top:CGFloat)
    {
        frame.origin.y = top
    }
    
    func setLeft(left:CGFloat)
    {
        frame.origin.x = left
    }
    
    func setRight(right:CGFloat)
    {
        frame.origin.x = right - frame.size.width
    }
    
    func setBottom(bottom:CGFloat)
    {
        frame.origin.y = bottom - frame.size.height
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(CGColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.CGColor
        }
    }
    
    func rotate(percent: CGFloat = 100, duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        let p: CGFloat
        if percent > 1 {
            p = percent / 100
        }else{
            p = percent
        }
        
        self.transform = CGAffineTransformMakeRotation(0)
        CATransaction.begin()
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0
        rotateAnimation.toValue = CGFloat(M_PI) * p
        rotateAnimation.duration = duration
        rotateAnimation.removedOnCompletion = false
        
        if let _: AnyObject = completionDelegate {
            rotateAnimation.delegate = self
        }
        CATransaction.setCompletionBlock { () -> Void in
            self.layer.removeAllAnimations()
            self.transform = CGAffineTransformMakeRotation(CGFloat(M_PI) * p)
        }
        self.layer.addAnimation(rotateAnimation, forKey: nil)
        CATransaction.commit()
        
    }
    
    /**
    Helper method to animate size of view by a certain amount and then animate back to original size
    
    - parameter pixelsLarger:      amount to increase width and height by
    - parameter animationDuration: duration the whole animation should take
    - parameter bottomMoves:       deteremines if the bottom should stay in place while the view's size increases
    */
    func animateIncreaseWithBounce(pixelsLarger: CGFloat, animationDuration: NSTimeInterval, bottomMoves: Bool) {
        
        let offset = pixelsLarger / 2
        let halvedDuration = animationDuration / 2
        let originalFrame = self.frame
        
        UIView.animateWithDuration(halvedDuration, animations: {
            
            self.frame = CGRectMake(self.frame.origin.x - offset, self.frame.origin.y - (bottomMoves ? offset : pixelsLarger), self.frame.size.width + pixelsLarger, self.frame.size.height + pixelsLarger)
            
        }) { (done: Bool) -> Void in
            
            UIView.animateWithDuration(halvedDuration, animations: {
                self.frame = CGRectMake(originalFrame.origin.x, originalFrame.origin.y, self.frame.size.width - pixelsLarger, self.frame.size.height - pixelsLarger)
            })
            
        }
        
    }
}








