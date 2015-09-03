/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/*
*  View Controller that handles UI for onboarding pages
*/
class PageContentViewController: UIViewController {
    
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
            self.skipButton.hidden = true
            self.doneButton.hidden = false
        } else {
            self.skipButton.hidden = false
            self.doneButton.hidden = true
        }
        
        // Animating this way allows us to limit repeat count to 1
        self.onboardImageView.createImageAnimation(self.imageAnimationName, range: self.imageCountRange)
        self.onboardImageView.animationRepeatCount = 1
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.onboardImageView.startAnimating()
    }
    
   
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.onboardImageView.stopAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func skipOnboarding(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func finishOnboarding(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
