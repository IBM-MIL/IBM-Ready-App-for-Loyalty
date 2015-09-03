/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/// ViewController showing the loyalty card
class LoyaltyCardViewController: UIViewController {

    /// Current user
    var user: User!
    //Card frame constants
    let contractedHeight = CGFloat(204)
    let expandedHeight = CGFloat(365)
    
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var dropChevron: UIImageView!
    @IBOutlet weak var loyaltyPoints: UILabel!
    @IBOutlet weak var avaliableDeals: UILabel!
    @IBOutlet weak var rewardAlert: UIView!
    
    @IBAction func addToPassbook(sender: AnyObject) {
        PassbookUtils.showPass("loyalty", context: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = UserDataManager.sharedInstance.currentUser
        
        let tapToDismiss = UITapGestureRecognizer(target: self, action: "dismiss")
        dimView.addGestureRecognizer(tapToDismiss)
        
        if(user.loggedIn) {
            loyaltyPoints.text = String(user.profile.rewards.points)
        } else {
            loyaltyPoints.text = "0"
        }
        avaliableDeals.text = String(user.deals.count)

    }
    
    /**
    Dismiss this view controller modally
    */
    func dismiss(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func expandOnTap(recognizer:UITapGestureRecognizer) {
        if(cardView.height < contractedHeight+1) {
            UIView.animateWithDuration(0.5, animations: {
                self.dropChevron.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                self.cardView.setHeight(self.expandedHeight)
                self.view.layoutIfNeeded()
                self.dropChevron.center.y += self.expandedHeight - self.contractedHeight
                self.rewardAlert.center.y += self.expandedHeight - self.contractedHeight
            })
        }
        else {
            UIView.animateWithDuration(0.5, animations: {
                self.dropChevron.transform = CGAffineTransformMakeRotation(CGFloat(0))
                self.cardView.setHeight(self.contractedHeight)
                self.dropChevron.center.y -= self.expandedHeight - self.contractedHeight //don't use layoutIfNeeded here; it moves it up to the center of the view
                self.rewardAlert.center.y -= self.expandedHeight - self.contractedHeight
            })
        }
    }

}
