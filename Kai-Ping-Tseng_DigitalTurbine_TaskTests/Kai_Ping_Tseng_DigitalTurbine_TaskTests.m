//
//  Kai_Ping_Tseng_DigitalTurbine_TaskTests.m
//  Kai-Ping-Tseng_DigitalTurbine_TaskTests
//
//  Created by Kai-Ping Tseng on 2022/11/3.
//

#import <XCTest/XCTest.h>
#import "RemoteFeedLoader.h"
#import "HTTPClient.h"

@interface Kai_Ping_Tseng_DigitalTurbine_TaskTests : XCTestCase

@end

@implementation Kai_Ping_Tseng_DigitalTurbine_TaskTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)test_load_requestsDataFromURL {
    NSURL *url = [self anyURL];
    
    HTTPClient *client = [HTTPClient new];
    
//    NSMutableArray *receivedRequests =
    
    RemoteFeedLoader *sut = [self makeSUTWith:url];
    
    [sut];
}

// MARK: Helpers

- (RemoteFeedLoader*)makeSUTWith: (NSURL*)url {
    HTTPClient *client = [HTTPClient new];
    RemoteFeedLoader *sut = [[RemoteFeedLoader alloc] initWithUrl:url andClient:client];
    
    return sut;
}

- (NSURL*)anyURL {
    return [NSURL URLWithString:@"http://any-url.com"];
}

@end
