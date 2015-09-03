/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import MapKit

/// Custom MKAnnotation for a map pin
class MapPin: NSObject, MKAnnotation{
    /// Coordinate of station
    var coordinate: CLLocationCoordinate2D
    /// Name of station
    var title: String?
    /// Subtitle of station
    var subtitle: String?
    /// Station tag
    var tag: String
    /// Station the pin represents
    var station: GasStation
    
    /**
    Initialize MapPin object
    
    - parameter coordinate: station coordinate
    - parameter title:      title of station
    - parameter subtitle:   subtitle of station
    - parameter tag:        tag of station
    - parameter station:    station in question
    
    - returns: MapPin object
    */
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, tag: String, station: GasStation){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.tag = tag
        self.station = station
    }
}

