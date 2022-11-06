//
//  MainViewController.h
//  Kai-Ping-Tseng_DigitalTurbine_Task
//
//  Created by Kai-Ping Tseng on 2022/11/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TextFieldType) { appIDTFType, userIDTFType, securityTokenTFType };


@interface MainViewController : UIViewController <UITextFieldDelegate>

@property UITextField *appIDTextField;

@property NSInteger appID;

@property UITextField *userIDTextField;

@property NSString *userID;

@property UITextField *securityTokenTextField;

@property NSString *securityToken;



@end

NS_ASSUME_NONNULL_END
