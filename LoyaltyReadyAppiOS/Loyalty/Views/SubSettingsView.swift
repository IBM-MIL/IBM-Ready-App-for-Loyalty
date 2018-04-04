/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

class SubSettingsView: UIView {
        
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!

    @IBOutlet weak var mainButton: UIButton!
    
    @IBOutlet weak var noThanksButton: UIButton!
    
    /**
    This method returns an instance of the SubSettingsView from the SubSettingsView nib file
    
    - returns: an instance of the SubSettingsView from the SubSettingsView nib file
    */
    class func instanceFromNib() -> SubSettingsView {
        return UINib(nibName: "SubSettingsView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SubSettingsView
    }


}
