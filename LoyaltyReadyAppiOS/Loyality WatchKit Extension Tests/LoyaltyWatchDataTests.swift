/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit
import XCTest

class LoyaltyWatchDataTests: XCTestCase {
    
    override func setUp() {
        super.setUp()

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /**
    Method to test MFP data call and that we are getting relevant data needed for Watch app
    */
    func testDataCall() {
        
        var expectation = self.expectationWithDescription("Async MFP call works")
        
        UserDataManager.sharedInstance.getUserData("5128675309", callback: { (replyDictionary: [String : AnyObject]) -> () in
            
            if (replyDictionary["failure"] == nil) {
                
                let user = User(json: replyDictionary)
                
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
                
                expectation.fulfill()
                
            } else {
                logger.logInfoWithMessages("Failure with data: \(replyDictionary)")
            }
            
        })
        
        self.waitForExpectationsWithTimeout(5.0) { (error) in
            
            if (error != nil) {
                XCTFail("Expectation failed with error: \(error)")
            }
            
        }

    }
    
    /**
    Helper method to verify a date is in the future
    
    :param: date passed in date to verify
    
    :returns: Boolean with end result
    */
    class func isDateInFuture(date: NSDate) -> Bool {
        
        var currentDate = NSDate()
        var distanceBetween = date.timeIntervalSinceDate(currentDate)
        var secondsInMinute = 60
        var secondsBetween = Int(distanceBetween) / secondsInMinute

        if secondsBetween <= 0 {
            return false
        } else {
            return true
        }
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
   
}
