/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/**
*  Class to store all related data to a single simple or rich notification
*/
class NotificationData: NSObject {
    
    // There are 2 timestamp objects because keyTimestamp acts as a key for the object when put in the dictionary for NSUserDefaults
    // Also, NSDate objects are a lot easier to work when displaying in a specific format or sorting by date
    var keyTimestamp: String = ""
    var timestamp: Date!
    var title: String = ""
    var body: String = ""
    var isRead: Bool = false
    
    var actionJson: Dictionary<NSObject, AnyObject>?
    var category: String?
    var mediaType: String?
    var mediaName: String?
    
    override init() {}
   
    /**
     For standard push notifications with title and body fields
    
    - parameter notificationJson: A json dictionary of notification data
    */
    init(notificationJson: Dictionary<AnyHashable, Any>) {
        super.init()
        
        if let tempTitle = notificationJson["title"] as? String {
            self.title = tempTitle
        }
        
        var aps = notificationJson["aps"] as! Dictionary<String, AnyHashable>
        var alert = aps["alert"] as! Dictionary<String, AnyHashable>
        let bodyText = alert["body"] as! String
        self.body = bodyText.htmlToText()
        
        self.keyTimestamp = self.createTimeStamp(Date())
        self.timestamp = Date()
    }
    
    /**
    For rich notifications with subject and content fields.
    
    - parameter richNotificationJson: A json dictionary of rich notification data
    */
    init(richNotificationJson: Dictionary<AnyHashable, Any>) {
        super.init()
        
        if let tempTitle = richNotificationJson["subject"] as? String {
            self.title = tempTitle
        }
        
        if let content = richNotificationJson["content"] as? String {
            self.body = content.htmlToText()
        }
        
        // ActionData is optional json data you can include when you build your notification in the Xtify console
        // This example uses action data to store notification category, a media type and name to associate with this notification
        // such as an image or video
        if let actionData = richNotificationJson["actionData"] as? String {
            if actionData != "" {
                let objectData: Data = actionData.data(using: String.Encoding.utf8, allowLossyConversion: false) as Data!
                do{
                    self.actionJson = try! JSONSerialization.jsonObject(with: objectData, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<NSObject, AnyObject>
                    
             /*       if let category = self.actionJson!["category"] as? String {
                        self.category = category
                    }
                    if let mediaType = self.actionJson!["mediaType"] as? String {
                        self.mediaType = mediaType
                    }
                    if let mediaName = self.actionJson!["mediaName"] as? String {
                        self.mediaName = mediaName
                    }
 */
                }
                
            }
        }
        
        self.keyTimestamp = self.createTimeStamp(Date())
        self.timestamp = Date()
    }
    
    // MARK: Encoding and Decoding methods to enable conversion to NSData in order to store in NSUserDefaults
    
    init(coder aDecoder: NSCoder!) {

        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.body = aDecoder.decodeObject(forKey: "body") as! String
        self.keyTimestamp = aDecoder.decodeObject(forKey: "keyTimestamp") as! String
        self.timestamp = aDecoder.decodeObject(forKey: "timestamp") as! Date
        self.isRead = aDecoder.decodeBool(forKey: "isRead") as Bool
        self.actionJson = aDecoder.decodeObject(forKey: "actionJson") as? Dictionary<NSObject, AnyObject>
        self.category = aDecoder.decodeObject(forKey: "category") as? String
        self.mediaType = aDecoder.decodeObject(forKey: "mediaType") as? String
        self.mediaName = aDecoder.decodeObject(forKey: "mediaName") as? String
    }
    
    func encodeWithCoder(_ aCoder: NSCoder) {
        
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.body, forKey: "body")
        aCoder.encode(self.keyTimestamp, forKey: "keyTimestamp")
        aCoder.encode(self.timestamp, forKey: "timestamp")
        aCoder.encode(self.isRead, forKey: "isRead")
        aCoder.encode(self.actionJson, forKey: "actionJson")
        aCoder.encode(self.category, forKey: "category")
        aCoder.encode(self.mediaType, forKey: "mediaType")
        aCoder.encode(self.mediaName, forKey: "mediaName")
    }

    /**
    Method creates a string from an NSDate in the correct format
    
    - returns: an NSDate formatted String
    */
    func createTimeStamp(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.dateStyle = DateFormatter.Style.medium
        return dateFormatter.string(from: date)
    }
    
    /**
    Simple method to mark a notification as read
    */
    func markAsRead() {
        
        if !self.isRead {
            self.isRead = true
            let notificationList = NotificationDataList(key: "notificationData")
            notificationList.updateNotificationWithKey(self)
        }
        
    }
}
