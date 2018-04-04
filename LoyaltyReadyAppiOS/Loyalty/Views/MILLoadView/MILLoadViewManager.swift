/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit


/**
*  Class that manages the creation, display, hiding, and deletion of the MILLoadView
*/
open class MILLoadViewManager: NSObject {
    
    /// The MILLoadView
    fileprivate var milLoadView : MILLoadView!
    let logger : OCLogger = OCLogger.getInstanceWithPackage("Loyalty");
    
    open class var sharedInstance : MILLoadViewManager{
        
        struct Singleton {
            static let instance = MILLoadViewManager()
        }
        return Singleton.instance
    }
    
    /**
    Function that builds and displays a MILLoadView
    */
    open func show() {
        logger.logInfoWithMessages(message:"SHOWING LOADING VIEW")
        
        
        // show alertview on main UI
        let milLoadView : MILLoadView = MILLoadView.instanceFromNib() as MILLoadView
        
        if self.milLoadView != nil{
            self.milLoadView.removeFromSuperview()
            self.milLoadView = nil
        }
        milLoadView.frame = UIApplication.shared.keyWindow!.frame
        
        milLoadView.showLoadingAnimation()
        
        self.milLoadView = milLoadView
        UIApplication.shared.keyWindow?.addSubview(milLoadView)
        
//        if root != nil{
//            root?.view.addSubview(milLoadView)
//        }else{
//            UIApplication.sharedApplication().keyWindow?.addSubview(milLoadView)
//        }
        
    }
    
    /**
    Hides the MILLoadView
    */
    open func hide(_ callback: (()->())! = nil) {
        if self.milLoadView != nil{
            logger.logInfoWithMessages(message:"HIDING LOADING VIEW")
            self.milLoadView.removeFromSuperview()
            self.milLoadView = nil
            
            if callback != nil {
                callback()
            }
        }
    }


}
