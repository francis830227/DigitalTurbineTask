//
//  AdvertisingInfoHelper.m
//  Kai-Ping-Tseng_DigitalTurbine_Task
//
//  Created by Kai-Ping Tseng on 2022/11/8.
//

#import "AdvertisingInfoHelper.h"
#import <AdSupport/ASIdentifierManager.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@implementation AdvertisingInfoHelper

+ (NSString*)getUUID {
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

+ (Boolean)isIDFAEnabled {
    return ATTrackingManager.trackingAuthorizationStatus == ATTrackingManagerAuthorizationStatusAuthorized;
}

@end
