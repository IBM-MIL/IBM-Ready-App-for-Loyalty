/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/**
*  Shows the Deals that are recommended and near the user
*/
class DealsViewController: LoyaltyUIViewController {
    
    /// Navigation bar view below recommended and near me buttons
    @IBOutlet weak var navView: UIView!
    /// UIButton to create a new account
    @IBOutlet weak var createAccountButton: UIButton!
    /// UIButton to changed the list of deals to Near Me
    @IBOutlet weak var nearMeButton: UIButton!
    /// UIButton to changed the list of deals to Recommended
    @IBOutlet weak var recommendedButton: UIButton!
    /// UIView beneath the top buttons indicating which is selected
    @IBOutlet weak var indicatorViewOne: UIView!
    /// UICollectionView of deals
    @IBOutlet weak var dealsCollectionView: UICollectionView!
    /// Shown when a user is not logged in
    @IBOutlet weak var createAccountView: UIView!
    /// Constant used to animate the movement of the indicator view
    @IBOutlet weak var indicatorViewLeadingContraint: NSLayoutConstraint!
    /// Array of deals shown in the UICollectionView
    var deals = [Deal]()
    /// The currentUser
    var user : User!
    /// The nearest gas station
    var nearestStation: GasStation!
    /// Bool to tell if the view is showing nearest or recommened
    var showingNearest: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dealsCollectionView.accessibilityLabel = NSLocalizedString("offers", comment: "")
        dealsCollectionView.accessibilityIdentifier = NSLocalizedString("offersId", comment: "")
        
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar?.shadowImage = UIImage()
        
        // Show nearest if initally not logged in
        showingNearest = !UserDataManager.sharedInstance.currentUser.loggedIn
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Update local user object
        user = UserDataManager.sharedInstance.currentUser
        self.reloadCollectionView()
        checkInternetConnection()
        MILLoadViewManager.sharedInstance.show()
        getClosestStation()
    }
    
    /**
    Method to check if user has internet connection
    */
    func checkInternetConnection(){
        if !Utils.checkInternetConnection(){ //no internet, so disable create account button
            MILLoadViewManager.sharedInstance.hide()
            createAccountButton.isUserInteractionEnabled = false
            createAccountButton.setBackgroundColorForState(UIColor.grayLoyalty(), forState: UIControlState())
            MILAlertViewManager.sharedInstance.show(NSLocalizedString("Network Error", comment: ""), view: self.view, underView: self.nearMeButton, callback: checkInternetConnection)
        } else {
            MILAlertViewManager.sharedInstance.hide() //hide alert if shown
            createAccountButton.isUserInteractionEnabled = true
            createAccountButton.setBackgroundColorForState(UIColor.purpleLoyalty(), forState: UIControlState())
        }
    }
    
    /**
    Method to get closest gas station
    */
    func getClosestStation(){
        MILLoadViewManager.sharedInstance.show()
        SearchManager.getClosestGasStation(user.gasStations, callback: { (station: GasStation?) -> () in
            MILLoadViewManager.sharedInstance.hide()
            if (station != nil) {
                MILAlertViewManager.sharedInstance.hide() //hide alert if shown
                self.nearestStation = station
                self.reloadCollectionView()
            } else {
                MILLoadViewManager.sharedInstance.hide()
                MILAlertViewManager.sharedInstance.show(NSLocalizedString("Network Error", comment: ""), view: self.view, underView: self.nearMeButton, callback: self.getClosestStation)
            }
            
        })
    }
    /**
    Handles action of either Recommended or Near Me buttons being tapped
    
    - parameter sender: UIButton tapped
    */
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        sender.isSelected = true
        checkInternetConnection() //make sure user has internet when changing states
        if sender.tag == 0{
            nearMeButton.isSelected = false
            showingNearest = false
        }else{
            recommendedButton.isSelected = false
            showingNearest = true
        }
        
        reloadCollectionView()
    }
    
    /**
    Reloads the collection view based on the state of the showingNearest bool
    */
    func reloadCollectionView() {
        
        if !showingNearest {
            nearMeButton.isSelected = false
            recommendedButton.isSelected = true
            if !user.loggedIn {
                view.insertSubview(createAccountView, aboveSubview: dealsCollectionView)
            }else{
                deals = user.deals
                dealsCollectionView.reloadData()
                view.insertSubview(dealsCollectionView, aboveSubview: createAccountView)
            }
        }else{
            nearMeButton.isSelected = true
            recommendedButton.isSelected = false
            if nearestStation != nil {
                deals = nearestStation.deals
                
                dealsCollectionView.reloadData()
            }
            self.view.sendSubview(toBack: createAccountView)
        }
        
        if self.recommendedButton.isSelected {
            self.indicatorViewLeadingContraint.constant = 0
        }else{
            self.indicatorViewLeadingContraint.constant = self.view.width/2
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.indicatorViewOne.layoutIfNeeded()
            }, completion: nil)
        
    }
    
    
}

extension DealsViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DealCollectionViewCell
        let deal = deals[indexPath.row]
        Utils.setCellBasedOnDeal(cell, deal: deal, showSaved: true)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deals.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension DealsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let dealsDetailViewController = Utils.vcWithNameFromStoryboardWithName("DealsDetailViewController", storyboardName: "Deals") as? DealsDetailViewController {
            dealsDetailViewController.deal = deals[indexPath.row]
            navigationController?.pushViewController(dealsDetailViewController, animated: true)
        }
    }
}

extension DealsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Utils.sizeOfCellForCollectionView(collectionView)
    }
}
