/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import Foundation
import WatchKit

/**
* Controller for displaying the details of the deal
**/
class DealDetailInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var dealTitle: WKInterfaceLabel!
    @IBOutlet weak var expirationDate: WKInterfaceLabel!
    @IBOutlet weak var dealBody: WKInterfaceLabel!
    @IBOutlet weak var saveDealBtn: WKInterfaceButton!
    @IBOutlet weak var dealRedemptionGroup: WKInterfaceGroup!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if let contextData = context as? Context {
            
            // Populate UI with data form context
            if let rowData = contextData.dataObject as? Deal {

                dealTitle.setText(rowData.name)
                let formattedDate = rowData.expiration.toString(dateStyle: .ShortStyle, timeStyle: .NoStyle, doesRelativeDateFormatting: false)
                expirationDate.setText("Exp: \(formattedDate)")
                dealBody.setText(rowData.finePrint)
                
            }
            
            // Hide save deal button if coming from deal list
            saveDealBtn.setHidden(!contextData.fromNotification)
            
            // Hide passbook instructions if deal not saved yet
            dealRedemptionGroup.setHidden(contextData.fromNotification)
            
            // If getting a notification for goal reached, just show title and body
            if contextData.isGoalReached {
                saveDealBtn.setHidden(true)
                expirationDate.setHidden(true)
            }
        }
        
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    @IBAction func saveDealItemAction() {
        self.dismissController()
    }
    
}