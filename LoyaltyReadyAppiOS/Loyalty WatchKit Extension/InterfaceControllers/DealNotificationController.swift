/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import WatchKit
import Foundation

/**
* Controller for remote, long-look notifications of deals
*/
class DealNotificationController: WKUserNotificationInterfaceController {
    
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
        
        
        // In JSON Payload, include json in the following format:
        /*

        {
            "title": "Nearby Deal",
            "deal": {
                "name": "25% Off Sports Drinks",
                "im": "sportsDrink",
                "exp": 23,
                "hl": "25% Off Sports Drinks, check it out"
            }
        }
        */

        if let jsonLevelOne: AnyObject = remoteNotification["aps"], let jsonLevelTwo: AnyObject = jsonLevelOne["alert"] {
            
            let jsonObject3 = jsonLevelTwo["body"] as! String
            detailLabel.setText(jsonObject3)
        }
        
        if let topLevelTitle = remoteNotification["title"] as? String {
            titleLabel.setText(topLevelTitle)
        }

        completionHandler(.Custom)
    }
    
}
