//
//  FunctionalTests.m
//  Kai-Ping-Tseng_DigitalTurbine_TaskTests
//
//  Created by Kai-Ping Tseng on 2022/11/9.
//

#import <XCTest/XCTest.h>
#import "RemoteFeedLoader.h"
#import "URLProvider.h"
#import "Offer.h"

@interface FunctionalTests : XCTestCase

@end

@implementation FunctionalTests

- (void)setUp {
}

- (void)tearDown {
}

- (void)test_endToEndTest {
    
    NSInteger testAppID = 1246;
    NSString *testUID = @"superman";
    NSString *testToken = @"82085b8b7b31b3e80beefdc0430e2315f67cd3e1";
    
    __block NSArray *receivedResults = [NSArray new];
    
    HTTPClient *client = [HTTPClient new];
    RemoteFeedLoader *feedLoader = [[RemoteFeedLoader alloc] initWithUrl: [URLProvider getOffersURL] andClient:client];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Wait for load completion."];
    [feedLoader getOfferswithAppID:testAppID uid:testUID andToken:testToken :^(NSArray *offers, BOOL isSigIdentical) {
        receivedResults = offers;
        [expectation fulfill];
    }];
    
    [self waitForExpectations:[NSArray arrayWithObject:expectation] timeout:5.0];
    
    Offer *firstOffer = [receivedResults firstObject];
        
    BOOL isIdentical = [firstOffer.title isEqualToString:@"Install Ant Legion and complete the events!"];
    
    XCTAssertEqual([receivedResults count], 30);
    XCTAssertTrue(isIdentical);
}

@end
