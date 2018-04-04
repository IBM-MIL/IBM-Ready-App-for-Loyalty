/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import WatchKit
import Foundation

/**
* Controller for radial graph interface
**/
class RewardsInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var radialAnimationGroup: WKInterfaceGroup!
    @IBOutlet weak var gasAnimation: WKInterfaceImage!
    @IBOutlet weak var dollarLabel: WKInterfaceLabel!
    @IBOutlet weak var amountLeftLabel: WKInterfaceLabel!
    @IBOutlet weak var rewardLabel: WKInterfaceLabel!
    
    /// Rewards data object to record current status
    var rewardData: Rewards?
    
    /// Users goal, currently hardcoded
    var goal = 36.64
    
    /// Integer to track how many times controller has been activated, should be visibile on second time
    var activateCount = 0

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // load data from context
        if let user = context as? User {
            self.rewardData = user.profile.rewards
        }
    }

    override func willActivate() {
        super.willActivate()
        
        let model = UIDevice.currentDevice().model
        if model == "iPhone Simulator" {
            if activateCount < 1 {
                self.updateInterfaceUI()
                activateCount++
            }
        } else {
        
            // This logic is used to load animation for the first time once the user has this controller in view
            // On a device, this gets called once without being in view so on the second time, we update the UI
            // A special case is when you open the app from a notification, this view loads correctly, meaning only when user swipes to it.
            if activateCount < 1 && WatchDataManager.sharedInstance.openedWithNotification {
                self.updateInterfaceUI()
                activateCount = 2 // prevents future updates
            } else if activateCount == 1 {
                self.updateInterfaceUI()
                activateCount++
            } else {
                activateCount++
            }
        }

       
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    /**
    Method to update UI once data has come in through MFP call
    */
    func updateInterfaceUI() {
        
        if self.rewardData != nil {
            // Configure interface objects here.
            gasAnimation.setImageNamed("gas graph_")
            
            dollarLabel.setText("\(self.rewardData!.points)")
            amountLeftLabel.setText("\(Int(25))")
            gasAnimation.startAnimatingWithImagesInRange(NSMakeRange(0, self.rewardData!.progress), duration: 1, repeatCount: 1)
        }
        
    }
}
