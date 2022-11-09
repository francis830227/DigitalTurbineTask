//
//  LoadFeedFromRemoteUseCaseTests.m
//  Kai-Ping-Tseng_DigitalTurbine_TaskTests
//
//  Created by Kai-Ping Tseng on 2022/11/3.
//

#import <XCTest/XCTest.h>
#import "RemoteFeedLoader.h"
#import "HTTPClientSpy.h"

@interface LoadFeedFromRemoteUseCaseTests : XCTestCase

@end

@implementation LoadFeedFromRemoteUseCaseTests

- (void)setUp {
}

- (void)tearDown {
}

- (void)test_init_doesNotRequestDataFromURL {
    HTTPClientSpy *client = [HTTPClientSpy new];
    XCTAssertEqual([client.requestedURLs count], 0);
}

- (void)test_load_requestsDataFromURL {
    NSURL *url = [self anyURL];
    
    HTTPClientSpy *client = [HTTPClientSpy new];
        
    RemoteFeedLoader *sut = [self makeSUTWith:url
                                    andClient:client];
    
    [sut loadWithURL:url andToken:@"token" :^(NSArray *array, BOOL isSigIdentical, NSError *error) {
        
    }];
    
    XCTAssertEqual([client.requestedURLs count], 1);
}

- (void)test_load_requestsDataFromURLTwice {
    NSURL *url = [self anyURL];
    
    HTTPClientSpy *client = [HTTPClientSpy new];
        
    RemoteFeedLoader *sut = [self makeSUTWith:url
                                    andClient:client];
    
    [sut loadWithURL:url andToken:@"token" :^(NSArray *array, BOOL isSigIdentical, NSError *error) {
    }];
    
    [sut loadWithURL:url andToken:@"token" :^(NSArray *array, BOOL isSigIdentical, NSError *error) {
    }];
    
    XCTAssertEqual([client.requestedURLs count], 2);
}

// MARK: Helpers

- (RemoteFeedLoader*)makeSUTWith: (NSURL*)url andClient: (HTTPClientSpy*)client {
    RemoteFeedLoader *sut = [[RemoteFeedLoader alloc] initWithUrl:url andClient:client];
    return sut;
}

- (NSURL*)anyURL {
    return [NSURL URLWithString:@"http://any-url.com"];
}

@end
