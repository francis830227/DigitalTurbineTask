//
//  URLProvider.m
//  Kai-Ping-Tseng_DigitalTurbine_Task
//
//  Created by Kai-Ping Tseng on 2022/11/9.
//

#import "URLProvider.h"

@implementation URLProvider

+ (NSURL *)getOffersURL {
    // domain + path
    NSURLComponents *components = [NSURLComponents new];
    [components setScheme:@"http"];
    [components setHost:@"api.fyber.com"];
    [components setPath:@"/feed/v1/offers.json"];
    return components.URL;
}

@end
