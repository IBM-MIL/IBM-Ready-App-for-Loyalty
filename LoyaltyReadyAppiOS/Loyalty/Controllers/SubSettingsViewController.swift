/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

class SubSettingsViewController: LoyaltyUIViewController {
    
    var subSettingsView : SubSettingsView!
    var titleText = ""
    var descriptionText = ""
    var mainButtonText = ""
    var pageIndex: Int!
    weak var editProfileVCReference: EditProfileViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpSubSettingsView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
    This method srts up the subSettingsView and adds it to self.view. This was done to reuse the same view throughout multiple subClasses of the subSettingsViewController
    */
    func setUpSubSettingsView(){
        
        self.subSettingsView = SubSettingsView.instanceFromNib()
        self.subSettingsView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        
        self.subSettingsView.titleLabel.text = self.titleText
        self.subSettingsView.descriptionTextView.text = self.descriptionText
        self.subSettingsView.noThanksButton.setTitle(NSLocalizedString("No thanks",comment: ""), forState: UIControlState.Normal)
        self.subSettingsView.mainButton.setTitle(mainButtonText, forState: UIControlState.Normal)
        
        self.subSettingsView.mainButton.addTarget(self, action: "mainButtonAction", forControlEvents: .TouchUpInside)
        self.subSettingsView.noThanksButton.addTarget(self, action: "noThanksAction", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.subSettingsView)
    }
    
    /**
    This method defines the action that is taken when the mainButtonAction is pressed
    */
    func mainButtonAction(){}

    /**
    Method called when no thanks button is pressed, meant to be overriden by subclass
    */
    func noThanksAction() {}

}
