/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

class TestxLogin: KIFTestCase {
    override func beforeAll() {
        tester().clearPopupsNoAccount(true)
    }
    
    override func beforeEach() {
        tester().openDealsTab()
    }
    
    func test0failLogin() {
        tester().waitForViewToLoad(20)
        tester().getToAccountLoginPage()
        
        //bad phone number...last number is off by one.
        let phoneTextField = tester().validateViewExists(CreateAccount.phonenumber.rawValue).superview as! UITextField

        tester().tapDigits(["5","1","2","8","6","7","5","3","0","8"])
        tester().tapViewWithAccessibilityLabel(Deals.getcode.rawValue)
        tester().waitForViewToLoad(2)
        
        let errorLabel = tester().validateViewExists(CreateAccount.invalidlogin.rawValue) as! UILabel
        XCTAssertNotNil(errorLabel, "There should have been an error label that shows up.")
        var text = errorLabel.text
        if let actualText = text {
            XCTAssertEqual(actualText, CreateAccount.invalidlogin.rawValue, "Error label not correct")
        } else {
          XCTAssertFalse(true, "Error label either did not appear or did not contain the expected error message.")
        }

        phoneTextField.text = ""
        phoneTextField.tap()
        
        //When we type an invalid number the getcode button doesnt enable but we should still see a warning.
        tester().tapDigits(["5","5","5","5","5","5","5","5","5","5"])
        
        XCTAssertNotNil(errorLabel, "There should have been an error label that shows up.")
        text = errorLabel.text
        if let actualText = text {
            XCTAssertEqual(actualText, CreateAccount.invalidnumber.rawValue, "Error label not correct")
        } else {
            XCTAssertFalse(true, "Error label either did not appear or did not contain the expected error message.")
        }
        phoneTextField.text = ""
        phoneTextField.tap()
        
        //Basically reseting the main view before the next test.
        tester().closeLoginWindow()
        tester().testSwitching(Deals.nearme.rawValue)
    }
    
    func test1createAccount() {
        tester().getToAccountLoginPage()
        
        //This is the only valid phone number: 512-867-5309
        tester().tapDigits(["5","1","2","8","6","7","5","3","0","9"])
        tester().tapViewWithAccessibilityLabel(Deals.getcode.rawValue)
        
        tester().waitForViewToLoad(1)
        tester().tapDigits(["1","2","3","4"])
        tester().tapViewWithAccessibilityLabel(Deals.verify.rawValue)
        tester().waitForViewToLoad(5)
        tester().tapViewWithAccessibilityLabel(Deals.redeem.rawValue)
        tester().waitForViewToLoad(5)
    }

    func test1NearMeContainsDeals() {
        //not working right now without being logged in.
        tester().testSwitching(Deals.nearme.rawValue)
        tester().containsDeals()
    }
  
    func test2SwitchToRecommendedDeals() {
        tester().testSwitching(Deals.recommended.rawValue)
        tester().containsDeals()
    }

    func test4SeeDetailsOfNearMeDeals() {
        tester().testSwitching(Deals.nearme.rawValue)
        
        let oatmealBar : UILabel = tester().waitForViewWithAccessibilityLabel(Deals.fruitcup.rawValue) as! UILabel
        oatmealBar.tap()
        tester().validateLoggedInDetailsPage(Deals.fruitcup.rawValue)
        
        tester().clickBackFromDealDetailsPage()
        tester().waitForViewToLoad(2)
        
        let pizza : UILabel = tester().waitForViewWithAccessibilityLabel(Deals.sportsdrink.rawValue) as! UILabel
        pizza.tap()
        tester().validateLoggedInDetailsPage(Deals.sportsdrink.rawValue)
        tester().clickBackFromDealDetailsPage()
    }
    
    func test5SeeDetailsOfRecommendedDeals() {
        tester().testSwitching(Deals.recommended.rawValue)
        
        let oatmealBar : UILabel = tester().waitForViewWithAccessibilityLabel(Deals.pizza.rawValue) as! UILabel
        oatmealBar.tap()
        tester().validateLoggedInDetailsPage(Deals.pizza.rawValue)
        
        tester().clickBackFromDealDetailsPage()
        tester().waitForViewToLoad(2)
        
        let pizza : UILabel = tester().waitForViewWithAccessibilityLabel(Deals.hotdog.rawValue) as! UILabel
        pizza.tap()
        tester().validateLoggedInDetailsPage(Deals.hotdog.rawValue)
        tester().clickBackFromDealDetailsPage()
    }
    
    func test6SavedDealsShowUpInRewardspage() {
        tester().openRewardsTab()
        
        let view : UICollectionView! =  tester().waitForTappableViewWithAccessibilityLabel(MyRewards.saveddeals.rawValue) as! UICollectionView
        tester().swipeViewWithAccessibilityLabel(MyRewards.saveddeals.rawValue, inDirection: KIFSwipeDirection.Up)
        //var tot = count(view.visibleCells())
        print("total: \( view.visibleCells().count)")
        XCTAssertTrue(view.visibleCells().count == 4, "We clicked on 4 deals, but there wasnt 4 to be found")
    }
}

private extension KIFUITestActor {
    func getToAccountLoginPage() {
        tester().testSwitching(Deals.recommended.rawValue)
        tester().tapViewWithAccessibilityLabel(Deals.create.rawValue)
        print("waiting for 2 seconds to see if demo mode shows up.")
        tester().waitForViewToLoad(2)
        tester().clearDemoMode()
        tester().waitForSoftwareKeyboard()
    }
    
    func tapDigits(digits : [String]) {
        for digit in digits {
            tester().tapViewWithAccessibilityLabel(digit)
        }
        tester().waitForViewToLoad(2)
    }
    
    func validateLoggedInDetailsPage(deal : String) {
        let highlights = tester().validateViewExists("HIGHLIGHTS")
        let highlightsParent : UIView? = highlights.superview
        let deal = tester().validateViewExists(deal)
        let dealsParent : UIView? = deal.superview
        
        XCTAssertNotNil(deal, "Potentially loaded wrong deal")
        XCTAssertNotNil(highlights, "Should have a highlights label")
        XCTAssertNotNil(tester().validateViewExists("FINE PRINT"), "Shoudl have a fine print label")
        
        let plusImageSize = CGSize(width: 25, height: 25)
        let checkImageSize = CGSize(width: 30, height: 22)
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
                    // These are things that can only be done when logged in.
                    button.tap()
                    tester().waitForViewToLoad(1)
                    if let imageSize = button.currentImage?.size {
                        //XCTAssertNotEqualWithAccuracy(imageSize, checkImageSize, CGSize(width: 0.5,height: 0.5), "Image did not turn from plus sign to check mark")
                        XCTAssertEqualWithAccuracy(imageSize.height, checkImageSize.height, accuracy: 0.5, "Image did not turn from plus sign to check mark")
                        XCTAssertEqualWithAccuracy(imageSize.width, checkImageSize.width, accuracy: 0.5, "Image did not turn from plus sign to check mark")
                        //XCTAssertEqual(imageSize, checkImageSize, "Image did not turn from plus sign to check mark")
                    }
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
}
