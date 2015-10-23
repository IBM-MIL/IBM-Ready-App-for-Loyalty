/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UITabBar.appearance().tintColor = UIColor.purpleLoyalty()
        
        UIApplication.sharedApplication().statusBarHidden = false
        
        //enable MQA in pre-production mode
        MQALogger.settings().mode = MQAMode.Market
        
        // Starts a quality assurance session
        MQALogger.startNewSessionWithApplicationKey(self.getKey());

        // Enables the quality assurance application crash reporting
        NSSetUncaughtExceptionHandler(exceptionHandlerPointer)
        
        // Set the logger level for Worklight
        OCLogger.setLevel(OCLogger_ERROR)
        
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai.trackUncaughtExceptions = true  // report uncaught exceptions
        gai.logger.logLevel = GAILogLevel.Verbose  // remove before app release
        
        return true
    }
    
    func getKey () -> String {
        let path: String = NSBundle.mainBundle().pathForResource("MQA_key", ofType: "plist")!
        let keyList = NSDictionary(contentsOfFile: path)
        return keyList!.objectForKey("MQA") as! String
    }
    
    func applicationWillResignActive(application: UIApplication) {

    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        MQALogger.log("Application is about to Enter Background")
        
        XLappMgr.get().appEnterBackground()
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        MQALogger.log("Application moved to Foreground")
        
        XLappMgr.get().appEnterForeground()
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        MQALogger.log("Application moved from inactive to Active state")
        
        XLappMgr.get().appEnterActive()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        MQALogger.log("applicationWillTerminate")
        
        XLappMgr.get().applicationWillTerminate()
    }
    
    // MARK: Xtify Notification Handling
    
    override init() {
        super.init()
        
        let anXtifyOptions = XLXtifyOptions.getXtifyOptions()
        XLappMgr.get().initilizeXoptions(anXtifyOptions)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        MQALogger.log("Succeeded registering for push notifications. Dev Token: \(deviceToken)")
        XLappMgr.get().registerWithXtify(deviceToken)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        MQALogger.log("Recieving notification from any app state")
        
        let launchOptions = userInfo
        self.handleAnyNotification(launchOptions)
        completionHandler(UIBackgroundFetchResult.NewData)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        MQALogger.log("Failed to register with error: \(error)")
        XLappMgr.get().registerWithXtify(nil)
    }
    
}

// MARK: Custom Notification handling methods

extension AppDelegate: DataUtilsDelegate {
    
    /**
    Method that all notifications must go through, including when app is active and when coming from an inactive state
    
    - parameter receivedData: data received from notification
    */
    func handleAnyNotification(receivedData: Dictionary<NSObject,AnyObject>) {
        MQALogger.log("DATA: \(receivedData)")
        
        if receivedData.isEmpty {
            return
        }
        
        if let value = receivedData["RN"] as? String {
            
            let dataUtils = DataUtils()
            dataUtils.dataDelegate = self
            dataUtils.richNotificationsRequest(value)
            return
        }
        
        self.handleSimplePush(receivedData)
    }
    
    /**
    Method to handle simple notifications and display them to user
    
    - parameter receivedData: json data received from Xtify
    */
    func handleSimplePush(receivedData: Dictionary<NSObject, AnyObject>) {
        
        if let theDeal = self.parseNotificationJson(receivedData) {
            
            // Alert to show user the deal and display options to view details of deal
            let alertController = UIAlertController(title: theDeal.0, message: theDeal.1.name, preferredStyle: .Alert)
            
            let detailAction = UIAlertAction(title: NSLocalizedString("Details", comment: "n/a"), style: .Default) { (action) in
                self.loadDealDetails(theDeal.1)
            }
            let OKAction = UIAlertAction(title: NSLocalizedString("OK", comment: "n/a"), style: .Default, handler: nil)
            alertController.addAction(detailAction)
            alertController.addAction(OKAction)

            // Prevents UIAlertController's from being presented on top of each other
            if let _ = UIApplication.sharedApplication().keyWindow?.rootViewController?.presentedViewController as? UIAlertController { }
            else {
                self.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    /**
    Method to parse json response, extracting the title and a Deal object
    
    - parameter json: json from Xtify
    
    - returns: a Tuple with the title and Deal object
    */
    func parseNotificationJson(json: Dictionary<NSObject, AnyObject>) -> (String, Deal)? {
        
        // Find alert title if available
        var title = ""
        if let tempTitle = json["title"] as? String {
            title = tempTitle
        }
        
        if let theDeal = json["deal"] as? String {
            if theDeal != "" {
            
                let jsonData = theDeal.dataUsingEncoding(NSUTF8StringEncoding)
                let dealJson = (try! NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers)) as! [String:AnyObject]
                
                let notificationDeal: Deal = Deal(notificationJson: dealJson)
                
                return (title, notificationDeal)
            } else {
                return nil
            }
            
        } else if (json["name"] as? String != nil) { // Verify json is flat, not nested
            
            // Xtify Workaround: Xtify is inconsistent in that it can send nested Json only sometimes, this else statement catches those.
            let formattedJson = json as! [String:AnyObject]
            let notificationDeal = Deal(notificationJson: formattedJson)
            
            return (title, notificationDeal)
        } else {
            return nil
        }
    }
    
    /**
    Method presents the deal details view controller with the deal just received from Xtify
    
    - parameter deal: deal to load
    */
    func loadDealDetails(deal: Deal) {

        if let tabBar = UIApplication.sharedApplication().keyWindow?.rootViewController as? UITabBarController {
            
            if let dealsDetailViewController = Utils.vcWithNameFromStoryboardWithName("DealsDetailViewController", storyboardName: "Deals") as? DealsDetailViewController {
                dealsDetailViewController.deal = deal
                tabBar.viewControllers?[tabBar.selectedIndex].navigationController?.popToRootViewControllerAnimated(false)
                tabBar.viewControllers?[tabBar.selectedIndex].navigationController?.pushViewController(dealsDetailViewController, animated: true)
            }
            
            
        }
    }
    
    /**
    Method to register custom notification actions and categories (iOS 8+)
    */
    func registerSettingsAndCategories() {
        
        /* Standard Deal Category */
        
        let detailAction = UIMutableUserNotificationAction()
        detailAction.title = NSLocalizedString("Details", comment: "n/a")
        detailAction.identifier = "detailsButtonAction"
        detailAction.activationMode = UIUserNotificationActivationMode.Foreground
        detailAction.authenticationRequired = true
        detailAction.destructive = false
        
        let saveAction = UIMutableUserNotificationAction()
        saveAction.title = NSLocalizedString("Save Deal", comment: "n/a")
        saveAction.identifier = "saveDealButtonAction"
        saveAction.activationMode = UIUserNotificationActivationMode.Background
        saveAction.authenticationRequired = false
        saveAction.destructive = false
        
        let dealCategory = UIMutableUserNotificationCategory()
        dealCategory.identifier = "dealCategory"
        dealCategory.setActions([detailAction, saveAction], forContext: UIUserNotificationActionContext.Default)
        
        /* Goal Reached Category */
        
        let goalAction = UIMutableUserNotificationAction()
        goalAction.title = NSLocalizedString("Details", comment: "n/a")
        goalAction.identifier = "goalReachedButtonAction"
        goalAction.activationMode = UIUserNotificationActivationMode.Foreground
        goalAction.authenticationRequired = false
        
        let goalCategory = UIMutableUserNotificationCategory()
        goalCategory.identifier = "goalCategory"
        goalCategory.setActions([goalAction], forContext: UIUserNotificationActionContext.Default)
        
        
        // Configure other actions and categories and add them to the set...
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: nil))
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Badge, categories: nil))
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound, categories: nil))
        
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        
        // If user selected details outside of app, load deal details
        if identifier == "detailsButtonAction" || identifier == "goalReachedButtonAction" {
            
            if let dealObject = self.parseNotificationJson(userInfo) {
                self.loadDealDetails(dealObject.1)
            }
            
        }
        
        completionHandler()
    }
    
    /**
    Delegate method to receive json data from API call
    
    - parameter jsonDictionary: a dictionary of json data from Xtify
    */
    func richNotificationsReceived(jsonDictionary: NSDictionary) {
        
        if let response = jsonDictionary["response"] as? String {
            
            if jsonDictionary.count > 0 && response == "SUCCESS" {
                MQALogger.log("Result: \(jsonDictionary)")
                
                if let messages = jsonDictionary["messages"] as? NSArray {
                    dispatch_async(dispatch_get_main_queue(),{
                        for dictionaryData in messages {
                            let notificationData = NotificationData(richNotificationJson: dictionaryData as! Dictionary<NSObject, AnyObject>)
                            
                            // Alerts have no other purpose than to allow you to see the notification data on your device
                            let alertView = UIAlertController(title: notificationData.title, message: notificationData.body, preferredStyle: .Alert)
                            alertView.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "n/a"), style: .Default, handler: nil))
                            self.window?.rootViewController?.presentViewController(alertView, animated: true, completion: nil)
                        }
                    })
                }
            }
        }
        
    }
    
    // MARK: Handoff Communication
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        if let _ = userActivity.userInfo {
            
            if let window = self.window {
                
                if userActivity.activityType == WatchKitDealListType {
                    if let tabBarVC = window.rootViewController as? CustomTabBarController {
                        tabBarVC.setSelectIndex(from: tabBarVC.selectedIndex, to: 1)
                    }
                    
                }
            }
            
        }
        
        return true
    }
    
}
  
  
