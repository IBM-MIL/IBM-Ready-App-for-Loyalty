/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import Foundation
import WatchKit

/**
* Class representing a Deal within a table
**/
class DealRow: NSObject {
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var expirationLabel: WKInterfaceLabel!
    @IBOutlet weak var dealImg: WKInterfaceImage!
}
