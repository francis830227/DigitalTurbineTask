//
//  DeviceInfoHelper.m
//  Kai-Ping-Tseng_DigitalTurbine_Task
//
//  Created by Kai-Ping Tseng on 2022/11/8.
//

#import "DeviceInfoHelper.h"
#import "UIKit/UIKit.h"

@implementation DeviceInfoHelper

+ (NSString*)getDeviceID {
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? @"tablet" : @"phone";
}

+ (NSString*)getSystemVersion {
    return [[UIDevice currentDevice] systemVersion];
}

+ (UIUserInterfaceIdiom)getUserInterfaceIdiom {
    return [[UIDevice currentDevice] userInterfaceIdiom];
}

@end
