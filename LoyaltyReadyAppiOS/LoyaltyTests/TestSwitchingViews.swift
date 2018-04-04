/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/


/**
Tests have funny names as they run in alphabetical order. So we threw in 
a digit into the name to ensure they run in the order we want.
*/
class TestSwitchingViews: KIFTestCase {
    
    var mainScreenBounds: CGRect!
    
    override func beforeAll() {
        tester().clearPopupsNoAccount(true)
    }
    
    /*
    Test that we can switch to the deals page
    */
    func test0SwitchToDealsPage() {
        tester().openDealsTab()
    }
    /*
    Test that we can switch to the Stations page
    */
    func test1SwitchToStationsPage() {
        tester().openStationsTab()
    }
    /*
    Test that we can switch to the rewards page.
    */
    func test2SwitchToRewardsPage() {
        tester().openRewardsTab()
    }
}
