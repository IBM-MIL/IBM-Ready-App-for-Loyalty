/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/**
*  NSObject of a transaction item
*/
class TransactionItem: NSObject {
    /// Name of the item
    var name: String!
    /// Quantity of the items purchased
    var quantity: Int!
    /// Unit of the item
    var unit: String!
    /// Price per unit of the item
    var ppu: Double!
    
    /**
    Convinence init of object to intialize based on json dictionary
    
    - parameter json: Dictionary specific to this object
    */
    convenience init(json: [String: AnyObject]){
        self.init()
        name = json["name"] as! String
        quantity = json["quantity"] as! Int
        unit = json["unit"] as! String
        ppu = json["ppu"] as! Double
    }
}
