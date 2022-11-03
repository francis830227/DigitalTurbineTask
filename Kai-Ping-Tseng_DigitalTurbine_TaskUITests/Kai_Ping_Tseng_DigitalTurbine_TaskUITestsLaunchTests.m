//
//  Kai_Ping_Tseng_DigitalTurbine_TaskUITestsLaunchTests.m
//  Kai-Ping-Tseng_DigitalTurbine_TaskUITests
//
//  Created by Kai-Ping Tseng on 2022/11/3.
//

#import <XCTest/XCTest.h>

@interface Kai_Ping_Tseng_DigitalTurbine_TaskUITestsLaunchTests : XCTestCase

@end

@implementation Kai_Ping_Tseng_DigitalTurbine_TaskUITestsLaunchTests

+ (BOOL)runsForEachTargetApplicationUIConfiguration {
    return YES;
}

- (void)setUp {
    self.continueAfterFailure = NO;
}

- (void)testLaunch {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    // Insert steps here to perform after app launch but before taking a screenshot,
    // such as logging into a test account or navigating somewhere in the app

    XCTAttachment *attachment = [XCTAttachment attachmentWithScreenshot:XCUIScreen.mainScreen.screenshot];
    attachment.name = @"Launch Screen";
    attachment.lifetime = XCTAttachmentLifetimeKeepAlways;
    [self addAttachment:attachment];
}

@end
