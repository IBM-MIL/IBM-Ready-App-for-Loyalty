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
        self.subSettingsView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.subSettingsView.titleLabel.text = self.titleText
        self.subSettingsView.descriptionTextView.text = self.descriptionText
        self.subSettingsView.noThanksButton.setTitle(NSLocalizedString("No thanks",comment: ""), for: UIControlState())
        self.subSettingsView.mainButton.setTitle(mainButtonText, for: UIControlState())
        
        self.subSettingsView.mainButton.addTarget(self, action: #selector(SubSettingsViewController.mainButtonAction), for: .touchUpInside)
        self.subSettingsView.noThanksButton.addTarget(self, action: #selector(SubSettingsViewController.noThanksAction), for: .touchUpInside)
        
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
