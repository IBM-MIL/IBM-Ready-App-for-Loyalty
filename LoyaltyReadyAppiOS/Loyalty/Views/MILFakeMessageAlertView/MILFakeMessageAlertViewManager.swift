/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/**
*  Class that manages the creation, display, hiding, and deletion of the MILFakeMessageAlertView
*/
open class MILFakeMessageAlertViewManager: NSObject {
    
    /// The MILFakeMessageAlertView. Private to just this class
    fileprivate var milFakeMessageAlertView : MILFakeMessageAlertView!
    /// The callback of the reload
    var callback : (()->())!

    
    
    open class var sharedInstance : MILFakeMessageAlertViewManager{
        
        struct Singleton {
            static let instance = MILFakeMessageAlertViewManager()
        }
        return Singleton.instance
    }
    
    /**
    Function that builds and displays a MILFakeMessageAlertView
    
    - parameter text:     Text to display on the MILFakeMessageAlertView
    - parameter callback: Callback function to execute when the MILFakeMessageAlertView or its reload button is tapped
    */
    func show(_ text: String!, callback: (()->())!) {
        
        // show alertview on main UI
        
        if self.milFakeMessageAlertView != nil{
            self.remove()
        }

        self.callback = callback
        self.milFakeMessageAlertView = self.buildAlert(text, callback: callback)
        
        UIApplication.shared.keyWindow?.addSubview(self.milFakeMessageAlertView)
        
        UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.milFakeMessageAlertView.setBottom(self.milFakeMessageAlertView.height)
            }, completion: { finished -> Void in
                if finished{
                    self.milFakeMessageAlertView.isUserInteractionEnabled = true
                    if callback == nil {
                        Timer.scheduledTimer(timeInterval: 3, target: self, selector: "hide", userInfo: nil, repeats: false)
                    }
                }
        })
        
    }
    
    /**
    Builds a MILFakeMessageAlertView that is initialized with the appropriate data
    
    - parameter text:     Text to display on the MILFakeMessageAlertView
    - parameter callback: Callback function to execute when the MILFakeMessageAlertView reload button is tapped
    
    - returns: An initialized MILFakeMessageAlertView
    */
    fileprivate func buildAlert(_ text: String!, callback: (()->())!)-> MILFakeMessageAlertView{
        let milFakeMessageAlertView : MILFakeMessageAlertView = MILFakeMessageAlertView.instanceFromNib() as MILFakeMessageAlertView
        milFakeMessageAlertView.setOriginX(0)
        milFakeMessageAlertView.setWidth(UIScreen.main.bounds.width)
        milFakeMessageAlertView.setBottom(0)
        milFakeMessageAlertView.setLabel(text)
        milFakeMessageAlertView.isUserInteractionEnabled = false
        milFakeMessageAlertView.setCallbackFunc(callback)
        
        var tapGesture = UITapGestureRecognizer(target: self, action: #selector(MILFakeMessageAlertViewManager.hide))
        if callback != nil {
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(MILFakeMessageAlertViewManager.reload))
        }
        milFakeMessageAlertView.addGestureRecognizer(tapGesture)
        
        return milFakeMessageAlertView
    }
    
    /**
    Hides the MILFakeMessageAlertView with an animation
    */
    open func hide() {
        if self.milFakeMessageAlertView != nil{
            self.milFakeMessageAlertView.isUserInteractionEnabled = false
            UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
                self.milFakeMessageAlertView.setBottom(0)
                }, completion: { finished -> Void in
                    if finished {
                        self.remove()
                    }
            })
        }
        
    }
    
    /**
    Removes the MILFakeMessageAlertView from its superview and sets it to nil
    */
    func remove(){
        if self.milFakeMessageAlertView != nil{
            self.milFakeMessageAlertView.removeFromSuperview()
            self.milFakeMessageAlertView = nil
        }
    }
    
    /**
    Reload function that fires when the MILFakeMessageALertView is tapped
    */
    @IBAction func reload(){
        callback()
        hide()
    }
    
}
