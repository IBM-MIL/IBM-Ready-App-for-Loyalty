/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/**
*  NSObject for the user's rewards
*/
class Rewards: NSObject {
    /// Number of points the user has
    var points: Int! = 0
    /// Value of savings the user has had so far
    var savings: Double! = 0
    /// Progress percentage the user has had so far
    var progress: Int! = 0
    
    /**
    Convinence init of object to intialize based on json dictionary
    
    - parameter json: Dictionary specific to this object
    */
    convenience init(json: [String: AnyObject]){
        self.init()
        points = json["points"] as! Int
        savings = json["savings"] as! Double
        progress = json["progress"] as! Int
    }
}
