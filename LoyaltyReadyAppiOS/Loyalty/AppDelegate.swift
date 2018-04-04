/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit
import BMSPush
import BMSCore
import UserNotifications
import UserNotificationsUI
import CoreLocation
import OpenWhisk



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let logger : OCLogger = OCLogger.getInstanceWithPackage("Loyalty");
    let locationManager = CLLocationManager()
    
    // Change to your whisk app key and secret.
    let WhiskAppKey = "15a25a42-ba66-4388-a210-716b2a7fba10"
    let WhiskAppSecret = "PsMODRjgtgQ2nIHu8XA2lwPFIn8bDIAWbMy58Q8sPCcRgroIXU6tSsr7kq4NbO13"

    
    // the URL for Whisk backend
    let baseUrl: String? = "https://openwhisk.ng.bluemix.net"
    
    // The action to invoke.
    let MyPackage: String? = "com.ibm.mil.readyapps"
    let MyWhiskAction: String = "sendDeals"
    
    var MyActionParameters: [String:AnyObject]? = nil
    let HasResult: Bool = true // true if the action returns a result
    var session: URLSession!

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
       // application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
        
        UITabBar.appearance().tintColor = UIColor.purpleLoyalty()
        
        UIApplication.shared.isStatusBarHidden = false
        
        
        
        
        // Set the logger level for Worklight
        OCLogger.setLevel(OCLogger_DEBUG)

        
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai?.trackUncaughtExceptions = true  // report uncaught exceptions
        gai?.logger.logLevel = GAILogLevel.verbose  // remove before app release
        
        
        
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {

    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {

        logger.logInfoWithMessages(message: "Application is about to Enter Background")
        XLappMgr.get().appEnterBackground()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        logger.logInfoWithMessages(message: "Application moved to Foreground")
        XLappMgr.get().appEnterForeground()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        logger.logInfoWithMessages(message: "Application moved from inactive to Active state")
        XLappMgr.get().appEnterActive()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        logger.logInfoWithMessages(message: "applicationWillTerminate")
        XLappMgr.get().applicationWillTerminate()
    }
    
    // MARK: Xtify Notification Handling
    
    override init() {
        super.init()
        
        registerForPush()

      //  let anXtifyOptions = XLXtifyOptions.getXtifyOptions()
       // XLappMgr.get().initilizeXoptions(anXtifyOptions)
    }
    
    func registerForPush () {
        
        let myBMSClient = BMSClient.sharedInstance
        myBMSClient.initialize(bluemixRegion: BMSClient.Region.unitedKingdom)
        let push =  BMSPushClient.sharedInstance
        
        push.initializeWithAppGUID(appGUID: "abf20737-4aa7-41ed-af6f-86e137299216", clientSecret:"b71f0593-5bfc-48a7-8d89-47ec0453bebf")
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
  logger.logInfoWithMessages(message: "Succeeded registering for push notifications. Dev Token: \(deviceToken)")
     //   XLappMgr.get().register(withXtify: deviceToken)
        let push =  BMSPushClient.sharedInstance
        push.registerWithDeviceToken(deviceToken: deviceToken, WithUserId:"sampleUserID", completionHandler:  { (response, statusCode, error) -> Void in
            
            if error.isEmpty {
                
                print( "Response during device registration : \(String(describing: response))")
                
                print( "status code during device registration : \(String(describing: statusCode))")
                let responseJson = self.convertStringToDictionary(text: response!)! as NSDictionary
                let userId = responseJson.value(forKey: "userId")
                
                self.sendNotifToDisplayResponse(responseValue: "Device Registered Successfully with User ID \(String(describing: userId!))", responseBool: true)
            }
            else{
                print( "Error during device registration \(error) ")
                
                self.sendNotifToDisplayResponse( responseValue: "Error during device registration \n  - status code: \(String(describing: statusCode)) \n Error :\(error) \n", responseBool: false)
            }
        })
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        logger.logInfoWithMessages(message: "Recieving notification from any app state")
        
//        let launchOptions = userInfo
//        self.handleAnyNotification(launchOptions as! [String: Any])
//        completionHandler(UIBackgroundFetchResult.newData)
        let payLoad = ((((userInfo as NSDictionary).value(forKey: "aps") as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "body") as! String)
        
        self.showAlert(title: "Recieved Push notifications", message: payLoad)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        logger.logInfoWithMessages(message: "Failed to register with error: \(error)")
      //  XLappMgr.get().register(withXtify: nil)
        let message:String = "Error registering for push notifications: \(error.localizedDescription)"
        
        self.showAlert(title: "Registering for notifications", message: message)
    }
    
    
    //geo fencing
    
    func handleEvent(forRegion region: CLRegion!) {
        
        //invoking openwhisk
        
        // create whisk credentials token
         let credentialsConfiguration = WhiskCredentials(accessKey: WhiskAppKey,accessToken: WhiskAppSecret)
         let whisk = Whisk(credentials: credentialsConfiguration)
         whisk.baseURL = "https://openwhisk.eu-gb.bluemix.net"
         
         do {
         try whisk.invokeAction(name: "sendDeals", package: "com.ibm.mil.readyapps", namespace: "dselvara@in.ibm.com_sdp", parameters: nil, hasResult: true,  callback: {(reply, error) -> Void in
         if let error = error {
         print("Error invoking action \(error.localizedDescription)")
         } else {
         print("Action invoked!")
         }
         
         })
         } catch {
         print("Error \(error)")
         }
        
        
        // Show an alert if application is active
       // if UIApplication.shared.applicationState == .active {
            //guard let message = note(fromRegionIdentifier: region.identifier) else { return }
            //let message = "Hello"
            //window?.showAlert(withTitle: nil, message: message)
            //showAlert(title: "Notification", message: message)
            
            
      //  } else {
            // Otherwise present a local notification
           // let notification = UILocalNotification()
            //notification.alertBody = note(fromRegionIdentifier: region.identifier)
           // notification.alertBody = "Hello"
           // notification.soundName = "Default"
          //  UIApplication.shared.presentLocalNotificationNow(notification)
       // }
    }
    
    /*   func note(fromRegionIdentifier identifier: String) -> String? {
     let savedItems = UserDefaults.standard.array(forKey: PreferencesKeys.savedItems) as? [NSData]
     let geotifications = savedItems?.map { NSKeyedUnarchiver.unarchiveObject(with: $0 as Data) as? Geotification }
     let index = geotifications?.index { $0?.identifier == identifier }
     return index != nil ? geotifications?[index!]?.note : nil
     }*/
    
    //geo fencing
    
}

// MARK: Custom Notification handling methods

extension AppDelegate: DataUtilsDelegate {
    
    //ibm push methods
    
    func sendNotifToDisplayResponse (responseValue:String, responseBool: Bool){
        
        // responseText = responseValue
        // isSuccess = responseBool
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "action"), object: self);
    }
    
    func showAlert (title:String , message:String){
        
        // create the alert
        let alert = UIAlertController.init(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.window!.rootViewController!.present(alert, animated: true, completion: nil)
    }
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            
            guard let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] else {
                return [:]
            }
            return result
        }
        return [:]
    }
    
   func unRegisterPush () {
        
        // MARK:  RETRIEVING AVAILABLE SUBSCRIPTIONS
        
        let push =  BMSPushClient.sharedInstance
        
        push.retrieveSubscriptionsWithCompletionHandler { (response, statusCode, error) -> Void in
            
            if error.isEmpty {
                
                print( "Response during retrieving subscribed tags : \(String(describing: response?.description))")
                
                print( "status code during retrieving subscribed tags : \(String(describing: statusCode))")
                
                // MARK:  UNSUBSCRIBING TO TAGS
                
                push.unsubscribeFromTags(tagsArray: response!, completionHandler: { (response, statusCode, error) -> Void in
                    
                    if error.isEmpty {
                        
                        print( "Response during unsubscribed tags : \(String(describing: response?.description))")
                        
                        print( "status code during unsubscribed tags : \(String(describing: statusCode))")
                        
                        // MARK:  UNSREGISTER DEVICE
                        push.unregisterDevice(completionHandler: { (response, statusCode, error) -> Void in
                            
                            if error.isEmpty {
                                
                                print( "Response during unregistering device : \(String(describing: response))")
                                
                                print( "status code during unregistering device : \(String(describing: statusCode))")
                                
                                UIApplication.shared.unregisterForRemoteNotifications()
                            }
                            else{
                                print( "Error during unregistering device \(error) ")
                            }
                        })
                    }
                    else {
                        print( "Error during  unsubscribed tags \(error) ")
                    }
                })
            }
            else {
                
                print( "Error during retrieving subscribed tags \(error) ")
            }
            
        }
        
    }
    
    
    
    
    
    
    
    
    // ibm push methods
    
    
    
    /**
    Method that all notifications must go through, including when app is active and when coming from an inactive state
    
    - parameter receivedData: data received from notification
    */
    func handleAnyNotification(_ receivedData: Dictionary<String,Any>) {
       
        
        if receivedData.isEmpty {
      //  if ( [receivedData count] == 0 ) {
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
    func handleSimplePush(_ receivedData: Dictionary<String, Any>) {
        
        if let theDeal = self.parseNotificationJson(receivedData) {
            
            // Alert to show user the deal and display options to view details of deal
            let alertController = UIAlertController(title: theDeal.0, message: theDeal.1.name, preferredStyle: .alert)
            
            let detailAction = UIAlertAction(title: NSLocalizedString("Details", comment: "n/a"), style: .default) { (action) in
                self.loadDealDetails(theDeal.1)
            }
            let OKAction = UIAlertAction(title: NSLocalizedString("OK", comment: "n/a"), style: .default, handler: nil)
            alertController.addAction(detailAction)
            alertController.addAction(OKAction)

            // Prevents UIAlertController's from being presented on top of each other
            if let _ = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController as? UIAlertController { }
            else {
                self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    /**
    Method to parse json response, extracting the title and a Deal object
    
    - parameter json: json from Xtify
    
    - returns: a Tuple with the title and Deal object
    */
    //func parseNotificationJson(_ json: Dictionary<NSObject, AnyObject>) -> (String, Deal)? {
    func parseNotificationJson(_ json: Dictionary<AnyHashable, Any>) -> (String, Deal)? {
        
        // Find alert title if available
        var title = ""
        if let tempTitle = json["title"] as? String {
            title = tempTitle
        }
        
        if let theDeal = json["deal"] as? String {
            if theDeal != "" {
            
                let jsonData = theDeal.data(using: String.Encoding.utf8)
                let dealJson = (try! JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! [String:AnyObject]
                
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
    func loadDealDetails(_ deal: Deal) {

        if let tabBar = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
            
            if let dealsDetailViewController = Utils.vcWithNameFromStoryboardWithName("DealsDetailViewController", storyboardName: "Deals") as? DealsDetailViewController {
                dealsDetailViewController.deal = deal
                tabBar.viewControllers?[tabBar.selectedIndex].navigationController?.popToRootViewController(animated: false)
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
        detailAction.activationMode = UIUserNotificationActivationMode.foreground
        detailAction.isAuthenticationRequired = true
        detailAction.isDestructive = false
        
        let saveAction = UIMutableUserNotificationAction()
        saveAction.title = NSLocalizedString("Save Deal", comment: "n/a")
        saveAction.identifier = "saveDealButtonAction"
        saveAction.activationMode = UIUserNotificationActivationMode.background
        saveAction.isAuthenticationRequired = false
        saveAction.isDestructive = false
        
        let dealCategory = UIMutableUserNotificationCategory()
        dealCategory.identifier = "dealCategory"
        dealCategory.setActions([detailAction, saveAction], for: UIUserNotificationActionContext.default)
        
        /* Goal Reached Category */
        
        let goalAction = UIMutableUserNotificationAction()
        goalAction.title = NSLocalizedString("Details", comment: "n/a")
        goalAction.identifier = "goalReachedButtonAction"
        goalAction.activationMode = UIUserNotificationActivationMode.foreground
        goalAction.isAuthenticationRequired = false
        
        let goalCategory = UIMutableUserNotificationCategory()
        goalCategory.identifier = "goalCategory"
        goalCategory.setActions([goalAction], for: UIUserNotificationActionContext.default)
        
        
        // Configure other actions and categories and add them to the set...
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: UIUserNotificationType.alert, categories: nil))
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: UIUserNotificationType.badge, categories: nil))
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: UIUserNotificationType.sound, categories: nil))
        
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
        
        // If user selected details outside of app, load deal details
        if identifier == "detailsButtonAction" || identifier == "goalReachedButtonAction" {
            
            if let dealObject = self.parseNotificationJson(userInfo as Dictionary<NSObject, AnyObject>) {
                self.loadDealDetails(dealObject.1)
            }
            
        }
        
        completionHandler()
    }
    
    /**
    Delegate method to receive json data from API call
    
    - parameter jsonDictionary: a dictionary of json data from Xtify
    */
    func richNotificationsReceived(_ jsonDictionary: NSDictionary) {
        
        if let response = jsonDictionary["response"] as? String {
            
            if jsonDictionary.count > 0 && response == "SUCCESS" {
                
                
                if let messages = jsonDictionary["messages"] as? NSArray {
                    DispatchQueue.main.async(execute: {
                        for dictionaryData in messages {
                            let notificationData = NotificationData(richNotificationJson: dictionaryData as! Dictionary<NSObject, AnyObject>)
                            
                            // Alerts have no other purpose than to allow you to see the notification data on your device
                            let alertView = UIAlertController(title: notificationData.title, message: notificationData.body, preferredStyle: .alert)
                            alertView.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "n/a"), style: .default, handler: nil))
                            self.window?.rootViewController?.present(alertView, animated: true, completion: nil)
                        }
                    })
                }
            }
        }
        
    }
    
    // MARK: Handoff Communication
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
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


extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleEvent(forRegion: region)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleEvent(forRegion: region)
        }
    }
    
   
}

  
