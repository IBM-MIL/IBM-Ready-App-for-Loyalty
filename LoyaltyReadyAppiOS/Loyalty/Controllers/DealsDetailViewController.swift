/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/// UIViewController used to view the details of a deal
class DealsDetailViewController: UIViewController {
    
    @IBOutlet weak var finePrintLabel: UILabel!
    @IBOutlet weak var highlightLabel: UILabel!
    @IBOutlet weak var expirationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dealImageView: UIImageView!
    @IBOutlet weak var addDealButton: UIButton!
    @IBOutlet weak var addDealButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addDealBackgroundView: UIView!
    @IBOutlet weak var navView: UIView!
    var deal: Deal!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.addShadowToView(addDealBackgroundView)
        
        if deal != nil {
            dealImageView.image = UIImage(named: deal.imageName)
            nameLabel.text = deal.name
            highlightLabel.text = deal.highlight
            finePrintLabel.text = deal.finePrint
            let dateString = deal.expiration.toString(dateStyle: NSDateFormatterStyle.LongStyle, timeStyle: NSDateFormatterStyle.NoStyle, doesRelativeDateFormatting: true)
            expirationLabel.text = NSLocalizedString("Expires", comment: "") + " \(dateString)"
            addDealButton.selected = deal.saved
        }
    }
    
    /**
    Used to navigate to the previous view controller
    
    - parameter sender: Back button
    */
    @IBAction func backButtonTapped(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationUI()
        
        //        if let deal = Utils.getDealByID(self.deal.dealId){
        //            self.deal = deal
        //        }
        // self.checkIfNeedToRefreshDealAfterLogin()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkInternetConnection()
    }
    
    /**
    Method to check if user has internet connection
    */
    func checkInternetConnection(){
        if !Utils.checkInternetConnection(){
            self.addDealButton.userInteractionEnabled = false //disable add deal button if no connection
            MILAlertViewManager.sharedInstance.show(NSLocalizedString("Network Error", comment: ""), view: view, underView: self.navView, toHeight: 64, callback: checkInternetConnection)
        } else {
            self.addDealButton.userInteractionEnabled = true
            MILAlertViewManager.sharedInstance.hide() //hide alert if shown
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabBarController = self.tabBarController as? CustomTabBarController {
            tabBarController.hideToolTipForSavedDeal()
        }
    }
    /**
    Insures the navigation is hidden
    */
    func setNavigationUI(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    /**
    Used to add a deal the list of saved deals or un-add if already added
    
    - parameter sender: Add button
    */
    @IBAction func addDealButtonTapped(sender: AnyObject) {
        
        if UserDataManager.sharedInstance.currentUser.loggedIn {
            
            Utils.setDealSaved(self.deal.dealId)
            let constant = self.addDealButtonHeightConstraint.constant
            
            self.addDealButtonHeightConstraint.constant = 0
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: -1, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.addDealButton.layoutIfNeeded()
                }, completion: { (finished: Bool) -> Void in
                    
                    self.addDealButton.selected = !self.addDealButton.selected
                    self.addDealButtonHeightConstraint.constant = constant
                    UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.25, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                        self.addDealButton.layoutIfNeeded()
                        }, completion: {(finished: Bool) -> Void in
                            if self.deal.saved {
                                
                                if let tabBarController = self.tabBarController as? CustomTabBarController {
                                    tabBarController.showToolTipForSavedDeal()
                                }
                            }else{
                                if let tabBarController = self.tabBarController as? CustomTabBarController {
                                    tabBarController.hideToolTipForSavedDeal()
                                }
                            }
                    })
            })
            
        }else{
            if let viewController = Utils.vcWithNameFromStoryboardWithName("LoginNavController", storyboardName: "Login") as? LoginNavController {
                presentViewController(viewController, animated: true, completion: nil)
                
            }
        }
        
    }
    
}
