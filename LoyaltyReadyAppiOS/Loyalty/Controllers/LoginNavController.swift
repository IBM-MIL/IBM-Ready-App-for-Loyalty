/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/**
*  Requests phone number from user to send an SMS message containing an account confirmation number.
*/
class LoginNavController: UINavigationController {

    func dismiss(){
        self.dismiss(animated: true, completion: nil)
    }
    
    // Hiding the status bar causes odd animatioons when dismissing login flow
    override var prefersStatusBarHidden : Bool {
        return false
    }
}

