//
//  Offer.m
//  Kai-Ping-Tseng_DigitalTurbine_Task
//
//  Created by Kai-Ping Tseng on 2022/11/8.
//

#import "Offer.h"

@implementation Offer

- (instancetype) initWithTitle: (NSString *)title andImageURL: (NSURL *)url {
    self = [super init];
    
    if (self) {
        self.title = title;
        self.imageURL = url;
    }
    return self;
}

@end
