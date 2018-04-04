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
    
    class func showPass(_ passName: String, context: AnyObject) {
        let logger : OCLogger = OCLogger.getInstanceWithPackage("Loyalty");
        let filePath = Bundle.main.path(forResource: passName, ofType:"pkpass")
        logger.logInfoWithMessages(message:"\(Bundle.main)")
        let pkfile : Data = try! Data(contentsOf: URL(fileURLWithPath: filePath!))
        if let pass : PKPass = PKPass(data: pkfile, error: nil) {
            let vc = PKAddPassesViewController(pass: pass) as PKAddPassesViewController
            context.present(vc, animated: true, completion: nil)
        }
    }
    
}
