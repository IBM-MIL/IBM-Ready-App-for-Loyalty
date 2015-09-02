/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/**
*  NSObject for the contact information for a user
*/
class Contact: NSObject {
    /// User's first name
    var firstName: String! = ""
    /// User's last name
    var lastName: String! = ""
    /// User's gender
    var gender: String! = ""
    /// User's age
    var age: Int! = 0
    /// User's city
    var city: String! = ""
    /// User's state
    var state: String! = ""
    /// User's zip
    var zip: Int! = 0
    /// User's country
    var country: String! = ""
    /// User's phone number
    var phone: String! = ""
    
    /**
    Convinence init of object to intialize based on json dictionary
    
    - parameter json: Dictionary specific to this object
    */
    convenience init(json: [String: AnyObject]){
        self.init()
        firstName = json["first_name"] as! String
        lastName = json["last_name"] as! String
        gender = json["gender"] as! String
        age = json["age"] as! Int
        city = json["city"] as! String
        state = json["state"] as! String
        zip = json["zip"] as! Int
        country = json["country"] as! String
        phone = json["phone"] as! String
    }
}
