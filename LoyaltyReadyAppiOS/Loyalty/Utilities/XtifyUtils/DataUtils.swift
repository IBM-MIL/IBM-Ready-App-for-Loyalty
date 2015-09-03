/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

protocol DataUtilsDelegate {
    func richNotificationsReceived(jsonDictionary: NSDictionary)
}

/**
*  Various methods for gathering and manipulating data
*/
class DataUtils {
    
    var dataDelegate: DataUtilsDelegate!
    
    init() {}
    
    /**
    Pulls down all pending rich notifications or a specific rich notification
    
    - parameter richID: determines if we are getting an individual notification by ID or gathering all pending notifications
    */
    func richNotificationsRequest(richID: String) {
        
        var url = ""
        // if richID exists, find specific rich notification
        if richID != "" {
            url = "http://sdk.api.xtify.com/2.0/rn/\(XLappMgr.get().getXid())/details?appKey=\(XLappMgr.get().currentAppKey)&mid=\(richID)"
        } else {
            url = "http://sdk.api.xtify.com/2.0/rn/\(XLappMgr.get().getXid())/pending?appKey=\(XLappMgr.get().currentAppKey)"
        }
        
        let request = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            if error == nil && data!.length > 0 {
                if let jsonResult: NSDictionary! = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                    if jsonResult != nil {
                        self.dataDelegate.richNotificationsReceived(jsonResult!)
                    }
                }
            } else if error == nil && data!.length == 0 {
                MQALogger.log("Empty Reply Error: \(error!.localizedDescription)")
            } else {
                MQALogger.log("Error: \(error!.localizedDescription)")
            }

        })
        
    }
    
    /**
    Method to grab current notificationDataList, add data to it, and save locally for furture use
    
    - parameter notificationData: NotificationData to be saved
    
    - returns: Modified NotificationDataList
    */
    class func saveNotificationLocally(notificationData: NotificationData) -> Bool {
        
        if var _ = notificationData.category {
            
            if let dataList = NotificationDataList.loadSaved("notificationData") {
                dataList.add(notificationData)
                return true
            } else {
                let dataList = NotificationDataList(key: "notificationData")
                dataList.add(notificationData)
                return true
            }
                
        }
        return false
    }

}

/**
*  Facade class to interface with various data sources
*/
class DataAPI {
    
    class func setObject(value: AnyObject!, forKey defaultName: String!) {
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(value, forKey:defaultName)
        defaults.synchronize()
    }
    
    class func objectForKey(defaultName: String!) -> AnyObject! {
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        return defaults.objectForKey(defaultName)
    }
    
    class func removeObjectForKey(defaultName: String!) {
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        defaults.removeObjectForKey(defaultName)
    }
    
}
