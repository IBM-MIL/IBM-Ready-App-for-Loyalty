/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import CoreFoundation
import Foundation
import UIKit

extension UIView{
    var width: CGFloat { return frame.size.width }
    func width(_ value: CGFloat?) -> UIView {
        setWidth(value ?? 0)
        return self
    }
    
    var height: CGFloat { return frame.size.height }
    func height(_ value: CGFloat?) -> UIView {
        setHeight(value ?? 0)
        return self
    }
    var size: CGSize  { return frame.size}
    
    var origin: CGPoint { return frame.origin }
    var x: CGFloat { return frame.origin.x }
    var y: CGFloat { return frame.origin.y }
    var centerX: CGFloat { return center.x }
    func centerX(_ value: CGFloat?) -> UIView {
        setCenterX(value ?? 0)
        return self
    }
    
    var centerY: CGFloat { return center.y }
    
    var left: CGFloat { return frame.origin.x }
    var right: CGFloat { return frame.origin.x + frame.size.width }
    
    var top: CGFloat { return frame.origin.y }
    func top(_ value: CGFloat?) -> UIView {
        setTop(value ?? 0)
        return self
    }
    
    var bottom: CGFloat { return frame.origin.y + frame.size.height }
    func bottom(_ value: CGFloat?) -> UIView {
        setBottom(value ?? 0)
        return self
    }
    
    func setWidth(_ width:CGFloat)
    {
        frame.size.width = width
    }
    
    func setHeight(_ height:CGFloat)
    {
        frame.size.height = height
    }
    
    func setSize(_ size:CGSize)
    {
        frame.size = size
    }
    
    func setOrigin(_ point:CGPoint)
    {
        frame.origin = point
    }
    
    func setOriginX(_ x:CGFloat)
    {
        frame.origin = CGPoint(x: x, y: frame.origin.y)
    }
    
    func setOriginY(_ y:CGFloat)
    {
        frame.origin = CGPoint(x: frame.origin.x, y: y)
    }
    
    func setCenterX(_ x:CGFloat)
    {
        center = CGPoint(x: x, y: center.y)
    }
    
    func setCenterY(_ y:CGFloat)
    {
        center = CGPoint(x: center.x, y: y)
    }
    
    func roundCorner(_ radius:CGFloat)
    {
        layer.cornerRadius = radius
    }
    
    func setTop(_ top:CGFloat)
    {
        frame.origin.y = top
    }
    
    func setLeft(_ left:CGFloat)
    {
        frame.origin.x = left
    }
    
    func setRight(_ right:CGFloat)
    {
        frame.origin.x = right - frame.size.width
    }
    
    func setBottom(_ bottom:CGFloat)
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
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    func rotate(_ percent: CGFloat = 100, duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        let p: CGFloat
        if percent > 1 {
            p = percent / 100
        }else{
            p = percent
        }
        
        self.transform = CGAffineTransform(rotationAngle: 0)
        CATransaction.begin()
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0
        rotateAnimation.toValue = CGFloat(M_PI) * p
        rotateAnimation.duration = duration
        rotateAnimation.isRemovedOnCompletion = false
        
        if let _: AnyObject = completionDelegate {
            rotateAnimation.delegate = self as! CAAnimationDelegate
        }
        CATransaction.setCompletionBlock { () -> Void in
            self.layer.removeAllAnimations()
            self.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI) * p)
        }
        self.layer.add(rotateAnimation, forKey: nil)
        CATransaction.commit()
        
    }
    
    /**
    Helper method to animate size of view by a certain amount and then animate back to original size
    
    - parameter pixelsLarger:      amount to increase width and height by
    - parameter animationDuration: duration the whole animation should take
    - parameter bottomMoves:       deteremines if the bottom should stay in place while the view's size increases
    */
    func animateIncreaseWithBounce(_ pixelsLarger: CGFloat, animationDuration: TimeInterval, bottomMoves: Bool) {
        
        let offset = pixelsLarger / 2
        let halvedDuration = animationDuration / 2
        let originalFrame = self.frame
        
        UIView.animate(withDuration: halvedDuration, animations: {
            
            self.frame = CGRect(x: self.frame.origin.x - offset, y: self.frame.origin.y - (bottomMoves ? offset : pixelsLarger), width: self.frame.size.width + pixelsLarger, height: self.frame.size.height + pixelsLarger)
            
        }, completion: { (done: Bool) -> Void in
            
            UIView.animate(withDuration: halvedDuration, animations: {
                self.frame = CGRect(x: originalFrame.origin.x, y: originalFrame.origin.y, width: self.frame.size.width - pixelsLarger, height: self.frame.size.height - pixelsLarger)
            })
            
        }) 
        
    }
}








