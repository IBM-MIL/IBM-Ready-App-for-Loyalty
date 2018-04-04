/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/**
*  The view presented when an alert is triggered
*/
open class MILAlertView : UIView {
    
    //// Label of the alert
    @IBOutlet weak var alertLabel : UILabel!
    /// Reload button that may or may not be shown
    @IBOutlet weak var reloadButton: UIButton!
    
    var callback : (()->())!
    
    var isLoading = false

    /**
    Initializer for MILAlertView
    
    - returns: And instance of MILAlertView
    */
    class func instanceFromNib() -> MILAlertView {
        return UINib(nibName: "MILAlertView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MILAlertView
    }
    
    /**
    Sets the text on the MILAlertView's label
    
    - parameter text: The text to be displayed
    */
    func setLabel(_ text: String!) {
        if text != nil {
            self.alertLabel.text = text
        }
    }
    
    /**
    Sets the callback for the reload button
    
    - parameter callback: The callback function that is to be executed when the reload button is tapped
    */
    func setCallbackFunc(_ callback:(()->())!){
        if callback != nil {
            self.reloadButton.isHidden = false
            self.callback = callback
            reloadButton.addTarget(self, action: #selector(MILAlertView.reloadButtonTapped), for: UIControlEvents.touchUpInside)
        }else{
            self.reloadButton.isHidden = true
        }
    }
    
    /**
    The action for the reload button tap
    
    */
    @IBAction func reloadButtonTapped(){
        callback()
        //MILAlertViewManager.sharedInstance.hide()
    }
}
