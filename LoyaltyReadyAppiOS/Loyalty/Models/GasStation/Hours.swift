/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/**
*  NSObject of the hours for a gas station
*/
class Hours: NSObject {
    /// Time the gas station opens
    var open: NSDate!
    /// Time the gas station closes
    var close: NSDate!
    
    /**
    Convinence init of object to intialize based on json dictionary
    
    - parameter json: Dictionary specific to this object
    */
    convenience init(json: [String: AnyObject]){
        self.init()
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH"
        
        let openString = json["open"]?.stringValue
        let closeString = json["close"]?.stringValue
        
        if (Int(openString!) >= 24){ //midnight should be "0"
            self.open = formatter.dateFromString("0")
        } else{
            self.open = formatter.dateFromString(openString!)
        }
        if (Int(closeString!) >= 24){
            self.close = formatter.dateFromString("0")
        } else {
            self.close = formatter.dateFromString(closeString!)
        }
    }
}
