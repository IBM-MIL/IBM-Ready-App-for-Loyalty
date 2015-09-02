/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

class TestDealsView: KIFTestCase {
    override func beforeAll() {
        tester().clearPopupsNoAccount(true)
        tester().openDealsTab()
    }
    
    func test0SwitchToNearMeDeals() {
        tester().testSwitching(Deals.nearme.rawValue)
    }
    
    func test1NearMeContainsDeals() {
        tester().containsDeals()
    }
    
    func test2SwitchToRecommendedDeals() {
        tester().testSwitching(Deals.recommended.rawValue)
    }
    
    
    func test3RecommendedNotContainsDeals() {
        let view = tester().waitForViewWithAccessibilityLabel(Deals.create.rawValue)
        XCTAssertNotNil(view, "Should have a button that asks us to log in.")
    }
    
    func test4SeeDetailsOfAnonymousNearMeDeals() {
        tester().testSwitching(Deals.nearme.rawValue)
        
        let oatmealBar : UILabel = tester().waitForViewWithAccessibilityLabel(Deals.fruitcup.rawValue) as! UILabel
        oatmealBar.tap()
        tester().validateDetailsPage(Deals.fruitcup.rawValue)
        tester().clickBackFromDealDetailsPage()
        tester().waitForViewToLoad(2)
        
        let pizza : UILabel = tester().waitForViewWithAccessibilityLabel(Deals.pizza.rawValue) as! UILabel
        pizza.tap()
        tester().validateDetailsPage(Deals.pizza.rawValue)
        tester().clickBackFromDealDetailsPage()
    }
}

public extension KIFUITestActor {
    
    /**  test helper methods **/
    func testSwitching(clickableTabLabel : String) {
        tester().tapViewWithAccessibilityLabel(clickableTabLabel)
    }
    
    func containsDeals() {
        let view2 : UICollectionView = tester().waitForViewWithAccessibilityLabel(Deals.offers.rawValue) as! UICollectionView
        XCTAssertNotNil(view2, "Table view should not be nil")
        XCTAssertNotEqual(view2.visibleCells().count, 0, "Should have more than a single goal.")
    }
    
    func validateDetailsPage(deal : String) {
        let highlights = tester().validateViewExists("HIGHLIGHTS")
        let highlightsParent : UIView? = highlights.superview
        let deal = tester().validateViewExists(deal)
        let dealsParent : UIView? = deal.superview
        
        XCTAssertNotNil(deal, "Potentially loaded wrong deal")
        XCTAssertNotNil(highlights, "Should have a highlights label")
        XCTAssertNotNil(tester().validateViewExists("FINE PRINT"), "Shoudl have a fine print label")
        
        let plusImageSize = CGSize(width: 25, height: 25)
        if let parent = highlightsParent {
            let children : [UIView] = parent.subviews 
            for child in children {
                if child is UIImageView {
                    XCTAssertNotNil((child as! UIImageView).image, "Should not contain a null image")
                } else if child is UIButton {
                    let button = child as! UIButton
                    if let imageSize = button.currentImage?.size {
                        XCTAssertEqual(imageSize, plusImageSize, "Initial image for button was not the plus sign.")
                    }
                    button.tap()
                    tester().closeLoginWindow()
                }
            }
        }
        //Check for expiration date.
        if let parent = dealsParent {
            let children : [UIView] = parent.subviews 
            var hasExpiration = false
            for child in children {
                if (child is UILabel) {
                    if let text = (child as! UILabel).text {
                        if text.hasPrefix("Expires") {
                            hasExpiration = true
                        }
                    }
                }
            }
            XCTAssertTrue(hasExpiration, "Could not find an expiration date in this deal details.")
        }
    }
    
    func clickBackFromDealDetailsPage() {
        //Now we'll tap the back button and tap another guy
        let backbutton : UILabel = tester().waitForViewWithAccessibilityLabel("DEAL DETAILS") as! UILabel
        backbutton.tap()
        let parent : UIView? = backbutton.superview
        if let parent = parent {
            let children : [UIView] = parent.subviews 
            for child in children {
                if child is UIButton {
                    child.tap()
                }
            }
        }
    }
}