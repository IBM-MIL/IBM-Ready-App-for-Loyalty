/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

class InterestCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundCellView: UIView!
    @IBOutlet weak var interestLabel: UILabel!
    
    /**
    This method changes the background color of the interests collection view cell to grayLightLoyalty. It also sets the cell to be unselected.
    */
    func setDeselected(){
        self.backgroundCellView.backgroundColor = UIColor.grayLightLoyalty()
        self.interestLabel.textColor = UIColor.blackLoyalty()
        self.selected = false
    }
    
    /**
    THis method changes the background color of the interests collection view cell to tealLoyalty. It also sets the cell to be selected
    */
    func setSelected(){
        self.backgroundCellView.backgroundColor = UIColor.tealLoyalty()
        self.interestLabel.textColor = UIColor.whiteColor()
        self.selected = true
    }
    
    /**
    Method to add interests to a Set, updating the user model
    */
    func addInterest() {
        let user = UserDataManager.sharedInstance.currentUser
        user.interests.insert(self.interestLabel.text!)
    }
    
    /**
    Method to remove interests from a Set, updating the user model
    */
    func removeInterest() {
        let user = UserDataManager.sharedInstance.currentUser
        user.interests.remove(self.interestLabel.text!)
    }
    
}
