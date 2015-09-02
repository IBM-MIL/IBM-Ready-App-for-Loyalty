/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var firstCheckButton: UIButton!
    @IBOutlet weak var secondCheckButton: UIButton!
    @IBOutlet weak var thirdCheckButton: UIButton!
    @IBOutlet weak var fourthCheckButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.updateCheckIcons()
    }
    
    /**
    Method to update check icons to show a user's status on updating their profile
    */
    func updateCheckIcons() {
        
        if UserDataManager.sharedInstance.currentUser.interests.count > 0 {
            firstCheckButton.setImage(UIImage(named: "check_selected"), forState: UIControlState.Normal)
        }
        
        if UserDataManager.sharedInstance.currentUser.syncedWithTwitter {
            secondCheckButton.setImage(UIImage(named: "check_selected"), forState: UIControlState.Normal)
        }
        
        if UIApplication.sharedApplication().isRegisteredForRemoteNotifications() {
            thirdCheckButton.setImage(UIImage(named: "check_selected"), forState: UIControlState.Normal)
        }
        
        if CLLocationManager.authorizationStatus().rawValue >= 3 {
            fourthCheckButton.setImage(UIImage(named: "check_selected"), forState: UIControlState.Normal)
        }
        
    }
    
    /**
    This method hides the navigation bar
    */
    func setNavigationUI(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    /**
    This method defines the action that is taken when the back button is pressed. In this case it brings the app back to the rewards view controller
    */
    @IBAction func backButtonTapped(sender: AnyObject) {
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    /**
    This method brings up the edit profile flow to the Interests view controller
    */
    @IBAction func addInterests(sender: AnyObject) {
        self.loadEditProfileFlow(0)
    }
    
    
    /**
    This method brings up the edit profile flow to the enableTwitter view controller
    */
    @IBAction func enableTwitter(sender: AnyObject) {
        self.loadEditProfileFlow(1)
    }
    
    /**
    This method brings up the edit profile flow to the enable notifications view controller */
    @IBAction func enableNotifications(sender: AnyObject) {
        self.loadEditProfileFlow(2)
    }
    
    /**
    This method brings up the edit profile flow to the enableLocation view controller
    */
    @IBAction func enableLocation(sender: AnyObject) {
        self.loadEditProfileFlow(3)
    }
    
    
    /**
    This method brings up the edit profile flow from the beginning
    */
    @IBAction func editProfile(sender: AnyObject) {
        self.loadEditProfileFlow(0)
    }
    
    /**
    This method shows the user information about Roadrunner's point system
    */
    @IBAction func aboutPoints(sender: AnyObject) {
        let aboutPointsVC = Utils.vcWithNameFromStoryboardWithName("AboutPointsViewController", storyboardName: "Settings")
        self.navigationController?.pushViewController(aboutPointsVC!, animated: true)
    }
    
    /**
    This method causes the app to go back to the RewardsViewController and shows the onboarding card
    */
    @IBAction func showTutorial(sender: AnyObject) {

        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "hasShownOnboarding")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    /**
    This method loads the edit profile flow to the index provided in the index parameter
    */
    func loadEditProfileFlow(index: Int) {
        
        // Don't allow any edit profile actions if not logged in
        if UserDataManager.sharedInstance.currentUser.loggedIn {
            
            if let editProfileVC = Utils.vcWithNameFromStoryboardWithName("EditProfileViewController", storyboardName: "Settings") as? EditProfileViewController {
                editProfileVC.startingIndex = index
                self.presentViewController(editProfileVC, animated: true, completion: nil)
            }
            
        } else {
            
            if let viewController = Utils.vcWithNameFromStoryboardWithName("LoginNavController", storyboardName: "Login") as? LoginNavController {
                presentViewController(viewController, animated: true, completion: nil)
            }
        }
    }
    
}
