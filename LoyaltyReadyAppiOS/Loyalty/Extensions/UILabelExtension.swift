/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/


import Foundation
import UIKit

extension UILabel {
    
    func sizeToFitFixedWidth(_ fixedWidth: CGFloat) {
        if text != "" {
            let objcString: NSString = text! as NSString
            var frame = objcString.boundingRect(with: CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil)
            frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: fixedWidth, height: frame.size.height)
        }

    }
    
    class func heightForText(_ text: String, font: UIFont, width: CGFloat)->CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()

        return label.frame.size.height
    }
    
    func setKernAttribute(_ size: CGFloat!){
        let kernAttribute : Dictionary = [NSKernAttributeName: size]
        if text != nil {
            attributedText = NSAttributedString(string: text!, attributes: kernAttribute)
        }
    }
}
