//
//  HTTPClient.h
//  Kai-Ping-Tseng_DigitalTurbine_Task
//
//  Created by Kai-Ping Tseng on 2022/11/9.
//

#import <Foundation/Foundation.h>

@interface HTTPClient : NSObject

- (void)getFrom: (NSURL*)url :(void(^)(NSData*, NSHTTPURLResponse*, NSError*))completion;

@end
