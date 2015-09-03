/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit


@objc protocol OnboardingViewControllerDelegate {
    func OnboardingDidDisappear() -> Void
}

/*
*  A UIPageViewController handler, that displays correct pages with the right content for onboarding process
*/
class OnboardingViewController: UIViewController, UIPageViewControllerDelegate {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var extendedView: UIView!
    
    /// Custom page control needed because default page control couldn't be customized in positioning or color
    @IBOutlet weak var pageControl: UIPageControl!
    
    let pageTitles = [NSLocalizedString("Claim Deals", comment: ""), NSLocalizedString("Find Stations", comment: ""), NSLocalizedString("Earn Points", comment: "")]
    let pageSubtitles = [NSLocalizedString("Browse and save personalized deals", comment: ""),NSLocalizedString("Quickly find the closest gas stations", comment: ""),NSLocalizedString("Get rewarded for every dollar you spend!", comment: "")]
    let imageBaseNames = ["walkthrough_", "ra5 intro map_", "earnpoints 2_"]
    let imageRanges = [(0, 119), (0, 119), (0, 119)]

    var pageViewController: UIPageViewController!
    var currentPageInstance: PageContentViewController?
    
    var delegates : [OnboardingViewControllerDelegate] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set color to be transparent, but not affect child views
        self.transparentView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.75)
        reset()
        
        // Hide before resizing happens
        self.pageViewController.view.alpha = 0
        self.extendedView.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Page View Controller wasn't adjusting to the container's size, so we do it manually
        self.pageViewController.view.frame = self.containerView.frame
        
        // Hiding views and then showing views makes the resizing smooth
        UIView.animateWithDuration(0.4, animations: {
            self.pageViewController.view.alpha = 1.0
            self.extendedView.alpha = 1.0
        }, completion: { (value: Bool) in
            // Workaround for initial first page load because we can't start animations 
            // until view are visible (alpha = 1)
            if let vc = self.currentPageInstance {
                vc.onboardImageView.startAnimating()
            }
        })
    }
    
    override func viewWillDisappear(animated: Bool) {

        self.tellDelegatesOnBoardingDisappeared()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
    Method sets up the page view controller
    */
    func reset() {
        
        pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("OnboardingPageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        for view in self.pageViewController.view.subviews {
            if let thisView = view as? UIScrollView {
                thisView.delegate = self
            }
        }
        
        let pageContentViewController = self.viewControllerAtIndex(0)
        self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)

        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
    }

    
    // MARK: UIPageViewControllerDelegate
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            // Method used to keep a pageControl updated with current index
            let currentVC = pageViewController.viewControllers![0] as! PageContentViewController
            if let index = currentVC.pageIndex {
                self.pageControl.currentPage = index
            }
        }
        
    }
    
    
    func tellDelegatesOnBoardingDisappeared(){
        
        for delegate in self.delegates {
            
            delegate.OnboardingDidDisappear()
            
        }
        
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    
    
    // MARK: UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageContentViewController).pageIndex!
        if index <= 0 {
            return nil
        }
        
        index--
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! PageContentViewController).pageIndex!
        index++
        
        if index >= self.imageBaseNames.count {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        
        if (self.pageTitles.count == 0 || index >= self.pageTitles.count) {
            return nil
        }
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageContentViewController") as! PageContentViewController
        
        // Load new data for each page
        pageContentViewController.imageAnimationName = self.imageBaseNames[index]
        pageContentViewController.imageCountRange = self.imageRanges[index]
        pageContentViewController.titleText = self.pageTitles[index]
        pageContentViewController.subtitleText = self.pageSubtitles[index]
        pageContentViewController.pageIndex = index
        
        self.currentPageInstance = pageContentViewController
        return pageContentViewController
    }
    
}

extension OnboardingViewController: UIScrollViewDelegate {
    
    // The following scrollView methods disable the bounce almost completely
    // There is still an edge case when you swipe fast in a certain way
    
    func scrollViewDidScroll(scrollView: UIScrollView) {

        if (0 == self.pageControl.currentPage && scrollView.contentOffset.x < scrollView.bounds.size.width) {
            scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
        }
        if (self.pageControl.currentPage == self.pageTitles.count - 1 && scrollView.contentOffset.x > scrollView.bounds.size.width) {
            scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
        }

    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if (0 == self.pageControl.currentPage && scrollView.contentOffset.x <= scrollView.bounds.size.width) {
            targetContentOffset.memory = CGPointMake(scrollView.bounds.size.width, 0);
        }
        if (self.pageControl.currentPage == self.pageTitles.count - 1 && scrollView.contentOffset.x >= scrollView.bounds.size.width) {
            targetContentOffset.memory = CGPointMake(scrollView.bounds.size.width, 0);
        }
    }
    
}
