//
//  DeviceInfoHelper.h
//  Kai-Ping-Tseng_DigitalTurbine_Task
//
//  Created by Kai-Ping Tseng on 2022/11/8.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@interface DeviceInfoHelper : NSObject

+ (NSString*)getDeviceID;

+ (NSString*)getSystemVersion;

+ (UIUserInterfaceIdiom)getUserInterfaceIdiom;

@end
