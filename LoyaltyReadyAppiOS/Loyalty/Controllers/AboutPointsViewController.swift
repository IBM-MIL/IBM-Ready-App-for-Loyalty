/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

class AboutPointsViewController: UIViewController {

    @IBOutlet weak var firstParagraphLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.firstParagraphLabel.sizeToFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonTapped(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }

}
