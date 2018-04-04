/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

class XtifyLocationHelper: NSObject {
    
    /**
    This method sends a location update to Xtify to be the exact gps coordinates as a predefined Xtify location, thus triggering a push notification on the user's device.
    */
    class func updateNearGasStation() {
        
      //  let cllocation : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 30.332, longitude: -97.705)
      //  XLappMgr.get().updateLocation(with: cllocation, andAlt: Float(229.225098), andAccuracy: Float(4000.000000))
        // watson trigger a notification here to simualate location based notification
    }
    
    
    /**
    This method sends a location update to Xtify to be a random gps coordinate to reset the user's location
    */
    class func resetLocationForDemo() {
        
        let cllocation : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 43.001, longitude: -85.71)
        XLappMgr.get().updateLocation(with: cllocation, andAlt: Float(229.225098), andAccuracy: Float(4000.000000))
    }
    
}
