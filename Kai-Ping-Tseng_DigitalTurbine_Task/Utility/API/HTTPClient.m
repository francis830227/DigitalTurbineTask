//
//  HTTPClient.m
//  Kai-Ping-Tseng_DigitalTurbine_Task
//
//  Created by Kai-Ping Tseng on 2022/11/9.
//

#import "HTTPClient.h"

@implementation HTTPClient

- (void)getFrom: (NSURL*)url :(void(^)(NSData*, NSHTTPURLResponse*, NSError*))completion {
    
    // session
    NSURLSessionConfiguration *defaultSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultSessionConfiguration];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"GET"];
        
    //  create url session data task
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        completion(data, (NSHTTPURLResponse *)response, error);
    }];
    
    //  fire the request
    [dataTask resume];
}

@end
