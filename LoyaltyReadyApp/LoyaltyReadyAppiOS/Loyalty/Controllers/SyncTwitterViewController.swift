/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

class SyncTwitterViewController: SubSettingsViewController {
    
    
    //Override SubSettingsViewController titleText property
    override var titleText : String {
        set {
            
        }
        get {
            return NSLocalizedString("Sync with Twitter", comment: "n/a")
        }
    }
    
    //Override subSettingsViewController descriptionText property
    override var descriptionText: String {
        set {
            
        }
        get {
            return NSLocalizedString("Allow app to access your Twitter profile in order to create unique deals and promotions that are personalized to your interests.", comment: "n/a")
        }
    }
    
    //Override mainButtonText mainButtonText property
    override var mainButtonText: String {
        set {
            
        }
        get {
            return NSLocalizedString("CONNECT TO TWITTER", comment: "n/a")
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        self.addTwitterLogoToMainButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
    This method overrides the subSettingsViewController mainButtonAction method
    */
    override func mainButtonAction(){
        
        let alertView = UIAlertController(title: NSLocalizedString("Notice", comment: ""), message: NSLocalizedString("Syncing with Twitter not currently supported", comment: ""), preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .Default) { (action) in self.noThanksAction() })
        self.presentViewController(alertView, animated: true, completion: nil)
        
        // Simulate user being synced with Twitter
        let user = UserDataManager.sharedInstance.currentUser
        user.syncedWithTwitter = true

    }
    
    /**
    Method to simply navigate to the next page
    */
    override func noThanksAction() {
        self.editProfileVCReference.navigateToIndex(2, fromIndex: pageIndex, animated: true)
    }
    
    /**
    This method adds the twitter logo to the mainButton and centers the text/image as a unit
    */
    func addTwitterLogoToMainButton(){
        let image = UIImage(named: "twitter")
        
        self.subSettingsView.mainButton.setImage(image, forState: UIControlState.Normal)
        
        let spacing: CGFloat = 5
        self.subSettingsView.mainButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing)
        self.subSettingsView.mainButton.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0)
    }
    

 

}
