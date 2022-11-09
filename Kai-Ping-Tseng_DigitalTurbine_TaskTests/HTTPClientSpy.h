//
//  HTTPClientSpy.h
//  Kai-Ping-Tseng_DigitalTurbine_TaskTests
//
//  Created by Kai-Ping Tseng on 2022/11/9.
//

#import "HTTPClient.h"

@interface HTTPClientSpy : HTTPClient

@property NSMutableArray *requestedURLs;

@end
