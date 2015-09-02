/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import Foundation
import PassKit

/**
* Passbook Utilities
**/
class PassbookUtils: NSObject {
    
    class func showPass(passName: String, context: AnyObject) {
        let filePath = NSBundle.mainBundle().pathForResource(passName, ofType:"pkpass")
        MQALogger.log("\(NSBundle.mainBundle())")
        let pkfile : NSData = NSData(contentsOfFile: filePath!)!
        if let pass : PKPass = PKPass(data: pkfile, error: nil) {
            let vc = PKAddPassesViewController(pass: pass) as PKAddPassesViewController
            context.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
}