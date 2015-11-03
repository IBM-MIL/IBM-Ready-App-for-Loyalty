/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/*
*  Shows the Rewards that are associated with the user
*/
class RewardsViewController: LoyaltyUIViewController {

    /// Navigation bar for rewards
    var navigationBar : UINavigationBar?
    /// Button to open settings view
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var settingsButtonTrailingSpace: NSLayoutConstraint!
    
    @IBOutlet weak var spedometerButton: UIButton!
    /// Boolean of whether to allow user to tap cheapest and closest stations to transition to stations tab
    var allowTransition: Bool = false
    /// Button for opening add to passbook modal
    @IBOutlet weak var passbookButton: UIButton!
    /// View for the navigation bar of the rewards page
    @IBOutlet weak var rewardsNavBarView: UIView!
    /// UICollectionView of saved deals
    @IBOutlet weak var savedDealsCollectionView: UICollectionView!
    /// Array of deals shown in the UICollectionView
    var deals = [Deal]()
    /// The currentUser
    var user : User!
    /// Boolean if user has received user data. true = has received data
    var gotUserData: Bool = false
    var closestStation: GasStation!
    var cheapestStation: GasStation!
    var toolTipView : MILNavBarToolTip!
    var tapCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.showOnboarding()
        savedDealsCollectionView.accessibilityLabel = NSLocalizedString("SAVED DEALS", comment: "")
        self.user = UserDataManager.sharedInstance.currentUser
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showOnboarding()
        checkInternetConnection()
        retryRequest()
        setNavigationUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.checkIfShouldHideToolTip()
    }
    
    /**
    Method to check if user has internet connection
    */
    func checkInternetConnection(){
        if !Utils.checkInternetConnection() { //no internet, so disable create account button
            MILLoadViewManager.sharedInstance.hide()
            MILAlertViewManager.sharedInstance.show(NSLocalizedString("Network Error", comment: ""), view: self.view, underView: self.rewardsNavBarView, callback: checkInternetConnection)
            self.allowTransition = false
        } else {
            MILAlertViewManager.sharedInstance.hide() //hide alert if shown
//            if (self.navigationBar != nil){
//                self.setUpAndShowToolTip()
//            }
            self.allowTransition = true
        }
    }
    
    /**
    Method to retry MFP Resource request
    */
    func retryRequest() {
        if !UserDataManager.sharedInstance.currentUser.loggedIn {
            self.passbookButton.userInteractionEnabled = false
            self.passbookButton.hidden = true
            MILLoadViewManager.sharedInstance.show()
            UserDataManager.sharedInstance.getAnonUserData(gotUserData)
        } else {
            self.passbookButton.userInteractionEnabled = true
            self.passbookButton.hidden = false
            self.gotUserData = true
            self.user = UserDataManager.sharedInstance.currentUser
            self.deals = [Deal]()
            
            let tempDeals = Utils.getAllPossibleDeals(self.user)
            for deal in tempDeals {
                if deal.saved {
                    self.deals.append(deal)
                }
            }
            savedDealsCollectionView.reloadData()
        }
        
        
    }
    
    /**
    Callback method called when the UserDataManager returns a result
    
    - parameter data: data returned from UserDataManager
    */
    func gotUserData(data: [String : AnyObject]) {
        
        if let failString = data["failure"] as? String { //failure of some kind
            
            MILLoadViewManager.sharedInstance.hide()
            self.allowTransition = false
            
            if (failString == "no connection") { //failure -- no connection
                
                MQALogger.log("FAILURE NO CONNECTION - \(data)")
                MILAlertViewManager.sharedInstance.show(NSLocalizedString("Network Error", comment: ""), view: self.view, underView: self.rewardsNavBarView, callback: retryRequest)
            } else if (failString == "unknown user") { //failure -- unknown user
                
                MQALogger.log("FAILURE UNKNOWN USER - \(data)")
                MILAlertViewManager.sharedInstance.show(NSLocalizedString("Network Error", comment: ""), view: self.view, underView: self.rewardsNavBarView, callback: retryRequest)
            }
        } else { //success! (no failure string)
            
            self.allowTransition = true
            MILAlertViewManager.sharedInstance.hide() //hide alert if shown
            MQALogger.log("Anon User Data Received: \(data)")
            MILAlertViewManager.sharedInstance.hide() //hide alert if shown
            
            /* Register Custom Notifications after initial worklight call
               Must happen in this sequence or notification actions won't appear. */
            if self.user.deals.count <= 0 {
                let appDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
                appDelegate.registerSettingsAndCategories()
            }
            
            self.user = User(json: data)
            UserDataManager.sharedInstance.currentUser = self.user
            
            /* Filter out unsaved deals */
            deals = [Deal]()
            let tempDeals = Utils.getAllPossibleDeals(user)
            for deal in tempDeals {
                if deal.saved {
                    deals.append(deal)
                }
            }
            
            self.gotUserData = true
            savedDealsCollectionView.reloadData()
            
            if (self.navigationBar != nil){
                self.setUpAndShowToolTip()
            }

        }
    }
    
    
    /**
    This method sets up the tool tip on the top of the page and sets the rewards view controller as a delegate of OnBoarding
    */
    func setUpAndShowToolTip(){
        
        if !NSUserDefaults.standardUserDefaults().boolForKey("hasShownToolTip") {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasShownToolTip")
            NSUserDefaults.standardUserDefaults().synchronize()

            self.toolTipView = MILNavBarToolTip(frame: CGRectMake(0,self.navigationBar!.frame.size.height, UIScreen.mainScreen().bounds.width, 50))
            let toolTipText = NSLocalizedString("Complete your profile to earn 20 points towards your next reward!", comment: "n/a")
            toolTipView.setUp(toolTipText, navBarButtonFrameCenter: calcSettingsButtonCenter())
            self.view.addSubview(self.toolTipView)
            self.toolTipView.showWithTimeDelay(0.3)
            
            self.toolTipView.actionButton.addTarget(self, action: "toolTipAction", forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
    
    
    /**
    This method defines the action that is taken when the tool tip is touched
    */
    func toolTipAction(){
        self.performSegueWithIdentifier("settings", sender: self)
    }
    
    /**
    Method that displays onboarding flow if this is the first launch of the app
    */
    func showOnboarding() {
        
        if !NSUserDefaults.standardUserDefaults().boolForKey("hasShownOnboarding") {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasShownOnboarding")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            if let tabBar = self.tabBarController {
                let vc = Utils.vcWithNameFromStoryboardWithName("OnboardingViewController", storyboardName: "Onboarding") as? OnboardingViewController
                vc?.delegates.append(self)
                vc?.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
                vc?.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                tabBar.presentViewController(vc!, animated: true, completion: nil)
            }
        }
        
    }
    
    /**
    Method to get closest gas station
    */
    func getClosestStation(header: RewardsCollectionReusableView){
        SearchManager.getClosestGasStation(user.gasStations, callback: { (station: GasStation?) -> () in
            MILLoadViewManager.sharedInstance.hide()
            if (station != nil) {
                MILAlertViewManager.sharedInstance.hide() //hide alert if shown
                header.closestStationView.setValues(station!)
                self.closestStation = station
                self.cheapestStation = SearchManager.getCheapestGasStation(self.user.gasStations)
                header.cheapestStationView.setValues(self.cheapestStation)
            } else {
                //self.view.insertSubview(MILAlertViewManager.sharedInstance.milAlertView, belowSubview: self.rewardsNavBarView)
                //MILAlertViewManager.sharedInstance.show(NSLocalizedString("Network Error", comment: ""), overView: self.rewardsNavBarView, callback: {self.savedDealsCollectionView.reloadData()})
                MILAlertViewManager.sharedInstance.show(NSLocalizedString("Network Error", comment: ""), view: self.view, underView: self.rewardsNavBarView, callback: {self.getClosestStation(header)})
                
            }
            
        })
    }
    
    /**
    Makes sure the nav bar is hidden
    */
    func setNavigationUI(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationBar = self.navigationController?.navigationBar
        self.navigationBar?.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationBar?.shadowImage = UIImage()
    }
    
    
    /**
    This method calculates the settings button center used to correctly center the arrow of the tooltip
    */
    func calcSettingsButtonCenter() -> CGFloat {
        
        let rightEdge = UIScreen.mainScreen().bounds.width - self.settingsButtonTrailingSpace.constant
        let halfWidth = self.settingsButton.frame.size.width/2
        let center = rightEdge - halfWidth
        return center + 0.5
    }
    
    @IBAction func closestStationButtonTapped(sender: AnyObject) {
        if (self.allowTransition) {
            if let tabBarController = self.tabBarController as? CustomTabBarController {
                tabBarController.goToStationTabWithStation(closestStation)
            }
        }
    }
    
    @IBAction func cheapestStationButtonTapped(sender: AnyObject) {
        if (self.allowTransition) {
            if let tabBarController = self.tabBarController as? CustomTabBarController {
                tabBarController.goToStationTabWithStation(cheapestStation)
            }
        }
    }
    
    
    func checkIfShouldHideToolTip(){
        if(self.toolTipView != nil && self.toolTipView.isShown == true){
            self.toolTipView.hide()
        }
    }
    
    
    @IBAction func tappedSpedometer(sender: AnyObject) {
        tapCount++
        if (tapCount == 10) {
            spedometerButton.setImage(UIImage(named: "gas_alternate"), forState: UIControlState.Normal)
            tapCount = 0
        } else {
            spedometerButton.setImage(UIImage(named: "logo"), forState: UIControlState.Normal)
        }
    }
    
}

extension RewardsViewController: UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! DealCollectionViewCell
        let deal = deals[indexPath.row]
        Utils.setCellBasedOnDeal(cell, deal: deal, showSaved: false)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deals.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath) as! RewardsCollectionReusableView
        
        Utils.addShadowToViews([header.closestStationView, header.cheapestStationView])
        if user.loggedIn{
            header.fuelGageTeal.rotate(CGFloat(user.profile.rewards.progress), duration: 1.5)
            header.pointsLabel.text = "\(user.profile.rewards.progress)" + NSLocalizedString(" points", comment: "")
        }else{
            header.pointsLabel.text = NSLocalizedString("0 points", comment: "")
        }
        
        let progressMessage: String!
        if !user.loggedIn{
            progressMessage = NSLocalizedString("Create an account to\nstart saving today!", comment: "")
        }else if user.profile.rewards.progress == 100 {
            progressMessage = NSLocalizedString("You’ve reached\nyour goal!", comment: "")
        }else{
            progressMessage = "\(100 - user.profile.rewards.progress)" + NSLocalizedString(" points left until\n10% off next fill-up", comment: "")
        }
        
        header.progressLabel.text = progressMessage
        header.cheapestStationView.reset()
        header.closestStationView.reset()
        
        if (self.gotUserData) {
            MILLoadViewManager.sharedInstance.show()
            self.getClosestStation(header)
        }

        return header
    }
}

/** 

MARK: UICollectionViewDelegate

*/
extension RewardsViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let dealsDetailViewController = Utils.vcWithNameFromStoryboardWithName("DealsDetailViewController", storyboardName: "Deals") as? DealsDetailViewController {
            dealsDetailViewController.deal = deals[indexPath.row]
            navigationController?.pushViewController(dealsDetailViewController, animated: true)
        }
    }
}

extension RewardsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        let collectionWidth = collectionView.width
        return CGSizeMake(collectionWidth, 400)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return Utils.sizeOfCellForCollectionView(collectionView)
    }
}

extension RewardsViewController: OnboardingViewControllerDelegate {
    
    /**
    This method is called when the OnBoardingViewController disappears
    */
    func OnboardingDidDisappear() {
        if (MILAlertViewManager.sharedInstance.milAlertView == nil) {
            self.setUpAndShowToolTip()
        }
    }

}