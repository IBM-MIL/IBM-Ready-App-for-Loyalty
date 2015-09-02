/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

public class WatchDataManager: NSObject {
    
    internal var openedWithNotification = false
    internal var notificationObjects:(String, Deal)?
    
    public class var sharedInstance : WatchDataManager{
        
        struct Singleton {
            static let instance = WatchDataManager()
        }
        return Singleton.instance
    }
    
    
   
}
