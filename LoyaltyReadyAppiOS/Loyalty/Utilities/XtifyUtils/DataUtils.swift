/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

protocol DataUtilsDelegate {
    func richNotificationsReceived(_ jsonDictionary: NSDictionary)
}

/**
*  Various methods for gathering and manipulating data
*/
class DataUtils {
    
    var dataDelegate: DataUtilsDelegate!
    var logger : OCLogger = OCLogger.getInstanceWithPackage("Loyalty");
    
    init() {}
    
    /**
    Pulls down all pending rich notifications or a specific rich notification
    
    - parameter richID: determines if we are getting an individual notification by ID or gathering all pending notifications
    */
    func richNotificationsRequest(_ richID: String) {
        
        var url = ""
        // if richID exists, find specific rich notification
        if richID != "" {
            url = "http://sdk.api.xtify.com/2.0/rn/\(XLappMgr.get().getXid())/details?appKey=\(XLappMgr.get().currentAppKey)&mid=\(richID)"
        } else {
            url = "http://sdk.api.xtify.com/2.0/rn/\(XLappMgr.get().getXid())/pending?appKey=\(XLappMgr.get().currentAppKey)"
        }
        
        let request = NSMutableURLRequest()
        request.url = URL(string: url)
        request.httpMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue(), completionHandler:{ (response:URLResponse?, data: Data?, error: NSError?) -> Void in
            if error == nil && data!.count > 0 {
                if let jsonResult: NSDictionary? = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    if jsonResult != nil {
                        self.dataDelegate.richNotificationsReceived(jsonResult!)
                    }
                }
            } else if error == nil && data!.count == 0 {
                self.logger.logErrorWithMessages(message: "Empty Reply Error: \(error!.localizedDescription)");
            } else {
                self.logger.logErrorWithMessages(message: "Error: \(error!.localizedDescription)");
            }

        } as! (URLResponse?, Data?, Error?) -> Void)
        
    }
    
    /**
    Method to grab current notificationDataList, add data to it, and save locally for furture use
    
    - parameter notificationData: NotificationData to be saved
    
    - returns: Modified NotificationDataList
    */
    class func saveNotificationLocally(_ notificationData: NotificationData) -> Bool {
        
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
    
    class func setObject(_ value: AnyObject!, forKey defaultName: String!) {
        let defaults:UserDefaults = UserDefaults.standard
        defaults.set(value, forKey:defaultName)
        defaults.synchronize()
    }
    
    class func objectForKey(_ defaultName: String!) -> AnyObject! {
        let defaults:UserDefaults = UserDefaults.standard
        
        return defaults.object(forKey: defaultName) as AnyObject
    }
    
    class func removeObjectForKey(_ defaultName: String!) {
        let defaults:UserDefaults = UserDefaults.standard
        
        defaults.removeObject(forKey: defaultName)
    }
    
}
