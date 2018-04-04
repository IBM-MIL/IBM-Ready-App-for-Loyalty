/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import MapKit

/** Enum constants **/
enum MqaLabel: String {
    case milbuild = "Milbuild"
}

enum MyRewards: String {
    case cheapest = "CHEAPEST"
    case closest = "CLOSEST"
    case saveddeals = "SAVED DEALS"
}

enum Deals: String {
    case recommended = "RECOMMENDED"
    case nearme = "NEAR ME"
    case offers = "offers"
    case offersid = "offersId"
    case create = "CREATE ACCOUNT"
    case fruitcup = "$1.99 Fruit Cup"
    case sportsdrink = "25% Off Sports Drinks"
    case pizza = "$5.99 Large Pizza"
    case hotdog = "3 for $3"
    case phonenumber = "Phone Number"
    case getcode = "RECEIVE CODE"
    case verify = "VERIFY DEVICE"
    case redeem = "START SAVING!"
    case back = "x"
}

enum Stations: String {
    case search = "Search"
    case list = "listview"
    case table = "tableview"
    case map = "mapview"
    case toggle = "togglebutton"
}

enum TabLabel: String {
    case rewards = "MY REWARDS"
    case deals = "DEALS"
    case stations = "STATIONS"
}

enum CreateAccount: String {
    case recivecode = "RECEIVE CODE"
    case phonenumber = "Phone Number"
    case close = "x"
    case invalidlogin = "Incorrect login!"
    case invalidnumber = "Invalid number!"
}

enum DemoMode : String {
    case cancel = "Cancel"
    case ok = "OK"
}

enum OnBoard: String {
    case skip = "SKIP"
    case done = "DONE"
    case deals = "Claim Deals"
    case stations = "Find Stations"
    case points = "Earn Points"
    case reached = "Goal Reached"
}

extension KIFUITestActor {
    func printSubViews(subview : [UIView]) {
        print ("***********************")
        print ("parent view has subview: ")
        print ("***********************")
        for view in subview {
            print ("view - \(view)")
            print ("***********************")
            printSubViews(view.subviews )
        }
    }
    
    func validateViewExists(name : String) -> UIView {
        let view : UIView = tester().waitForViewWithAccessibilityLabel(name) as UIView
        return view
    }
    
    func doesViewExist(name: String) -> Bool {
        let view : UIView? = tester().waitForViewWithAccessibilityLabel(name) as UIView
        if let _ = view {
            return true
        } else {
            return false
        }
        
    }
    
    func waitForViewToLoad(seconds : Int) {
        self.waitForTimeInterval(NSTimeInterval(seconds))
    }
    
    func waitForMapViewWithAccessibilityLabelToLoad(accessibilityLabel : String, print : Bool) {
        
        let view : MKMapView = validateViewExists(accessibilityLabel) as! MKMapView
        if print { Swift.print("done sleeping waiting for map.") }
        XCTAssertNotNil(view, "map view should not be nil")
        if print { Swift.print("subviews \(view.subviews)") }
        var annotations = view.annotations
        while annotations.count == 0 {
            self.waitForTimeInterval(NSTimeInterval(10))
            annotations = (validateViewExists(Stations.map.rawValue) as! MKMapView).annotations
        }
        if print { Swift.print("annotations \(view.annotations)") }
    }
    
    /****   methods for beforeAll setup method. ****/
    func clearPopupsNoAccount(closeOnboardingView: Bool) {
        clearPopupsAccount(closeOnboardingView)
        tester().closeAccountWindow()
    }
    
    func clearPopupsAccount(closeOnboardingView: Bool) {
        //This one is for the notifications prompt
        sleep(1)
        tester().acknowledgeSystemAlert()
        
        if (closeOnboardingView) {
            var error :NSError?
            var skip: Bool
            do {
                try tester().tryFindingViewWithAccessibilityLabel(OnBoard.skip.rawValue)
                skip = true
            } catch let error1 as NSError {
                error = error1
                skip = false
            }
            if let _ = error {
                print ("onboarding window already closed, doing nothing.")
            } else {
                tester().tapViewWithAccessibilityLabel(OnBoard.skip.rawValue)
            }
        }
    }
    
    
    
    func closeAccountWindow() {
        var error : NSError?
        
        do {
            try tester().tryFindingTappableViewWithAccessibilityLabel(
                CreateAccount.close.rawValue)
        } catch let error1 as NSError {
            error = error1
        }
        if let _ = error {
            print ("Couldn't find close")
            print ("Error: \(error)")
        } else {
            tester().tapViewWithAccessibilityLabel(CreateAccount.close.rawValue)
            print ("found close! ")
        }
    }
    
    func clearDemoMode() {
        tester().waitForViewToLoad(1)
        var error : NSError?
        do {
            try tester().tryFindingViewWithAccessibilityLabel(DemoMode.cancel.rawValue)
        } catch let error1 as NSError {
            error = error1
        }
        if let _ = error {
            print ("DemoMode popup not visible, doing nothing.")
        } else {
            tester().tapViewWithAccessibilityLabel(DemoMode.cancel.rawValue)
        }
    }
    
    func closeLoginWindow() {
        clearDemoMode()
        tester().tapViewWithAccessibilityLabel(CreateAccount.close.rawValue)
        tester().waitForViewToLoad(1)
    }
    
    func openRewardsTab() {
        let mainScreenBounds = UIScreen.mainScreen().bounds
        tester().tapScreenAtPoint(CGPointMake(10, mainScreenBounds.size.height - 10))
    }
    func openDealsTab() {
        let mainScreenBounds = UIScreen.mainScreen().bounds
        tester().tapScreenAtPoint(CGPointMake(mainScreenBounds.size.width / 2, mainScreenBounds.size.height - 10))
    }
    func openStationsTab() {
        let mainScreenBounds = UIScreen.mainScreen().bounds
        tester().tapScreenAtPoint(CGPointMake(mainScreenBounds.size.width - 10, mainScreenBounds.size.height - 10))
    }
}
