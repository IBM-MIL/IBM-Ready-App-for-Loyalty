/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

class EnableNotificationsViewController: SubSettingsViewController {

    
    /// Override subSettingsViewController's titleText property
    override var titleText : String {
        set {
            
        }
        get {
            return NSLocalizedString("Enable Notifications", comment: "n/a")
        }
    }
    
    /// Overrride subSettingsViewController's descriptionText property
    override var descriptionText: String {
        set {
            
        }
        get {
            return NSLocalizedString("Now that you've added your interests and enabled Twitter, let us send you personalized notifications about sales!", comment: "n/a")
        }
    }
    
    /// Override subSettingsViewController's mainButtonText property
    override var mainButtonText: String {
        set {
            
        }
        get {
            return NSLocalizedString("SEND ME DEALS!", comment: "n/a")
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    
    /**
    In this method, we check to see if the device is registered for notifications already, if not, direct to settings
    */
    override func mainButtonAction(){

        if !UIApplication.shared.isRegisteredForRemoteNotifications {
        
            let alertController = UIAlertController(title: NSLocalizedString("Notice", comment: ""), message: NSLocalizedString("You must enable Notifications in the Settings app.", comment: ""), preferredStyle: .alert)
            let detailAction = UIAlertAction(title: NSLocalizedString("Launch Settings", comment: ""), style: .default) { (action) in
                UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
            }
            let laterAction = UIAlertAction(title: NSLocalizedString("Later", comment: ""), style: .default) { (action) in self.noThanksAction() }
            alertController.addAction(detailAction)
            alertController.addAction(laterAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: NSLocalizedString("Notice", comment: ""), message: NSLocalizedString("You have already enabled Notifications for Roadrunner.", comment: ""), preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: NSLocalizedString("Sounds Good!", comment: ""), style: .default) { (action) in self.noThanksAction() }
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    /**
    Method to simply navigate to the next page
    */
    override func noThanksAction() {
        self.editProfileVCReference.navigateToIndex(3, fromIndex: pageIndex, animated: true)
    }

}
