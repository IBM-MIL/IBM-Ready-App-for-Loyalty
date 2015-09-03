/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/**
* UIView displaying a near by station's details
*/
class StationView: UIView {
    
    /// UILabel showing the price of gas
    @IBOutlet weak var gasPrice: UILabel!
    /// UILabel showing the address of the station
    @IBOutlet weak var addressLabel: UILabel!
    /// UILabel showing the distance of the station
    @IBOutlet weak var distanceLabel: UILabel!
    /// UILabel showing the time to get to the station
    @IBOutlet weak var timeLabel: UILabel!
    
    /**
    Sets the values for the station
    
    - parameter gasStation: Station whose values to display
    */
    func setValues(gasStation: GasStation){
        MILLoadViewManager.sharedInstance.show()
        LocationUtils.sharedInstance.calcDistanceAndTimeFromUsersLocation(gasStation, callback: { (distance: CLLocationDistance?, time: NSTimeInterval?, success) -> () in
            MILLoadViewManager.sharedInstance.hide()
            if (success) {
                MILAlertViewManager.sharedInstance.hide() //hide alert if shown
                self.gasPrice.text = LocalizationUtils.localizeCurrency(gasStation.gasPrice)
                self.addressLabel.text = gasStation.address
                self.distanceLabel.text = LocalizationUtils.localizeDistance(distance!)
                self.timeLabel.text = String.localizedStringWithFormat(NSLocalizedString("%.0f min", comment: ""), time! / 60)
            } else {
                MILAlertViewManager.sharedInstance.show(NSLocalizedString("Network Error", comment: ""), callback: {self.setValues(gasStation)})
            }
            
        })
    }
    
    /**
    Reset the view
    */
    func reset(){
        gasPrice.text = ""
        addressLabel.text = ""
        distanceLabel.text = ""
        timeLabel.text = ""
    }
    
}