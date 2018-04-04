/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit
import IBMMobileFirstPlatformFoundationJSONStore

/**
*   Asks ManagerHelper to initiate a resource request to get authorized User data
*/
open class UserDataManager: NSObject {
    
    /// String for the user's phone number to be part of the resource request
    var phoneNumber: String!
    /// String for the locale of the user's device to be part of the resource request
    var locale: String! = Locale.preferredLanguages[0] 
    /// Callback object to return data to the requesting class
    var callback: (([String: AnyObject])->())!
    /// Data dictionary to contain user data
    var data: [String : AnyObject]!
    /// Current user that is accessed throughout the app
    var currentUser: User! = User()
    /// Shared instance variable for access the currentUser
    static let sharedInstance = UserDataManager()
    /// Used to transfer the selected station from Rewards view to Stations view
    var selectedStation: GasStation!
    
    
    /**
    Method to get user data using a resource request created by a ManagerHelper
    
    - parameter callback: callback to send user data
    */
    open func getUserData(_ phoneNumber: String!, callback: @escaping ([String: AnyObject])->()) {
        self.callback = callback
        let url = "/adapters/LoyaltyUserAdapter/user-data/" + phoneNumber + "/" + locale
        //let url = "/adapters/LoyaltyUserAdapter/resource/user-data/" + phoneNumber + "/" + "en"
        
        let manHelper = ManagerHelper(URLString: url, delegate: self)
        manHelper.getResource()
    }
    
    /**
    Method to get anonymous user data using a resource request created by a ManagerHelper
    
    - parameter callback: callback to send anonymous user data
    */
    open func getAnonUserData(_ callback: @escaping ([String: AnyObject])->()) {
        self.callback = callback
        let url = "/adapters/LoyaltyUserAdapter/app-data/" + locale
        //let url = "/adapters/LoyaltyUserAdapter/resource/app-data/" + "en"
        
        let manHelper = ManagerHelper(URLString: url, delegate: self)
        manHelper.getResource()
    }
    
    /**
    Method to send user data via callback
    */
    fileprivate func sendUserData() {
        callback(data)
    }
    
}

extension UserDataManager: HelperDelegate {
    /**
    Method to send user data from a WLResponse if the resource request is successful
    
    - parameter response: WLResponse containing data
    */
    func resourceSuccess(_ response: WLResponse!) {
        data = response.getJson() as! [String: AnyObject]
        if data != nil {
            //Sample JSONStore implementation
            let collection = JSONStoreCollection(name: "authUser")
            collection?.setSearchField("id", with: JSONStore_Integer)
            do {
                try JSONStore.sharedInstance().openCollections([collection], with: nil)
            } catch _ {
            }
            //Now send data to ViewController
            sendUserData()
        }
    }
    
    /**
    Method to send error message if the resource request fails
    
    - parameter error: error message for resource request failure
    */
    func resourceFailure(_ error: String!) {
        data = ["failure":error as AnyObject] //either "unknown user" or "no connection"
        sendUserData()
    }
}
