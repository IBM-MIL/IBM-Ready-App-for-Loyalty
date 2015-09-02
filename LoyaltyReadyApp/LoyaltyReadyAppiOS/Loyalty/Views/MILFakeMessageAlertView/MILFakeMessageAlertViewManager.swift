/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/**
*  Class that manages the creation, display, hiding, and deletion of the MILFakeMessageAlertView
*/
public class MILFakeMessageAlertViewManager: NSObject {
    
    /// The MILFakeMessageAlertView. Private to just this class
    private var milFakeMessageAlertView : MILFakeMessageAlertView!
    /// The callback of the reload
    var callback : (()->())!

    
    
    public class var sharedInstance : MILFakeMessageAlertViewManager{
        
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
    func show(text: String!, callback: (()->())!) {
        
        // show alertview on main UI
        
        if self.milFakeMessageAlertView != nil{
            self.remove()
        }

        self.callback = callback
        self.milFakeMessageAlertView = self.buildAlert(text, callback: callback)
        
        UIApplication.sharedApplication().keyWindow?.addSubview(self.milFakeMessageAlertView)
        
        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.milFakeMessageAlertView.setBottom(self.milFakeMessageAlertView.height)
            }, completion: { finished -> Void in
                if finished{
                    self.milFakeMessageAlertView.userInteractionEnabled = true
                    if callback == nil {
                        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "hide", userInfo: nil, repeats: false)
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
    private func buildAlert(text: String!, callback: (()->())!)-> MILFakeMessageAlertView{
        let milFakeMessageAlertView : MILFakeMessageAlertView = MILFakeMessageAlertView.instanceFromNib() as MILFakeMessageAlertView
        milFakeMessageAlertView.setOriginX(0)
        milFakeMessageAlertView.setWidth(UIScreen.mainScreen().bounds.width)
        milFakeMessageAlertView.setBottom(0)
        milFakeMessageAlertView.setLabel(text)
        milFakeMessageAlertView.userInteractionEnabled = false
        milFakeMessageAlertView.setCallbackFunc(callback)
        
        var tapGesture = UITapGestureRecognizer(target: self, action: "hide")
        if callback != nil {
            tapGesture = UITapGestureRecognizer(target: self, action: "reload")
        }
        milFakeMessageAlertView.addGestureRecognizer(tapGesture)
        
        return milFakeMessageAlertView
    }
    
    /**
    Hides the MILFakeMessageAlertView with an animation
    */
    public func hide() {
        if self.milFakeMessageAlertView != nil{
            self.milFakeMessageAlertView.userInteractionEnabled = false
            UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
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
