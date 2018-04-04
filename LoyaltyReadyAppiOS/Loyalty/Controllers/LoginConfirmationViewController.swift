/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 3015. All Rights Reserved.
*/

import UIKit

/**
*  Displays SMS Alert containing confirmation number; allows user to input number
*/
class LoginConfirmationViewController: LoyaltyUIViewController {
    /// UITextField containing the first digit of the confirmation code
    @IBOutlet var codeField1: UITextField!
    /// UITextField containing the second digit of the confirmation code
    @IBOutlet var codeField2: UITextField!
    /// UITextField containing the third digit of the confirmation code
    @IBOutlet var codeField3: UITextField!
    /// UITextField containing the fourth digit of the confirmation code
    @IBOutlet var codeField4: UITextField!
    /// UILabel containing the instructions for the user, including the phone number the confirmation code was sent to
    @IBOutlet var instructionsLabel: UILabel!
    /// String containing the phone number the user provided
    var phoneNumberString: String!
    //Button to verify device after entering confirmation code
    @IBOutlet weak var verifyDeviceButton: UIButton!
    /// Raw phone number string
    var rawPhoneNumber: String!
    /// Confirmation number string entered by the user
    var confirmationString: String!
    /// View showing user that they have entered an incorrect confirmation code
    @IBOutlet weak var incorrectCodeView: UIView!
    /// Authenticated user
    var user: User!
    /// User stations
    var stations: [GasStation]!
    let logger : OCLogger = OCLogger.getInstanceWithPackage("Loyalty");
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let instructionLabelText = instructionsLabel.text {
            instructionsLabel.text = instructionLabelText + phoneNumberString
        }
        verifyDeviceButton.isUserInteractionEnabled = false //disable initially
        verifyDeviceButton.setBackgroundColorForState(UIColor.grayLoyalty(), forState: UIControlState())
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        codeField1.becomeFirstResponder()
        MILFakeMessageAlertViewManager.sharedInstance.show(NSLocalizedString("Your confirmation code is 1234.", comment: ""), callback: tappedAlert) //show SMS alert
        codeField1.tintColor = UIColor.blackLoyalty() //black text cursor
        codeField2.tintColor = UIColor.blackLoyalty()
        codeField3.tintColor = UIColor.blackLoyalty()
        codeField4.tintColor = UIColor.blackLoyalty()

    }
    
    /**
    Method called when user taps verify device button
    
    - parameter sender:
    */
    @IBAction func tappedVerifyDevice(_ sender: AnyObject) {
        if (confirmationString == "1234") {
            //now move to next VC
            incorrectCodeView.isHidden = true
            let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "finish") as! LoginFinishViewController
            destinationVC.rawPhoneNumber = rawPhoneNumber
            destinationVC.user = user
            destinationVC.stations = stations
            self.navigationController?.pushViewController(destinationVC, animated: true)
        } else {
            incorrectCodeView.isHidden = false
            codeField1.text = ""
            codeField2.text = ""
            codeField3.text = ""
            codeField4.text = ""
            codeField1.becomeFirstResponder()
        }

    }
    
    /**
    Callback method called after the MILFakeMessageAlertViewManager completes showing
    */
    func tappedAlert(){
        logger.logInfoWithMessages(message:"User tapped MILFakeMessageAlertView!")
    }
    
    @IBAction func dismissToMain(_ sender: AnyObject) {

        if let nav = navigationController as? LoginNavController {
            nav.dismiss()
            codeField1.resignFirstResponder()
            codeField2.resignFirstResponder()
            codeField3.resignFirstResponder()
            codeField4.resignFirstResponder()
        }
    }
    


}

extension LoginConfirmationViewController: UITextFieldDelegate {
    /**
    Method to restrict codeField1, codeField2, codeField3, and codeField4 to numerical characters, and allow edit/backspace between fields as a 4 digit string
    
    - parameter textField: text field in question
    - parameter range:     range of characters to be changed
    - parameter string:    replacement string
    
    - returns: boolean representing whether or not the change will be made
    */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var currentField: UITextField!
        var nextField: UITextField!
        var previousField: UITextField!
        
        switch textField.tag {
        case 1:
            currentField = codeField1
            nextField = codeField2
        case 2:
            currentField = codeField2
            nextField = codeField3
            previousField = codeField1
        case 3:
            currentField = codeField3
            nextField = codeField4
            previousField = codeField2
        case 4:
            currentField = codeField4
            previousField = codeField3
        default:
            logger.logInfoWithMessages(message:"unknown text field!")
        }
        incorrectCodeView.isHidden = true
        
        let insertStringLength = string.characters.count
        if(insertStringLength == 0){ //backspace entered
            currentField.text = ""
            if (previousField != nil){
                previousField.becomeFirstResponder()
                //not last field, disable button
//                verifyDeviceButton.userInteractionEnabled = false
//                verifyDeviceButton.setBackgroundColorForState(UIColor.grayLoyalty(), forState: .Normal)
            }
        }
        else {  //actual character entered
            let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789").inverted
            let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
            if (replacementStringIsLegal) { //check if numerical
                if (currentField.tag == 4){
                    currentField.resignFirstResponder()
                    currentField.text = string
                }
                else {
                    if (!currentField.text!.isEmpty && currentField.text != " ") { //if current field is not empty and not " ", set next field
                        nextField.becomeFirstResponder()
                        if (currentField.tag == 3){ //if all fields filled, enable button and hide keyboard
                           nextField.resignFirstResponder()
//                            verifyDeviceButton.userInteractionEnabled = true
//                            verifyDeviceButton.setBackgroundColorForState(UIColor.purpleLoyalty(), forState: .Normal)
                        }
                        nextField.text = string
                    }
                    else {
                        currentField.text = string //if current field is empty or " ", set current field text
                    }
                }
                }
            }
        self.checkIfValid()
        

        //always return no since we are manually changing the text field
        return false
        }
    
    
    
    
    /**
    Method called when a textField begins editing
    
    - parameter textField: textField that began editing
    */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text == ""){ //add " " space to all empty fields to allow for backspacing
            textField.text = " "
        }
    }
    
    /**
    Method to check if all 4 digits are entered
    */
    func checkIfValid() {
        if ((codeField1.text != "" && codeField1.text != " ") && (codeField2.text != "" && codeField2.text != " ") && (codeField3.text != "" && codeField3.text != " ") && (codeField4.text != "" && codeField4.text != " ")) {
            confirmationString = codeField1.text! + codeField2.text! + codeField3.text! + codeField4.text!
            verifyDeviceButton.isUserInteractionEnabled = true
            verifyDeviceButton.setBackgroundColorForState(UIColor.purpleLoyalty(), forState: UIControlState())
        } else {
            verifyDeviceButton.isUserInteractionEnabled = false
            verifyDeviceButton.setBackgroundColorForState(UIColor.grayLoyalty(), forState: UIControlState())
        }
    }
   
}
