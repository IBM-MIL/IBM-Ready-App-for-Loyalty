/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


/**
*  NSObject of the hours for a gas station
*/
class Hours: NSObject {
    /// Time the gas station opens
    var open: Date!
    /// Time the gas station closes
    var close: Date!
    
    /**
    Convinence init of object to intialize based on json dictionary
    
    - parameter json: Dictionary specific to this object
    */
    convenience init(json: [String: AnyObject]){
        self.init()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        
        let openString = json["open"]?.stringValue
        let closeString = json["close"]?.stringValue
        
        if (Int(openString!) >= 24){ //midnight should be "0"
            self.open = formatter.date(from: "0")
        } else{
            self.open = formatter.date(from: openString!)
        }
        if (Int(closeString!) >= 24){
            self.close = formatter.date(from: "0")
        } else {
            self.close = formatter.date(from: closeString!)
        }
    }
}
