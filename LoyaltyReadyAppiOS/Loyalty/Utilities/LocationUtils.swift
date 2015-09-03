/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit
import MapKit

/// Useful methods to calculate distance and estimated time between user location and a gas station
class LocationUtils: NSObject {
    /// Shared instance of LocationUtils
    static let sharedInstance = LocationUtils()
    /// Cache to contain estimated distances from location
    var distanceCache = NSCache()
    /// Cache to contain estimated time from location
    var timeCache = NSCache()
    /// User's previous location if changed
    var previousUserLocation: CLLocation!
    
    /**
    This method calculates the distance the gas station is from the user's current location
    
    - parameter gasStation: the gas station to calculate distance from the users location
    
    - returns: the distance the gas station is from the user's location
    */
    func calcDistanceFromUsersLocation(actualIndex : Int, gasStation : GasStation, callback:(Int, CLLocationDistance?, Bool) -> ()) {
        
        if userHasNotMovedSignificantly() && distanceCache.objectForKey(gasStation.address) != nil {
            callback(actualIndex, distanceCache.objectForKey(gasStation.address) as? CLLocationDistance, true)
        }else{
            let gasStationCoordinate = gasStation.coordinate
            let userLocation = getUsersLocation()
            previousUserLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
            let request:MKDirectionsRequest = MKDirectionsRequest()
            // source and destination are the relevant MKMapItems
            let sourcePlace = MKPlacemark(coordinate: userLocation, addressDictionary: nil)
            let source = MKMapItem(placemark: sourcePlace)
            let destPlace = MKPlacemark(coordinate: gasStationCoordinate, addressDictionary: nil)
            let dest = MKMapItem(placemark: destPlace)
            request.source = source
            request.destination = dest
            // Specify the transportation type
            request.transportType = MKDirectionsTransportType.Any;
            
            // If you're open to getting more than one route,
            // requestsAlternateRoutes = true; else requestsAlternateRoutes = false;
            request.requestsAlternateRoutes = false
            let direction = MKDirections(request: request)
            direction.calculateDirectionsWithCompletionHandler ({
                (response: MKDirectionsResponse?, error: NSError?) in
                
                if (error == nil) { //success
                    if let route: MKRoute = response!.routes.first! as MKRoute{
                        let distance = route.distance
                        self.distanceCache.setObject(distance, forKey: gasStation.address)
                        callback(actualIndex, distance, true)
                    }
                }else{ //failure to connect
                    MQALogger.log(error?.localizedDescription)
                    callback(actualIndex, nil, false)
                }
            })
            
        }
    }
    
    /**
    This method calculates the distance and time away the gas station is from the user's current location
    
    - parameter gasStation: the gas station to calculate distance and estimated time from the users location
    
    - returns: the distance and estimated time the gas station is from the user's location
    */
    func calcDistanceAndTimeFromUsersLocation(gasStation : GasStation, callback:(CLLocationDistance?, Double?, Bool) -> ()) {
        
        if userHasNotMovedSignificantly() && distanceCache.objectForKey(gasStation.address) != nil && timeCache.objectForKey(gasStation.address) != nil { //if user is in same spot and cache exists, return cached data
            let distance = distanceCache.objectForKey(gasStation.address) as! CLLocationDistance
            let time = timeCache.objectForKey(gasStation.address) as! NSTimeInterval
            callback(distance, time, true)
        }else{ //if user has moved, request distance and time
            let gasStationCoordinate = gasStation.coordinate
            let userLocation = getUsersLocation()
            previousUserLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
            let request:MKDirectionsRequest = MKDirectionsRequest()
            // source and destination are the relevant MKMapItems
            let sourcePlace = MKPlacemark(coordinate: userLocation, addressDictionary: nil)
            let source = MKMapItem(placemark: sourcePlace)
            let destPlace = MKPlacemark(coordinate: gasStationCoordinate, addressDictionary: nil)
            let dest = MKMapItem(placemark: destPlace)
            request.source = source
            request.destination = dest
            
            // Specify the transportation type
            request.transportType = MKDirectionsTransportType.Any;
            
            // If you're open to getting more than one route,
            // requestsAlternateRoutes = true; else requestsAlternateRoutes = false;
            request.requestsAlternateRoutes = false
            let direction = MKDirections(request: request)
            direction.calculateDirectionsWithCompletionHandler ({
                (response: MKDirectionsResponse?, error: NSError?) in
                
                if (error == nil) { //success
                    if let route: MKRoute = response!.routes.first! as MKRoute{
                        let distance = route.distance
                        let time = route.expectedTravelTime
                        
                        self.distanceCache.setObject(distance, forKey: gasStation.address)
                        self.timeCache.setObject(time, forKey: gasStation.address)
                        
                        callback(distance, time, true)
                    }
                }else{ //failure to connect
                    MQALogger.log(error?.localizedDescription)
                    callback(nil, nil, false)
                }
            })
            
        }
    }
    
    
    /**
    Method to find if user's current location has changed significantly
    
    - returns: boolean of true if user has not moved significantly, and false if user has moved significantly
    */
    func userHasNotMovedSignificantly() -> Bool {
        if previousUserLocation != nil {
            let userLocationCoordinates = getUsersLocation()
            let userLocation = CLLocation(latitude: userLocationCoordinates.latitude, longitude: userLocationCoordinates.longitude)
            
            let distance: CLLocationDistance = previousUserLocation.distanceFromLocation(userLocation)
            let minChangeInMeters: CLLocationDistance = 25
            
            return distance < minChangeInMeters
        }else{
            return false
        }
    }
    
    
    /**
    This method gets the user's location from the app delegate's user object
    
    - returns: the user's location from the app delegates user object
    */
    func getUsersLocation() -> CLLocationCoordinate2D{
        let userLocation = UserDataManager.sharedInstance.currentUser.coordinate
        
        return userLocation
    }
    
}
