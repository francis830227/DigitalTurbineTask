//
//  RemoteFeedLoader.h
//  Kai-Ping-Tseng_DigitalTurbine_Task
//
//  Created by Kai-Ping Tseng on 2022/11/8.
//

#import <Foundation/Foundation.h>
#import "HTTPClient.h"

@interface RemoteFeedLoader : NSObject

- (void)loadWithURL: (NSURL *)url andToken:(NSString *)token :(void(^)(NSArray*, BOOL, NSError*))completion;

- (void)getOfferswithAppID:(NSInteger)appID uid:(NSString*)uid andToken:(NSString*)token :(void(^)(NSArray*, BOOL))completion;

- (instancetype) initWithUrl: (NSURL *)url andClient: (HTTPClient *)client;

@end

