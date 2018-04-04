/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit
import CoreLocation

class EnableLocationViewController: SubSettingsViewController {
    
    
    /// Override subSettingsViewController's titleText property
    override var titleText : String {
        set {
            
        }
        get {
           return NSLocalizedString("Enable Location", comment: "n/a")
        }
    }
    
    
    /// Override subSettingsViewController's descriptionText property
    override var descriptionText: String {
        set {
           
        }
        get {
            return NSLocalizedString("We will use your location to show you gas stations and deals near you.", comment: "n/a")
        }
    }
    
    /// Override subSettingsViewController's mainButtonText property
    override var mainButtonText: String {
        set {
           
        }
        get {
            return NSLocalizedString("ENABLE LOCATION", comment: "n/a")
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
    In this method, we detect if location services are enabled, if not, direct to settings
    */
   override func mainButtonAction() {

    let locationAuthStatus = CLLocationManager.authorizationStatus() as CLAuthorizationStatus
        if locationAuthStatus.rawValue == 0 || locationAuthStatus.rawValue == 2 {
        
            let alertController = UIAlertController(title: NSLocalizedString("Notice", comment: ""), message: NSLocalizedString("You must enable Location Services in the Settings app.", comment: ""), preferredStyle: .alert)
            let detailAction = UIAlertAction(title: NSLocalizedString("Launch Settings", comment: ""), style: .default) { (action) in
                 UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
            }
            let laterAction = UIAlertAction(title: NSLocalizedString("Later", comment: ""), style: .default) { (action) in self.noThanksAction() }
            alertController.addAction(detailAction)
            alertController.addAction(laterAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: NSLocalizedString("Notice", comment: ""), message: NSLocalizedString("You have already enabled Location Services for Roadrunner.", comment: ""), preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: NSLocalizedString("Sounds Good!", comment: ""), style: .default) { (action) in self.noThanksAction() }
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    /**
    Method to simply navigate to the next page
    */
    override func noThanksAction() {
        self.dismiss(animated: true, completion: nil)
    }

}
