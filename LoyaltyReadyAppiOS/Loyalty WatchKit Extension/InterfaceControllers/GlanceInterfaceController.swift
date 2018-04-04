/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import Foundation
import WatchKit

/**
* Controller for the Glance interface
**/
class GlanceInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var glanceRadialAnimationGroup: WKInterfaceGroup!
    @IBOutlet weak var pointLabel: WKInterfaceLabel!
    
    /// Rewards data object to record current status
    var rewardData: Rewards?
    
    /// Determines whether to use local Json or MFP data
    var useServerData: Bool = true
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if rewardData == nil {
            self.pullRewardsData()
        }
    }
    
    /**
    Method to pull rewards data from MFP
    */
    func pullRewardsData() {
        
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
    Callback used to record rewards data
    
    - parameter data: data returned from MFP
    */
    func gotUserData(data: [String : AnyObject]) {
        
        if (data["failure"] == nil) {
        
            let user = User(json: data)
            self.rewardData = user.profile.rewards
            
            self.updateInterfaceUI()
        } else {
            logger.logInfoWithMessages("Failure getting user data")
        }
    }
    
    /**
    Method to update UI once data has come in through MFP call
    */
    func updateInterfaceUI() {
        
        // Configure interface objects here.
        glanceRadialAnimationGroup.setBackgroundImageNamed("gasGraph_")
        
        // Logic to change status message if the user has completed their goal
        if self.rewardData!.progress < 100 {
            let pointText = NSLocalizedString("POINTS", comment: "")
            pointLabel.setText("\(self.rewardData!.points) \(pointText)")
        } else {
            pointLabel.setText(NSLocalizedString("GOAL REACHED", comment: ""))
        }
        
        glanceRadialAnimationGroup.startAnimatingWithImagesInRange(NSMakeRange(0, self.rewardData!.progress), duration: 1, repeatCount: 1)
        
    }
}
