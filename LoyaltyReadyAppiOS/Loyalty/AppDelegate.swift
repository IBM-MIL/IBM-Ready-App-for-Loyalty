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
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        logger.logInfoWithMessages(message: "Application moved to Foreground")
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        logger.logInfoWithMessages(message: "Application moved from inactive to Active state")
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        logger.logInfoWithMessages(message: "applicationWillTerminate")
        func stopMonitoring(geotification: Geotification) {
            for region in locationManager.monitoredRegions {
                guard let circularRegion = region as? CLCircularRegion, circularRegion.identifier == geotification.identifier else { continue }
                locationManager.stopMonitoring(for: circularRegion)
            }
        }
        
    }
    func applicationShouldTerminate(_ application: UIApplication) {
        logger.logInfoWithMessages(message: "applicationWillTerminate")
        func stopMonitoring(geotification: Geotification) {
            for region in locationManager.monitoredRegions {
                guard let circularRegion = region as? CLCircularRegion, circularRegion.identifier == geotification.identifier else { continue }
                locationManager.stopMonitoring(for: circularRegion)
            }
        }
        
    }
    
    
    
    override init() {
        super.init()
        
        registerForPush()

      
    }
    
    func registerForPush () {
        
        let myBMSClient = BMSClient.sharedInstance
        myBMSClient.initialize(bluemixRegion: BMSClient.Region.unitedKingdom)
        let push =  BMSPushClient.sharedInstance
        
        push.initializeWithAppGUID(appGUID: "abf20737-4aa7-41ed-af6f-86e137299216", clientSecret:"b71f0593-5bfc-48a7-8d89-47ec0453bebf")
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
  logger.logInfoWithMessages(message: "Succeeded registering for push notifications. Dev Token: \(deviceToken)")
     
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
        

        let payLoad = ((((userInfo as NSDictionary).value(forKey: "aps") as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "body") as! String)
        
        self.showAlert(title: "Recieved Push notifications", message: payLoad)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        logger.logInfoWithMessages(message: "Failed to register with error: \(error)")
      
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
        
    }
    

    
    //MARK IBM Push
    
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
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
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


  
