/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/**
*  NSObject for a deal
*/
class Deal: NSObject {
    /// Name of the deal
    var name: String!
    /// Expiration date of the deal
    var expiration: Date!
    /// Short description of the deal
    var highlight: String!
    /// Long description of the deal
    var finePrint: String!
    /// Boolean to determine if the user has saved a deal or not
    var saved = false
    /// String describing the name of the image associated with the deal
    var imageName: String!
    /// String describing the name of the watch image associated with the deal
    var watchImage: String!
    /// ID for each deal
    var dealId: Int!
    let logger : OCLogger = OCLogger.getInstanceWithPackage("Loyalty");
    
    
    /**
    Convinence init of object to intialize based on json dictionary
    
    - parameter json: Dictionary specific to this object
    */
    convenience init(json: [String: AnyObject]){
        self.init()
        name = json["name"] as? String
        if let expirationValue = json["expiration"] as? Int{
            expiration = Date().dateByAddingDays(expirationValue)
        }
        logger.logInfoWithMessages(message: "name-----\(name)")
        dealId = json["deal_id"] as! Int
        highlight = json["highlight"] as! String
        finePrint = json["fine_print"] as! String
        imageName = json["image_name"] as! String
        if let wkImage = json["watch_image"] as? String {
            watchImage = wkImage
        }
    }
    
    /**
    Convenience init for deals coming from Xtify as a notification. Notice Json keys are abbreviated for smaller byte size
    
    - parameter notificationJson: json returned from Xtify
    */
    convenience init(notificationJson: [String: AnyObject]) {
        self.init()
        
        name = notificationJson["name"] as? String
        if let expirationValue = notificationJson["exp"] as? Int {
            expiration = Date().dateByAddingDays(expirationValue)
        } else if let expirationString = notificationJson["exp"] as? String {
            
            // In case a string is sent as an expiration number
            if let expValue = Int(expirationString) {
                expiration = Date().dateByAddingDays(expValue)
            }
        }
        
        if let tempHighlight = notificationJson["hl"] as? String {
            highlight = tempHighlight
        }
        
        if let tempImgName = notificationJson["im"] as? String {
            imageName = tempImgName
        } else {
            imageName = "sportsDrink"
        }
        
        // Assuming always this so we don't have to send finePrint string in Json payload
        finePrint = NSLocalizedString("Coupon must be presented at time of purchase. Offer not valid on clearance and marked down items. May not be combined with other coupons or associate discount. One coupon per family. No reproductions. Not valid for shopping online. Participation and availability may vary by store. Valid in US stores only.", comment: "")
        
        /*
        Example Action Data:
        
        {
        "title": "Nearby Deal",
        "deal": {
        "name": "25% Off Sports Drinks",
        "im": "sportsDrink",
        "exp": 23,
        "hl": "25% Off Sports Drinks, check it out"
        }
        }
        
        Flat Action Data:
        
        {
        "title": "Nearby Deal",
        "name": "Free Ice Cream Sandwich",
        "im": "iceCream",
        "exp": 14,
        "hl": "Free Ice Cream Sandwich, check it out"
        }
        
        */
        
    }
    
}
