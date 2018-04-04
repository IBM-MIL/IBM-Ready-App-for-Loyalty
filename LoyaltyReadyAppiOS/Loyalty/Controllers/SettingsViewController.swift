/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

class SettingsViewController: LoyaltyUIViewController {
    
    @IBOutlet weak var firstCheckButton: UIButton!
    @IBOutlet weak var secondCheckButton: UIButton!
    @IBOutlet weak var thirdCheckButton: UIButton!
    @IBOutlet weak var fourthCheckButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateCheckIcons()
    }
    
    /**
    Method to update check icons to show a user's status on updating their profile
    */
    func updateCheckIcons() {
        
        if UserDataManager.sharedInstance.currentUser.interests.count > 0 {
            firstCheckButton.setImage(UIImage(named: "check_selected"), for: UIControlState())
        }
        
        if UserDataManager.sharedInstance.currentUser.syncedWithTwitter {
            secondCheckButton.setImage(UIImage(named: "check_selected"), for: UIControlState())
        }
        
        if UIApplication.shared.isRegisteredForRemoteNotifications {
            thirdCheckButton.setImage(UIImage(named: "check_selected"), for: UIControlState())
        }
        
        if CLLocationManager.authorizationStatus().rawValue >= 3 {
            fourthCheckButton.setImage(UIImage(named: "check_selected"), for: UIControlState())
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
    @IBAction func backButtonTapped(_ sender: AnyObject) {
        
        navigationController?.popViewController(animated: true)
    }
    
    
    /**
    This method brings up the edit profile flow to the Interests view controller
    */
    @IBAction func addInterests(_ sender: AnyObject) {
        self.loadEditProfileFlow(0)
    }
    
    
    /**
    This method brings up the edit profile flow to the enableTwitter view controller
    */
    @IBAction func enableTwitter(_ sender: AnyObject) {
        self.loadEditProfileFlow(1)
    }
    
    /**
    This method brings up the edit profile flow to the enable notifications view controller */
    @IBAction func enableNotifications(_ sender: AnyObject) {
        self.loadEditProfileFlow(2)
    }
    
    /**
    This method brings up the edit profile flow to the enableLocation view controller
    */
    @IBAction func enableLocation(_ sender: AnyObject) {
        self.loadEditProfileFlow(3)
    }
    
    
    /**
    This method brings up the edit profile flow from the beginning
    */
    @IBAction func editProfile(_ sender: AnyObject) {
        self.loadEditProfileFlow(0)
    }
    
    /**
    This method shows the user information about Roadrunner's point system
    */
    @IBAction func aboutPoints(_ sender: AnyObject) {
        let aboutPointsVC = Utils.vcWithNameFromStoryboardWithName("AboutPointsViewController", storyboardName: "Settings")
        self.navigationController?.pushViewController(aboutPointsVC!, animated: true)
    }
    
    /**
    This method causes the app to go back to the RewardsViewController and shows the onboarding card
    */
    @IBAction func showTutorial(_ sender: AnyObject) {

        UserDefaults.standard.set(false, forKey: "hasShownOnboarding")
        UserDefaults.standard.synchronize()
        
        navigationController?.popViewController(animated: true)
    }
    
    
    /**
    This method loads the edit profile flow to the index provided in the index parameter
    */
    func loadEditProfileFlow(_ index: Int) {
        
        // Don't allow any edit profile actions if not logged in
        if UserDataManager.sharedInstance.currentUser.loggedIn {
            
            if let editProfileVC = Utils.vcWithNameFromStoryboardWithName("EditProfileViewController", storyboardName: "Settings") as? EditProfileViewController {
                editProfileVC.startingIndex = index
                self.present(editProfileVC, animated: true, completion: nil)
            }
            
        } else {
            
            if let viewController = Utils.vcWithNameFromStoryboardWithName("LoginNavController", storyboardName: "Login") as? LoginNavController {
                present(viewController, animated: true, completion: nil)
            }
        }
    }
    
}
