/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit
import CoreLocation

/**
*  NSObject for the user that is logged in
*/
class User: NSObject {
    /// ID
    var id: Int!
    /// Rev
    var rev: Int! = 0
    /// Type
    var type: String! = ""
    //User's name
    var username: String! = ""
    /// Array of user's transactions
    var transactions = [Transaction]()
    /// Array of gas stations
    var gasStations = [GasStation]()
    /// Array of deals for the user
    var deals = [Deal]()
    /// User's profile
    var profile = Profile()
    /// CLLocationCoordinate2D of the user
    var coordinate: CLLocationCoordinate2D! = CLLocationCoordinate2D()
    /// Bool to determine if the user is logged in
    var loggedIn: Bool {
        return id != nil
    }
    /// Boolean to determine if user has synced with Twitter
    var syncedWithTwitter = false
    /// Array of interests that a user has selected
    var interests = Set<String>()
    
    /**
    Convinence init of object to intialize based on json dictionary
    
    - parameter json: Dictionary specific to this object
    */
    convenience init(json: [String: AnyObject]) {
        self.init()
        id = json["id"] as? Int
        rev = json["rev"] as? Int
        type = json["type"] as? String
        username = json["username"] as? String
        if let profileJson = json["profile"] as? [String: AnyObject] {
            profile = Profile(json: profileJson)
        }
        
        if let geoLocationJson = json["geo_location"] as? [String: CLLocationDegrees]{
            let lat = geoLocationJson["lat"]
            let lon = geoLocationJson["lon"]
            coordinate = CLLocationCoordinate2DMake(lat!, lon!)
        }
        if let trans = getTransactions(json["transactions"] as? [[String:AnyObject]]){
            transactions = trans
        }
        deals = getDeals(json["deals"] as? [[String:AnyObject]])
        gasStations = getGasStations(json["gas_stations"] as? [[String:AnyObject]])
    }
    /**
    Generates an array of objects based on json array
    
    - parameter jsonArray: Array of dictionaries
    
    - returns: Array of objects
    */
    private func getGasStations(jsonArray: [[String:AnyObject]]!) -> [GasStation]! {
        if jsonArray != nil{
            var returnGasStations = [GasStation]()
            for gasStationJson in jsonArray{
                let gasStation = GasStation(json: gasStationJson)
                returnGasStations.append(gasStation)
            }
            
            return returnGasStations
        }else{
            return nil
        }
    }
    
    /**
    Generates an array of objects based on json array
    
    - parameter jsonArray: Array of dictionaries
    
    - returns: Array of objects
    */
    private func getDeals(jsonArray: [[String:AnyObject]]!) -> [Deal]! {
        if jsonArray != nil{
            var returnDeals = [Deal]()
            for dealJson in jsonArray{
                let deal = Deal(json: dealJson)
                returnDeals.append(deal)
            }
            
            return returnDeals
        }else{
            return nil
        }
    }
    
    /**
    Generates an array of objects based on json array
    
    - parameter jsonArray: Array of dictionaries
    
    - returns: Array of objects
    */
    private func getTransactions(jsonArray: [[String:AnyObject]]!) -> [Transaction]! {
        if jsonArray != nil{
            var returnTransactions = [Transaction]()
            for transactionJson in jsonArray{
                let transaction = Transaction(json: transactionJson)
                returnTransactions.append(transaction)
            }
            
            return returnTransactions
        }else{
            return nil
        }
    }
}
