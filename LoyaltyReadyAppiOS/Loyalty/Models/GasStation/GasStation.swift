/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit
import CoreLocation

/**
*  NSObject of the gas station
*/
class GasStation: NSObject {
    /// Name of the gas station
    var name: String!
    /// Price of gas at the gas station
    var gasPrice: Double!
    /// Array of amenities at the gas station as an array of strings
    var amenities: [String]!
    /// CLLocationCoordinate2D of the gas station
    var coordinate: CLLocationCoordinate2D!
    /// Gas station address
    var address: String!
    /// Hours object for the gas station
    var hours: Hours!
    /// Phone Number of the gas station
    var phoneNumber: Int!
    /// String url of the gas station's website
    var website: String!
    /// Array of Deals from the gas station
    var deals : [Deal]!
    /// Array of items at the gas station as an array of strings
    var items: [String]!
    /// Bool to represent if station is open or closed currently
    var isOpen: Bool {
        let openHour = hours.open.hour()
        let openMinutes = hours.open.minute()
        let closedHour = hours.close.hour()
        let closedMinutes = hours.close.minute()
        let now = Date()
        let openTime = now.dateAt(hours: openHour, minutes: openMinutes)
        let closeTime = now.dateAt(hours: closedHour, minutes: closedMinutes)
        
        if now >= openTime && now <= closeTime {
            return true
        } else {
            return false
        }
    }
    
    /**
    Convinence init of object to intialize based on json dictionary
    
    - parameter json: Dictionary specific to this object
    */
    convenience init(json: [String: AnyObject]!){
        self.init()
        name = json["name"] as! String
        gasPrice = json["gas_price"] as! Double
        amenities = json["amenities"] as! [String]
        let geoLocation = json["geo_location"] as! [String: CLLocationDegrees]
        let lat = geoLocation["lat"]
        let lon = geoLocation["lon"]
        coordinate = CLLocationCoordinate2DMake(lat!, lon!)
        address = json["address"] as! String
        hours = Hours(json: (json["hours"] as! [String:AnyObject]))
        phoneNumber = json["phone_number"] as! Int
        website = json["website"] as! String
        deals = getDeals(json["deals"] as! [[String:AnyObject]])
        items = json["items"] as! [String]
    }
    
    /**
    Generates an array of objects based on json array
    
    - parameter jsonArray: Array of dictionaries
    
    - returns: Array of objects
    */
    fileprivate func getDeals(_ jsonArray: [[String:AnyObject]]) -> [Deal] {
        var returnDeals = [Deal]()
        for dealJson in jsonArray{
            let deal = Deal(json: dealJson)
            returnDeals.append(deal)
        }
        
        return returnDeals
    }
    
    
}

 func == (this: GasStation, that: GasStation) -> Bool {
    return "\(this.coordinate.latitude)\(this.coordinate.longitude)" == "\(that.coordinate.latitude)\(that.coordinate.longitude)"
}
