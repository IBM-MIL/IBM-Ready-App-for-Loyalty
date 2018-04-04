/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit


/**
*  General utilities
*/
class Utils: NSObject {
    
    /**
    Builds and returns an array of deals made by combining all the deals in an array of GasStations
    
    - parameter stations: Array of GasStations
    
    - returns: An array of Deals
    */
    class func getAllDealsFromStations(_ stations: [GasStation]) -> [Deal] {
        
        // Collect deals together
        let arrayOfDeals: [[Deal]] = stations.map { return $0.deals }
        
        // Combine all deals arrays
        let allDeals = arrayOfDeals.reduce([]) { return $0 + $1 }
        
        return allDeals
    }
    
    /**
    Helper method to combine all deals associated with our list of gas stations + recommended deals for a user
    
    - parameter user: User object to extract deals from
    
    - returns: An array of all deals available
    */
    class func getAllPossibleDeals(_ user: User) -> [Deal] {
        return Utils.getAllDealsFromStations(user.gasStations) + user.deals
        
    }
    
    /**
    Adds a shadow to any view (used in card-ui)
    
    - parameter view:    The view to shadow
    - parameter offset:  Shadow offset
    - parameter opacity: Shadow opacity
    */
    class func addShadowToView(_ view: UIView, offset: CGSize = CGSize(width: 1, height: 2), opacity: Float = 0.1) {
        view.layer.masksToBounds = false
        view.layer.shadowOffset = offset
        view.layer.shadowRadius = 1.5
        view.layer.shadowOpacity = opacity
    }
    
    /**
    Adds a shadow to multiple
    
    - parameter views:   The views to shadow
    - parameter offset:  Shadow offset
    - parameter opacity: Shadow opacity
    */
    class func addShadowToViews(_ views: [UIView], offset: CGSize = CGSize(width: 1, height: 2), opacity: Float = 0.1) {
        for view in views {
            addShadowToView(view, offset: offset, opacity: opacity)
        }
    }
    
    /**
    Builds a deal cell based on the deal
    
    - parameter cell:      Cell to build
    - parameter deal:      Deal whose values to user
    - parameter showSaved: Whether or not to show the indicator that a deal is saved
    */
    class func setCellBasedOnDeal(_ cell: DealCollectionViewCell, deal: Deal, showSaved: Bool) {
        cell.nameLabel.text = deal.name
        let dateString = deal.expiration.toString(dateStyle: DateFormatter.Style.long, timeStyle: DateFormatter.Style.none, doesRelativeDateFormatting: true)
        cell.expiresOnLabel.text = NSLocalizedString("Expires", comment: "") + " \(dateString)"
        cell.dealImageView.image = UIImage(named: deal.imageName)
        if cell.dimView != nil {
            cell.dimView.isHidden = !deal.saved || !showSaved
        }
        if cell.savedImageView != nil {
            cell.savedImageView.isHidden = !deal.saved || !showSaved
        }
        // Configure the cell
        Utils.addShadowToView(cell)
    }
    
    /**
    Returns the size of a deal cell based on the width of the collectionview so that two deals take up the width of the screen with the correct ratio
    
    - parameter collectionView: The collectionview
    
    - returns: The size
    */
    class func sizeOfCellForCollectionView(_ collectionView: UICollectionView) -> CGSize {
        let collectionWidth = collectionView.width - 40
        let width = collectionWidth/2
        let ratio = CGFloat(25)/CGFloat(28)
        let height = width/ratio
        return CGSize(width: width, height: height)
    }
    
    /**
    Gets a view controller from a stroyboard
    
    - parameter vcName:         Name of the view controller
    - parameter storyboardName: Name of the storyboard
    
    - returns: The view controller
    */
    class func vcWithNameFromStoryboardWithName(_ vcName : String, storyboardName : String) -> UIViewController?{
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let viewController: AnyObject! = storyboard.instantiateViewController(withIdentifier: vcName)
        return viewController as? UIViewController
    }
    
    /**
    Gets the frame of an tab at index in tabbar. Used to get the correct location which can change depending on the screen size.
    
    - parameter tabBar: tabBar
    - parameter index:  index
    
    - returns: frame of tab
    */
    class func frameForTabInTabBar(_ tabBar: UITabBar!, withIndex index: Int) -> CGRect {
        var tabBarItems = [UIView]()
        for view in tabBar.subviews {
            if  view.isKind(of: UIControl.self){
                    tabBarItems.append(view)
            }
        }
        if tabBarItems.isEmpty {
            // no tabBarItems means either no UITabBarButtons were in the subView, or none responded to -frame
            // return CGRectZero to indicate that we couldn't figure out the frame
            return CGRect.zero
        }
        
        // sort by origin.x of the frame because the items are not necessarily in the correct order
        tabBarItems.sort(by: { $0.x < $1.x})
        
        var frame = CGRect.zero
        if index < tabBarItems.count {
            // viewController is in a regular tab
            let tabView = tabBarItems[index]
            frame = tabView.frame
            
        }else {
            // our target viewController is inside the "more" tab
            if let tabView = tabBarItems.last {
                frame = tabView.frame
            }
        }
        return frame
        
    }
    
    /**
    Checks internet connection
    
    - returns: true for connected
    */
    class func checkInternetConnection() -> Bool {
        let reachability = ReachabilityMIL.reachabilityForInternetConnection()
        let networkStatus = reachability?.currentReachabilityStatus().rawValue
        return networkStatus != 0
    }
    
    
    
    /**
    This method returns a deal by seaching all deals for a deal wirth
    
    */
    class func getDealByID(_ dealID : Int) -> Deal? {
        
        let user = UserDataManager.sharedInstance.currentUser
        
        let userDeals = Utils.getAllPossibleDeals(user!)
        
        let filteredDeals : [Deal] = userDeals.filter{
            
            let _id = ($0 as Deal).dealId
            
            if _id == dealID {
                return true
            }
            else{
                return false
            }
        }
        
        if(filteredDeals.count > 0) {
            return filteredDeals.first
        }
        return nil
    }
    
    class func setDealSaved(_ dealID : Int){
        
        let user = UserDataManager.sharedInstance.currentUser
        
        let userDeals = Utils.getAllPossibleDeals(user!)
        
        let filteredDeals : [Deal] = userDeals.filter{
            
            let _id = ($0 as Deal).dealId
            
            if _id == dealID {
                return true
            }
            else{
                return false
            }
        }
        
        if(filteredDeals.count > 0) {
            let deal = filteredDeals.first
            deal!.saved = !deal!.saved
        }
    }
    
}
