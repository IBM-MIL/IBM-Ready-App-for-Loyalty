/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit
import XCTest

class LoyaltyLocalWatchDataTests: XCTestCase {
    
    /// User data object
    var user: User!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let bundle = NSBundle(forClass: self.dynamicType) //Needs dynamicType so class can be converted to anyClass, otherwise will error
        let path = bundle.pathForResource("data", ofType: "json")
        let jsonData = NSData(contentsOfFile: path!)
        var jsonResult = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as! [String:AnyObject]
        user = User(json: jsonResult)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLocalDataCall() {
        
        XCTAssertFalse(user.transactions.count == 0, "Zero transactions were returned from the server")
        XCTAssertFalse(user.gasStations.count == 0, "Zero gas station references were returned from the server")
        XCTAssertFalse(user.deals.count == 0, "Zero deals were returned from the server")
        
        XCTAssertNotNil(user.profile, "Profile is nil")
        XCTAssertNotNil(user.profile.rewards, "User has no rewards data")
        
        /* Deal tests */
        for deal in user.deals {
            XCTAssertTrue(count(deal.name) > 0, "Length of name is less than 0")
            XCTAssertTrue(LoyaltyWatchDataTests.isDateInFuture(deal.expiration), "Date on deal is not in the future")
        }
        
        /* Rewards tests */
        XCTAssertGreaterThanOrEqual(user.profile.rewards.points, 0, "User has less than zero points")
        XCTAssertGreaterThanOrEqual(user.profile.rewards.savings, 0, "User has less than zero savings")
        XCTAssertGreaterThanOrEqual(user.profile.rewards.progress, 0, "User has less than 0% progress")
        XCTAssertLessThanOrEqual(user.profile.rewards.progress, 100, "User has greater than 100% progress")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
