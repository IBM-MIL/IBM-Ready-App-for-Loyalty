//
//  MILNavBarToolTip.swift
//  Loyalty
//
//  Created by Alex Buck on 7/15/15.
//  Copyright (c) 2015 ibm. All rights reserved.
//

import UIKit

class MILNavBarToolTip: UIView {
    var kBackgroundAlpha : CGFloat = 0.8
    var kArrowAlpha : CGFloat = 0.9
    var toolTipArrowImageView : UIImageView!
    var isShown = false
    var actionButton : UIButton!
    
    /**
    This method sets up the tool tip with the text parameter and the navBarButtonFrame to correctly place the arrow in the right spot
    */
    func setUp(_ text : String, navBarButtonFrameCenter : CGFloat){
        self.alpha = 0.0
        self.backgroundColor = UIColor.clear
        
        let backgroundColorView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        backgroundColorView.backgroundColor = UIColor.purpleLoyalty()
        backgroundColorView.alpha = kBackgroundAlpha
        self.addSubview(backgroundColorView)
        
        let toolTipLabel = UILabel(frame: CGRect(x: 12, y: 0, width: self.frame.size.width - 24 , height: self.frame.size.height))
        toolTipLabel.text = text
        toolTipLabel.font = UIFont.montserratRegular(13)
        toolTipLabel.textColor = UIColor.white
        toolTipLabel.numberOfLines = 0
        self.addSubview(toolTipLabel)
        
        self.actionButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        self.actionButton.backgroundColor = UIColor.clear
        self.actionButton.addTarget(self, action: #selector(MILNavBarToolTip.toolTipTouched), for: UIControlEvents.touchUpInside)
        self.addSubview(self.actionButton)
        
        let arrowUpImage = UIImage(named: "tooltip-arrow-up")
        self.toolTipArrowImageView = UIImageView(image: arrowUpImage)
        self.toolTipArrowImageView.alpha = kArrowAlpha
        self.toolTipArrowImageView.frame = CGRect(x: 0,y: -8, width: 20, height: 8)
        self.toolTipArrowImageView.center.x = navBarButtonFrameCenter
        self.addSubview(self.toolTipArrowImageView)
    }
    
    /**
    This method is called when the tool tip is touched
    */
    func toolTipTouched(){
       self.hide()
    }
    
    /**
    This method shows the tooltip after the time defined in the delay parameter
    */
    func showWithTimeDelay(_ delay : TimeInterval){
        Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(MILNavBarToolTip.show), userInfo: nil, repeats: false)
    }
    
    /**
    This method shows the tool tip if it isn't currently shown
    */
    func show(){
        if(self.isShown == false){
            UIView.animate(withDuration: 0.5, animations: {
                self.alpha = 1.0
            })
            self.isShown = true
        }
    }
    
    /**
    This method hides the tool tip if it is currently shown
    */
    func hide(){
        if(self.isShown == true){
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
            })
            self.isShown = false
        }
    }

}
