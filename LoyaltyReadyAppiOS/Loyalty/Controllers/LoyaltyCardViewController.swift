/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

// used to determine if user is on an ipad or an iphone
enum UIUserInterfaceIdiom : Int {
    case unspecified
    
    case phone // iPhone and iPod touch style UI
    case pad // iPad style UI
}

/// ViewController showing the loyalty card
class LoyaltyCardViewController: LoyaltyUIViewController {
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
    
    @IBAction func addToPassbook(_ sender: AnyObject) {
        PassbookUtils.showPass("loyalty", context: self)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.dropChevron.isHidden = true
        }
        user = UserDataManager.sharedInstance.currentUser
        
        let tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(LoyaltyCardViewController.dismiss as (LoyaltyCardViewController) -> () -> ()))
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
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func expandOnTap(_ recognizer:UITapGestureRecognizer) {
        if(cardView.height < contractedHeight+1) {
            UIView.animate(withDuration: 0.5, animations: {
                self.dropChevron.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
                self.cardView.setHeight(self.expandedHeight)
                self.view.layoutIfNeeded()
                self.dropChevron.center.y += self.expandedHeight - self.contractedHeight
                self.rewardAlert.center.y += self.expandedHeight - self.contractedHeight
            })
        }
        else {
            UIView.animate(withDuration: 0.5, animations: {
                self.dropChevron.transform = CGAffineTransform(rotationAngle: CGFloat(0))
                self.cardView.setHeight(self.contractedHeight)
                self.dropChevron.center.y -= self.expandedHeight - self.contractedHeight //don't use layoutIfNeeded here; it moves it up to the center of the view
                self.rewardAlert.center.y -= self.expandedHeight - self.contractedHeight
            })
        }
    }

}
