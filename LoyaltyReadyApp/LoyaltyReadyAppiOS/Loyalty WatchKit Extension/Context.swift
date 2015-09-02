/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/**
*  Watch helper class to better pass data between controllers and notifications
*/
class Context {
    
    /// This is any object that you want to pass via context in watch
    var dataObject: AnyObject?
    
    /// Boolean to determine if context data is from a notification
    var fromNotification: Bool = false
    
    /// Boolean to determine if context data is from a goal reached notification
    var isGoalReached: Bool = false
    
    init(data: AnyObject?) {
        dataObject = data
    }
}
