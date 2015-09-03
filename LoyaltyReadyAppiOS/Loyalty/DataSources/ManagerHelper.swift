/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/**
*  Protocol to provide success and failure messages
*/
protocol HelperDelegate {
  func resourceSuccess(response: WLResponse!)
  func resourceFailure(response: String!)
}

/**
*  Helper class to connect to MFP and initiate a resource request ]
*/
class ManagerHelper: NSObject {
  /// HelperDelegate for the ManagerHelper
  var delegate: HelperDelegate!
  /// String containing the url to initiate the resource request
  var URLString: String!
  
  init(URLString: String!, delegate: HelperDelegate!) {
    self.URLString = URLString
    self.delegate = delegate
  }
  
    /**
    Method to initiate a connection to the WLClient.sharedInstance()
    */
  func getResource() {
    WLClient.sharedInstance().wlConnectWithDelegate(self)
  }
    
}

extension ManagerHelper: WLDelegate {
    /**
    Method called upon successful MFP connection to send user data if resource request is successful, or resource failure error message if unsuccessful
    
    - parameter response: WLResponse containing user data
    */
  func onSuccess(response: WLResponse!) {
    MQALogger.log("Connection SUCCESS!")
    let request = WLResourceRequest(URL: NSURL(string: URLString), method: WLHttpMethodGet)
    request.sendWithCompletionHandler { (WLResponse response, NSError error) -> Void in
      if(error != nil){ //connection success with error (can't find user)
        //self.delegate.resourceFailure(error.description)
        self.delegate.resourceFailure("unknown user")
      }
      else if(response != nil){ //connection success with correct user data
        self.delegate.resourceSuccess(response)
      }
    }
  }
  
    /**
    Method called upon failure to connect to MFP, will send errorMsg
    
    - parameter response: WLFailResponse containing failure response
    */
  func onFailure(response: WLFailResponse!) {
    MQALogger.log("Connection FAILURE!")
    
    //self.delegate.resourceFailure(response.errorMsg)
    self.delegate.resourceFailure("no connection")
  }
}