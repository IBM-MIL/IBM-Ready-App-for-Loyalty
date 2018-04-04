/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

/*
If you can't find a method or constant in here, its probably in TestConstants.swift.
*/
class TestMyRewards: KIFTestCase {
    override func beforeAll() {
        tester().clearPopupsNoAccount(true)
        tester().openRewardsTab()
    }
    
    func testNotContainsSavedDeals() {
        let view : UICollectionView! =  tester().waitForTappableViewWithAccessibilityLabel(MyRewards.saveddeals.rawValue) as! UICollectionView
        XCTAssertEqual(view.visibleCells().count, 0, "Should not have any visible cells")
    }
    func testContainsCheapest() {
        let view2 = tester().waitForViewWithAccessibilityLabel(MyRewards.cheapest.rawValue)
        XCTAssertNotNil(view2, "Cheapest station should not be nil")
    }
    
    func testContainsClosest() {
        let view2 = tester().waitForViewWithAccessibilityLabel(MyRewards.closest.rawValue)
        XCTAssertNotNil(view2, "Closest station should not be nil")
    }
    
    func testContainsNoSavedDeals() {
        let view : UICollectionView! =  tester().waitForTappableViewWithAccessibilityLabel(MyRewards.saveddeals.rawValue) as! UICollectionView
        tester().swipeViewWithAccessibilityLabel(MyRewards.saveddeals.rawValue, inDirection: KIFSwipeDirection.Up)

        let cells : NSArray! = view.visibleCells() as! [DealCollectionViewCell]
        XCTAssertTrue(cells.count == 0, "Should not have any cells to see right now.")
    }
}

private extension KIFUITestActor {
    func clickLocationAllow() {
        tester().clickLocationAllow()
    }
    /**  test helper methods **/
    func testContainsItems() {
    }
}
