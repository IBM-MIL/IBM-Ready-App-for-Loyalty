/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/**
*  NSObject for a vehicle a user has
*/
class Vehicle: NSObject {
    /// The make of the vehicle
    var make: String!
    /// The model of the vehicle
    var model: String!
    /// The year of the vehicle
    var year: Int!
    
    /**
    Convinence init of object to intialize based on json dictionary
    
    - parameter json: Dictionary specific to this object
    */
    convenience init(json: [String: AnyObject]){
        self.init()
        make = json["make"] as! String
        model = json["model"] as! String
        year = json["year"] as! Int
    }
}
