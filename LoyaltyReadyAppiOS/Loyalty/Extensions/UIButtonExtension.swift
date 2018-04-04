/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import Foundation
import UIKit

extension UIButton{
    
    func setBackgroundColorForState(_ color: UIColor, forState: UIControlState){
        setBackgroundImage(UIButton.imageWithColor(color, width: frame.size.width, height: frame.size.height), for: forState)
    }
    
    /**
    Create an image of a given color
    
    - parameter color:  The color that the image will have
    - parameter width:  Width of the returned image
    - parameter height: Height of the returned image
    
    - returns: An image with the color, height and width
    */
    fileprivate class func imageWithColor(_ color: UIColor, width: CGFloat, height: CGFloat) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    func setKernAttribute(_ size: CGFloat!){
        
        let states = [UIControlState.application, UIControlState.disabled, UIControlState.highlighted, UIControlState.reserved, UIControlState.selected]
        
        for state in states{
            let titleColor = self.titleColor(for: state)
            let attributes : [String: AnyObject]
            if titleColor != nil {
                attributes = [NSKernAttributeName: size as AnyObject, NSForegroundColorAttributeName: titleColor!]
            }else{
                attributes = [NSKernAttributeName: size as AnyObject]
            }
            let title = self.title(for: state)
            if(title != nil){
                setAttributedTitle(NSAttributedString(string: title!, attributes: attributes), for: state)
            }
        }
        
        
    }
    
}
