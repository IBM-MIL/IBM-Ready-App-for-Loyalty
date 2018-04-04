/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import Foundation

extension Double{
    
    
    func roundToDecimalDigits(_ decimals:Int) -> Double
    {
        let a : Double = self
        let format : NumberFormatter = NumberFormatter()
        format.numberStyle = NumberFormatter.Style.decimal
        format.roundingMode = NumberFormatter.RoundingMode.halfUp
        format.maximumFractionDigits = decimals
        let string: NSString = format.string(from: NSNumber(value: a as Double))! as NSString
        return string.doubleValue
    }
    
    func formatToDecimalDigits(_ decimals:Int) -> String
    {
        let a : Double = self
        let format : NumberFormatter = NumberFormatter()
        format.numberStyle = NumberFormatter.Style.decimal
        format.roundingMode = NumberFormatter.RoundingMode.halfUp
        format.maximumFractionDigits = decimals
        let string: NSString = format.string(from: NSNumber(value: a as Double))! as NSString
        
        return string as String
    }
}
