/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import WatchKit
import Foundation

/**
* Controller for the table of deals, which is also the entry point for the watch app
**/
class DealListInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var dealTable: WKInterfaceTable!
    @IBOutlet weak var errorLabel: WKInterfaceLabel!
    
    /// Array of deals used to populate table
    var deals = [Deal]()
    
    /// Determines whether to use local Json or MFP data
    var useServerData: Bool = true
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

        // Load data after controller reload
        if let user = context as? User {
            self.deals = user.deals
            self.reloadTable()
        } else {
            self.pullDealData()
        }
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        // Perform Handoff: make product available on iPhone
        self.updateUserActivity(WatchKitDealListType, userInfo: [ : ], webpageURL:nil)
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()

        self.invalidateUserActivity()
    }
    
    /**
    Method to pull deal data from MFP
    */
    func pullDealData() {
        
        if useServerData {
        
            // MFP Resource Request to get User data from JSON
            let userManager = UserDataManager.sharedInstance
            userManager.getUserData("5128675309", callback: gotUserData)
        } else {
        
            //load user data from json for testing
            let path = NSBundle.mainBundle().pathForResource("data", ofType: "json")
            let jsonData = NSData(contentsOfFile: path!)
            let jsonResult = (try! NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers)) as! [String:AnyObject]
            self.gotUserData(jsonResult)
        }
    }
    
    /**
    Callback used to record deals data
    
    - parameter data: data returned from MFP
    */
    func gotUserData(data: [String : AnyObject]) {
        
        if (data["failure"] == nil) {
            
            let user = User(json: data)
            
            // NOTE: This call is important because it essentially allows us to pass contexts to other page views with the contexts array
            // Thus, we only need to do one data call to the backend
            WKInterfaceController.reloadRootControllersWithNames(["firstController", "secondController"], contexts:[user, user])
            
        } else {
            MQALogger.log("Failure with data: \(data)")
            self.errorLabel.setHidden(false)
        }
        
    }
    
    /**
    Reloads table with data from MFP
    */
    func reloadTable() {
        dealTable.setNumberOfRows(self.deals.count, withRowType: "DealRow")
        
        for (index, deal) in self.deals.enumerate() {

            if let row = self.dealTable.rowControllerAtIndex(index) as? DealRow {
                row.titleLabel.setText(deal.name)
                let formattedDate = deal.expiration.toString(dateStyle: .ShortStyle , timeStyle: .NoStyle, doesRelativeDateFormatting: true)
                row.expirationLabel.setText("Exp: \(formattedDate)")
                row.dealImg.setImageNamed(deal.watchImage)
            }
            
        }
        
        // Once table is loaded, load deal details if necessary
        if let notificationTuple = WatchDataManager.sharedInstance.notificationObjects {
            self.handleDealPresentation(notificationTuple.0, theDeal: notificationTuple.1)
            WatchDataManager.sharedInstance.notificationObjects = nil
            WatchDataManager.sharedInstance.openedWithNotification = true
        }
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        if segueIdentifier == "DealDetails" {
            let contextObject = Context(data: self.deals[rowIndex])
            return contextObject
        }

        return nil
    }
    
    override func handleActionWithIdentifier(identifier: String?, forRemoteNotification remoteNotification: [NSObject : AnyObject]) {

        if identifier == "detailsButtonAction" || identifier == "goalReachedButtonAction" {
            
            var json: [String:AnyObject]!
            
            // Parse json from notification
            
            let dealString = remoteNotification["deal"] as? String
            if let _ = dealString {
                
                let jsonData = dealString!.dataUsingEncoding(NSUTF8StringEncoding)
                json = (try! NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers)) as! [String:AnyObject]
            } else if let _ = remoteNotification["name"] as? String { // Verify json is flat, not nested
               
                // This code gets called when using flat Json
                json = remoteNotification as? [String:AnyObject]
                
            } else {
                // Hits this code when using simulator test json
                if let tempJson = remoteNotification["deal"] as? [String: AnyObject] {
                    json = tempJson
                }
            }
            
            // Create Deal object from json and present details screen
            let deal = Deal(notificationJson: json)
            
            // save data in case controller resets with reloadRootControllersWithNames
            WatchDataManager.sharedInstance.notificationObjects = (identifier!, deal)
            
            // Only load notification here if app has been loaded already
            if self.deals.count > 0 {
                // Present deal details
                self.handleDealPresentation(identifier!, theDeal: deal)
            }

        } else {
            return
        }
    }
    
    /**
    Convenience method to present details view from different notification categories
    
    - parameter id:      action identifier
    - parameter theDeal: the data from the notification
    */
    func handleDealPresentation(id: String, theDeal: Deal) {
        
        let contextObject = Context(data: theDeal)
        contextObject.fromNotification = true
        
        if id == "detailsButtonAction" {
            presentControllerWithName("DealDetails", context: contextObject)
        } else {
            contextObject.isGoalReached = true
            presentControllerWithName("DealDetails", context: contextObject)
        }
        
    }
    
}
