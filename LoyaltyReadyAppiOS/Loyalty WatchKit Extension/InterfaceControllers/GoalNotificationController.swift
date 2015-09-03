/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import WatchKit
import Foundation

/**
* Controller for remote, long-look notifications of goal reached deals
*/
class GoalNotificationController: WKUserNotificationInterfaceController {

    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var detailLabel: WKInterfaceLabel!
    
    override init() {
        // Initialize variables here.
        super.init()
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    /*
    override func didReceiveLocalNotification(localNotification: UILocalNotification, withCompletion completionHandler: ((WKUserNotificationInterfaceType) -> Void)) {
        // This method is called when a local notification needs to be presented.
        // Implement it if you use a dynamic notification interface.
        // Populate your dynamic notification interface as quickly as possible.
        //
        // After populating your dynamic notification interface call the completion block.
        completionHandler(.Custom)
    }
    */
    
    override func didReceiveRemoteNotification(remoteNotification: [NSObject : AnyObject], withCompletion completionHandler: ((WKUserNotificationInterfaceType) -> Void)) {
        
        /* Xtify Deal Instructions */
        
        // For deal notifications, in the Xtify console:
        // Set Simple Notification Message the same as your deal name
        // Set Action Category to: goalCategory
        // In JSON Payload, include json in the following format:
        /*
        
        {
            "title": "Deal Reward",
            "deal": {
                "name": "Free ice cream sandwich",
                "im": "iceCream",
                "exp": 14,
                "hl": "Free ice cream sandwich next time you go to your local gas station"
            }
        }
        */

        if let jsonLevelOne: AnyObject = remoteNotification["aps"], jsonLevelTwo: AnyObject = jsonLevelOne["alert"] {
            
            let jsonObject3 = jsonLevelTwo["body"] as! String
            detailLabel.setText(jsonObject3)
        }
        
        if let topLevelTitle = remoteNotification["title"] as? String {
            titleLabel.setText(topLevelTitle)
        }
        
        completionHandler(.Custom)
    }
}
