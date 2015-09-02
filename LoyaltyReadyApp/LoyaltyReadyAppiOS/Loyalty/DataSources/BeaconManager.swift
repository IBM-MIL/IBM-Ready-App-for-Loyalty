/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

let kBeaconRegionCloseGasStationID: String = "LoyaltyRegion_GasStation"
let kGasStationBeaconMajor: CLBeaconMajorValue = 199

/**
  BeaconManager class not used in the application
*/
class BeaconManager: NSObject, CLLocationManagerDelegate {
    
    var locationManager : CLLocationManager?
    var allBeacons: Array<String> = Array<String>()
    var beaconRegion : CLBeaconRegion?
    var closestBeaconID: String!
    
    /**
    override the init method to set up locationManager and beaconRegion monitoring
    */
    override init() {
        super.init()
        
        //set beacon manager delegate
        self.locationManager = CLLocationManager()
        self.locationManager!.delegate = self
        
        //set beacon region
        self.beaconRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, major: kGasStationBeaconMajor, identifier: kBeaconRegionCloseGasStationID)
        
        self.beaconRegion!.notifyOnEntry = true
        self.beaconRegion!.notifyOnExit = true
        
    }
    
    
    /**
    Begin beacon detection monitoring for the given beaconRegion
    */
    func startBeaconDetection() {
        
        // - Clear any past region monitoring
        for region in self.locationManager!.monitoredRegions {
            self.locationManager!.stopMonitoringForRegion(region as! CLBeaconRegion)
        }
        
        // - Start monitoring
        self.locationManager!.startMonitoringForRegion(self.beaconRegion!)
    }
    
    
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        NSLog("Scanning for beacons in region --> %@...", region.identifier)
        self.locationManager!.startRangingBeaconsInRegion(region as! CLBeaconRegion)
    }
    

    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        // - Start ranging beacons
        NSLog("You entered the region --> %@ - starting scan for beacons", region.identifier)

        self.locationManager!.startRangingBeaconsInRegion(region as! CLBeaconRegion)

        // When entering region, ask for notificaiton from Xtify
        XtifyLocationHelper.updateNearGasStation()
    }
    
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        // - Stop ranging beacons
        NSLog("You exited the region --> %@ - stopping scan for beacons", region)

        self.locationManager!.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
        
        /*var alertView = UIAlertController(title: "Exiting region", message: "left range of beacon: \(region)", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "n/a"), style: .Default, handler: nil))
        var appdel = UIApplication.sharedApplication().delegate as! AppDelegate
        appdel.window?.rootViewController?.presentViewController(alertView, animated: true, completion: nil)*/
    }
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        NSLog("Error monitoring \(error)")
    }
    
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        
        //filter out unknown beacons
        var knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }

        //if beacons are found at all, continue
        if (knownBeacons.count > 0) {
            let closestBeacon = knownBeacons[0] //save closest Beacon for sorting later
            let newBeaconID = closestBeacon.major.stringValue + closestBeacon.minor.stringValue
            
            MQALogger.log("closestBeacon: \(closestBeacon.major) and \(closestBeacon.minor) in prox: \(BeaconManager.proximityAsString(closestBeacon.proximity))")
            
            if (newBeaconID != self.closestBeaconID) { //if new closest beacon
                self.closestBeaconID = newBeaconID
            }
            
        }
        else {
            NSLog("No beacons are nearby")
        }
    }
    
    /**
    returns the string for proximity of a beacon
    
    - parameter proximity: A CLProximity object to extract data from
    
    - returns: a string representation of proximity
    */
    class func proximityAsString(proximity: CLProximity) -> String {
        switch proximity {
        case CLProximity.Far:
            return "Far"
            
        case CLProximity.Near:
            return "Near"
            
        case CLProximity.Immediate:
            return "Immediate"
            
        case CLProximity.Unknown:
            return "Unknown"
        }
    }
    
    
    
    
    
}
