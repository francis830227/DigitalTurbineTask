//
//  Offer.h
//  Kai-Ping-Tseng_DigitalTurbine_Task
//
//  Created by Kai-Ping Tseng on 2022/11/8.
//

#import <Foundation/Foundation.h>

@interface Offer : NSObject

@property NSString *title;

@property NSURL *imageURL;

- (instancetype) initWithTitle: (NSString *)title andImageURL: (NSURL *)url;

@end
