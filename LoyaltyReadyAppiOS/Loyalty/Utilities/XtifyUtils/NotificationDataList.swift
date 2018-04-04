/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/// Modify with all the categories you support
let stringCategories = [NSLocalizedString("All Notifications", comment: "n/a"), NSLocalizedString("Unread Notifications", comment: "n/a"), NSLocalizedString("Promotions", comment: "n/a"), NSLocalizedString("Safety Alerts", comment: "n/a"), NSLocalizedString("Team News", comment: "n/a"), NSLocalizedString("Instant Replays", comment: "n/a")]

/**
*  Object with dictionaries of all notificaiton data as well as methods to add, update, and clear data
*/
class NotificationDataList: NSObject {
    
    var encodedDictionary: NSMutableDictionary?
    var decodedDictionary: NSMutableDictionary?
    
    init(key: String) {
        super.init()
        
        if let encoded = DataAPI.objectForKey(key) as? NSMutableDictionary {
            self.encodedDictionary = encoded.mutableCopy() as? NSMutableDictionary
            self.populateAndDecode()
        } else {
            self.encodedDictionary = NSMutableDictionary()
            self.decodedDictionary = NSMutableDictionary()
        }
    }
    
    /**
    Essentially populates the decodedDictionary with a decoded version of everything in the encodedDictionary
    */
    fileprivate func populateAndDecode() {
        let tempDict = NSDictionary(dictionary: encodedDictionary!)
        decodedDictionary = NSMutableDictionary()
        
        for (_, data) in tempDict {
            let unarchived = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! NotificationData
            decodedDictionary?.setObject(unarchived, forKey: unarchived.keyTimestamp as NSCopying)
        }
    }
    
    /**
    Load saved data, if any available
    
    - returns: NotificationDataList object if already created
    */
    class func loadSaved(_ key: String) -> NotificationDataList? {
        if let _ = DataAPI.objectForKey(key) as? NSMutableDictionary {
            return NotificationDataList(key: key)
        }
        return nil
    }
    
    /**
    Inserts data into both, already created dictionaries
    
    - parameter data: NotificationData object to add
    */
    func add(_ data: NotificationData) {
        
        self.decodedDictionary?.setObject(data, forKey: data.keyTimestamp as NSCopying)
        
        let encoded = NSKeyedArchiver.archivedData(withRootObject: data)
        self.encodedDictionary?.setObject(encoded, forKey: data.keyTimestamp as NSCopying)
        self.save()
    }
    
    /**
    Method to remove an object from the notificationDataList and from NSUserDefaults
    
    - parameter data: data object to be removed
    */
    func remove(_ data: NotificationData) {
        self.decodedDictionary?.removeObject(forKey: data.keyTimestamp)
        self.encodedDictionary?.removeObject(forKey: data.keyTimestamp)
        self.save()
    }
    
    /**
    Method to save all added or updated data in NSUserDefaults
    */
    func save() {
        DataAPI.setObject(encodedDictionary, forKey: "notificationData")
        
    }
    
    /**
    Update already created dictionaries with updated values on a NotificationData
    
    - parameter key:        dictionary key for object to update
    - parameter dataObject: the modified data object
    */
    func updateNotificationWithKey(_ dataObject: NotificationData) {
        
        self.decodedDictionary?.removeObject(forKey: dataObject.keyTimestamp)
        self.encodedDictionary?.removeObject(forKey: dataObject.keyTimestamp)
        self.add(dataObject)
    }
    
    /**
    Method to clear all NotificationDataList and NSUserDefaults data
    */
    func clear() {
        DataAPI.removeObjectForKey("notificationData")
        self.encodedDictionary = NSMutableDictionary()
        self.decodedDictionary = NSMutableDictionary()
        self.save()
    }
   
    /**
    Method to collect the data by category, only use if you have implemented category on NotificationData
    
    - parameter category: category to filter data by
    
    - returns: an array of NotificationData
    */
    func sortWithCategory(_ category: String) -> [NotificationData] {
        
        var filteredData = [NotificationData]()
        let allVals = self.decodedDictionary?.allValues as! [NotificationData]
        
        if category == stringCategories[0] { // category == All Notifications
            return allVals
        } else if category == stringCategories[1] { // category == Unread
            
            for value in allVals {
                if !value.isRead {
                    filteredData.append(value)
                }
            }
            
        } else {
        
            for value in allVals {
                if value.category == category {
                    filteredData.append(value)
                }
            }
        }
        
        return filteredData
    }
    
    // MARK: Class methods
    
    /**
    Method to sort a NotificationData array by timestamp, an NSDate object
    
    - parameter data: array of data to sort
    
    - returns: sorted NotificationData array
    */
    class func sortByDate(_ data: [NotificationData]) -> [NotificationData] {
        var mutableSorted = data
        mutableSorted.sort(by: { $0.timestamp.compare($1.timestamp as Date) == ComparisonResult.orderedDescending })
        return mutableSorted as [NotificationData]
    }
    
}
