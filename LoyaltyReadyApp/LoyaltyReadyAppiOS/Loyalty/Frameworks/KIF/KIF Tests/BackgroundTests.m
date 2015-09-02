//
//  BackgroundTests.m
//  KIF
//
//  Created by Jordan Zucker on 5/18/15.
//
//

#import <KIF/KIF.h>

@interface BackgroundTests : KIFTestCase

@end

@implementation BackgroundTests

- (void)beforeEach {
    [tester tapViewWithAccessibilityLabel:@"Background"];
}

- (void)afterEach {
    [tester tapViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitButton];
}

- (void)testBackgroundApp {
    [tester waitForViewWithAccessibilityLabel:@"Start"];
    [tester deactivateAppForDuration:5];
    [tester waitForViewWithAccessibilityLabel:@"Back"];
}

@end
