/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/**
*  NSObject of the user's profile
*/
class Profile: NSObject {
    /// Array of preferences the user has as an array of strings
    var preferences = [String]()
    /// Array of tags the user has as an array of strings
    var tags = [String]()
    /// Contact information for the user
    var contact: Contact! = Contact()
    /// Array of Vehicles for the user
    var vehicles = [Vehicle]()
    /// Rewards object containing the user's rewards
    var rewards: Rewards! = Rewards()
    
    /**
    Convinence init of object to intialize based on json dictionary
    
    - parameter json: Dictionary specific to this object
    */
    convenience init(json: [String: AnyObject]){
        self.init()
        preferences = json["preferences"] as! [String]
        tags = json["tags"] as! [String]
        contact = Contact(json: json["contact"] as! [String:AnyObject])
        vehicles = getVehicles(json["vehicles"] as! [[String:AnyObject]])
        rewards = Rewards(json: json["rewards"] as! [String:AnyObject])
        
    }
    
    /**
    Generates an array of objects based on json array
    
    - parameter jsonArray: Array of dictionaries
    
    - returns: Array of objects
    */
    private func getVehicles(jsonArray: [[String:AnyObject]]) -> [Vehicle] {
        var returnVehicles = [Vehicle]()
        for vehicleJson in jsonArray{
            let vehicle = Vehicle(json: vehicleJson)
            returnVehicles.append(vehicle)
        }
        
        return returnVehicles
    }
}
