/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/// Custom UITabBarController used to creat custom additions to UITabBarController
class CustomTabBarController: RAMAnimatedTabBarController {
    /// Rectangle image of tool tip
    var toolTipBody: UIImageView?
    /// Arrow of tool tip
    var toolTipArrow: UIImageView?
    /// Label of tool tip
    var toolTipLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the accessibility labels for the tab bar items so we can test with KIF
        if let tabBarItems = self.tabBar.items {
            if tabBarItems.count == 3 {
                tabBarItems[0].accessibilityLabel = NSLocalizedString("MY REWARDS", comment: "")
                tabBarItems[1].accessibilityLabel = NSLocalizedString("DEALS", comment: "")
                tabBarItems[2].accessibilityLabel = NSLocalizedString("STATIONS", comment: "")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
    Shows the tool tip on the UITabBarController so that the arrow can sit on top of the tabbar
    */
    func showToolTipForSavedDeal(){
        hideToolTipForSavedDeal()
        
        toolTipBody = UIImageView(image: UIImage(named: "savedDealToolTip"))
        toolTipBody?
            .width(self.view.width-10)
            .height(50)
            .centerX(self.view.width/2)
            .bottom(self.tabBar.top-5)
        
        Utils.addShadowToView(toolTipBody!)
        
        self.view.addSubview(toolTipBody!)
        
        toolTipLabel = UILabel(frame: toolTipBody!.frame)
        toolTipLabel?.textAlignment = NSTextAlignment.Center
        toolTipLabel?.font = UIFont.montserratBold(18)
        toolTipLabel?.text = NSLocalizedString("SAVED TO MY DEALS!", comment: "")
        toolTipLabel?.textColor = UIColor.whiteColor()
        
        self.view.addSubview(toolTipLabel!)
        
        let rect = Utils.frameForTabInTabBar(tabBar, withIndex: 0)

        toolTipArrow = UIImageView(image: UIImage(named: "savedDealToolTipArrow"))
        toolTipArrow?
            .width(22)
            .height(11)
            .centerX(rect.width/2 + 2)
            .top(toolTipBody!.bottom)
        
        self.view.addSubview(toolTipArrow!)
    }
    
    /**
    Hides and removes the tooltip from the UITabBarController
    */
    func hideToolTipForSavedDeal(){
        toolTipBody?.removeFromSuperview()
        toolTipArrow?.removeFromSuperview()
        toolTipLabel?.removeFromSuperview()
    }
    
    func goToStationTabWithStation(station: GasStation){
        UserDataManager.sharedInstance.selectedStation = station
        selectedIndex = 2
        setSelectIndex(from: 0, to: 2)
        
        let nav = self.selectedViewController as! UINavigationController
        
        nav.popToRootViewControllerAnimated(false)
        
    }
    
    
}
