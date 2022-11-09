//
//  HTTPClientSpy.m
//  Kai-Ping-Tseng_DigitalTurbine_TaskTests
//
//  Created by Kai-Ping Tseng on 2022/11/9.
//

#import "HTTPClientSpy.h"

@implementation HTTPClientSpy

- (void)getFrom:(NSURL *)url :(void (^)(NSData *, NSHTTPURLResponse *, NSError *))completion {
    [self.requestedURLs addObject:url];
    NSData* data = [@"data" dataUsingEncoding:NSUTF8StringEncoding];
    completion(data, [NSHTTPURLResponse new], nil);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestedURLs = [NSMutableArray new];
    }
    return self;
}

@end
