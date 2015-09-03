/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

class EditProfileViewController: UIViewController, UIPageViewControllerDelegate {
    
    @IBOutlet weak var pageControl: UIPageControl!
    var pageViewController: UIPageViewController!
    var startingIndex = 0
    var pageCount = 4

    override func viewDidLoad() {
        super.viewDidLoad()
        resetPageViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetPageViewController() {
        
        pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageController") as! UIPageViewController
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        let pageContentViewController = self.viewControllerAtIndex(self.startingIndex)
        self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        self.pageControl.currentPage = self.startingIndex
        
        self.pageViewController.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 60)
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
    }
    
    @IBAction func exitFlow(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
    Method to manually navigate to a page in code
    
    - parameter index:     page index to go to
    - parameter fromIndex: page index coming from
    */
    func navigateToIndex(index: Int, fromIndex: Int, animated: Bool) {
        
        // disable view when doing a manual transition to avoid weird UIPageViewController behavior
        self.pageViewController?.view.userInteractionEnabled = false
        
        // need to set manually when manually navigating
        self.pageControl.currentPage = index
        
        let viewController = viewControllerAtIndex(index)
        let selectedViewControllers = [viewController!] as [AnyObject]
        self.pageViewController.setViewControllers(selectedViewControllers as? [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: animated) { (done: Bool) -> Void in
            self.pageViewController?.view.userInteractionEnabled = true
        }
    }
    
    // MARK: UIPageViewControllerDelegate
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            // Method used to keep a pageControl updated with current index
            
            var index = 0
            if let subSettings = pageViewController.viewControllers![0] as? SubSettingsViewController {
                index = subSettings.pageIndex
            }
            self.pageControl.currentPage = index
        }
        
    }

}

extension EditProfileViewController: UIPageViewControllerDataSource {
    
    // MARK: UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = 0
        if let subSettings = viewController as? SubSettingsViewController {
            index = subSettings.pageIndex
        }

        if index <= 0 {
            return nil
        }
        
        index--
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = 0
        if let subSettings = viewController as? SubSettingsViewController {
            index = subSettings.pageIndex
        }
        index++
        
        if index >= self.pageCount {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        
        if index >= self.pageCount {
            return nil
        }
        
        switch(index) {
        case 0:
            let interestsVC = Utils.vcWithNameFromStoryboardWithName("InterestsViewController", storyboardName: "Settings") as! InterestsViewController
            interestsVC.editProfileVCReference = self
            return interestsVC
        case 1:
            let twitterSyncVC = Utils.vcWithNameFromStoryboardWithName("SyncTwitterViewController", storyboardName: "Settings") as! SyncTwitterViewController
            twitterSyncVC.pageIndex = index
            twitterSyncVC.editProfileVCReference = self
            return twitterSyncVC
        case 2:
            let enableNotificationsVC = Utils.vcWithNameFromStoryboardWithName("EnableNotificationsViewController", storyboardName: "Settings") as! EnableNotificationsViewController
            enableNotificationsVC.pageIndex = index
            enableNotificationsVC.editProfileVCReference = self
            return enableNotificationsVC
        case 3:
            let enableLocationVC = Utils.vcWithNameFromStoryboardWithName("EnableLocationViewController", storyboardName: "Settings") as! EnableLocationViewController
            enableLocationVC.pageIndex = index
            enableLocationVC.editProfileVCReference = self
            return enableLocationVC
        default:
            return nil
        }
        
    }
    
}
