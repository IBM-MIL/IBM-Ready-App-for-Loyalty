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
    var timestamp: NSDate!
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
    init(notificationJson: Dictionary<NSObject, AnyObject>) {
        super.init()
        
        if let tempTitle = notificationJson["title"] as? String {
            self.title = tempTitle
        }
        
        var aps = notificationJson["aps"] as! Dictionary<NSObject, AnyObject>
        var alert = aps["alert"] as! Dictionary<NSObject, AnyObject>
        let bodyText = alert["body"] as! String
        self.body = bodyText.htmlToText()
        
        self.keyTimestamp = self.createTimeStamp(NSDate())
        self.timestamp = NSDate()
    }
    
    /**
    For rich notifications with subject and content fields.
    
    - parameter richNotificationJson: A json dictionary of rich notification data
    */
    init(richNotificationJson: Dictionary<NSObject, AnyObject>) {
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
                let objectData: NSData = actionData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) as NSData!
                do{
                    self.actionJson = try? NSJSONSerialization.JSONObjectWithData(objectData, options: NSJSONReadingOptions.MutableContainers) as! Dictionary<NSObject, AnyObject>
                    
                    if let category = self.actionJson!["category"] as? String {
                        self.category = category
                    }
                    if let mediaType = self.actionJson!["mediaType"] as? String {
                        self.mediaType = mediaType
                    }
                    if let mediaName = self.actionJson!["mediaName"] as? String {
                        self.mediaName = mediaName
                    }
                }
                
            }
        }
        
        self.keyTimestamp = self.createTimeStamp(NSDate())
        self.timestamp = NSDate()
    }
    
    // MARK: Encoding and Decoding methods to enable conversion to NSData in order to store in NSUserDefaults
    
    init(coder aDecoder: NSCoder!) {

        self.title = aDecoder.decodeObjectForKey("title") as! String
        self.body = aDecoder.decodeObjectForKey("body") as! String
        self.keyTimestamp = aDecoder.decodeObjectForKey("keyTimestamp") as! String
        self.timestamp = aDecoder.decodeObjectForKey("timestamp") as! NSDate
        self.isRead = aDecoder.decodeBoolForKey("isRead") as Bool
        self.actionJson = aDecoder.decodeObjectForKey("actionJson") as? Dictionary<NSObject, AnyObject>
        self.category = aDecoder.decodeObjectForKey("category") as? String
        self.mediaType = aDecoder.decodeObjectForKey("mediaType") as? String
        self.mediaName = aDecoder.decodeObjectForKey("mediaName") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(self.title, forKey: "title")
        aCoder.encodeObject(self.body, forKey: "body")
        aCoder.encodeObject(self.keyTimestamp, forKey: "keyTimestamp")
        aCoder.encodeObject(self.timestamp, forKey: "timestamp")
        aCoder.encodeBool(self.isRead, forKey: "isRead")
        aCoder.encodeObject(self.actionJson, forKey: "actionJson")
        aCoder.encodeObject(self.category, forKey: "category")
        aCoder.encodeObject(self.mediaType, forKey: "mediaType")
        aCoder.encodeObject(self.mediaName, forKey: "mediaName")
    }

    /**
    Method creates a string from an NSDate in the correct format
    
    - returns: an NSDate formatted String
    */
    func createTimeStamp(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        return dateFormatter.stringFromDate(date)
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
