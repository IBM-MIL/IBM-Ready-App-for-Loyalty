/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/*
*  View Controller that handles UI for onboarding pages
*/
class PageContentViewController: LoyaltyUIViewController {
    
    @IBOutlet weak var onboardImageView: UIImageView!
    @IBOutlet weak var pageTitleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var pageIndex: Int?
    var titleText: String!
    var subtitleText: String!
    var imageAnimationName: String!
    var imageCountRange: (Int, Int)!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.pageTitleLabel.text = self.titleText
        self.subtitleLabel.text = self.subtitleText
        
        // If last page, show donw button instead of skip button
        if pageIndex == 2 {
            self.skipButton.isHidden = true
            self.doneButton.isHidden = false
        } else {
            self.skipButton.isHidden = false
            self.doneButton.isHidden = true
        }
        
        // Animating this way allows us to limit repeat count to 1
        self.onboardImageView.createImageAnimation(self.imageAnimationName, range: self.imageCountRange)
        self.onboardImageView.animationRepeatCount = 1
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.onboardImageView.startAnimating()
    }
    
   
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.onboardImageView.stopAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func skipOnboarding(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishOnboarding(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
