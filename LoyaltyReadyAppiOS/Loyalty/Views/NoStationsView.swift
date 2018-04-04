/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/**
*  Protocol to allow classes instantiating NoStationsView to use the button action on the NoStationsView
*/
protocol NoStationsActionDelegate {
    func refineSearchAction()
}

/**
*  View is basically an error view when the stations filters leave no results
*/
class NoStationsView: UIView {
    
    var delegate: NoStationsActionDelegate?

    class func instanceFromNib() -> NoStationsView {
        return UINib(nibName: "NoStationsView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! NoStationsView
    }
    
    @IBAction func refineSearch(_ sender: AnyObject) {
        
        if let delegate = self.delegate {
            delegate.refineSearchAction()
        }
        
    }
    

}
