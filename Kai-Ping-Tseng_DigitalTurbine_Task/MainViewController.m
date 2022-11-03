//
//  MainViewController.m
//  Kai-Ping-Tseng_DigitalTurbine_Task
//
//  Created by Kai-Ping Tseng on 2022/11/3.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup viewcontroller
    self.view.backgroundColor = UIColor.whiteColor;
    
    // setup views
    UIStackView *stackView = [[UIStackView alloc] init];
    
    UILabel *appIDLabel = [[UILabel alloc] init];
    appIDLabel.backgroundColor = UIColor.clearColor;
    appIDLabel.text = @"Application ID";
    appIDLabel.textAlignment = NSTextAlignmentLeft;
    
    UITextField *appIDTextField = [[UITextField alloc] init];
    appIDTextField.backgroundColor = UIColor.lightGrayColor;
    appIDTextField.placeholder = @"Enter...";
    
    UILabel *userIDLabel = [[UILabel alloc] init];
    userIDLabel.backgroundColor = UIColor.clearColor;
    userIDLabel.text = @"User ID";
    userIDLabel.textAlignment = NSTextAlignmentLeft;
    
    UITextField *userIDTextField = [[UITextField alloc] init];
    userIDTextField.backgroundColor = UIColor.lightGrayColor;
    userIDTextField.placeholder = @"Enter...";
    
    UILabel *securityTokenLabel = [[UILabel alloc] init];
    securityTokenLabel.backgroundColor = UIColor.clearColor;
    securityTokenLabel.text = @"securityTokenLabel";
    securityTokenLabel.textAlignment = NSTextAlignmentLeft;
    
    UITextField *securityTokenTextField = [[UITextField alloc] init];
    securityTokenTextField.backgroundColor = UIColor.lightGrayColor;
    securityTokenTextField.placeholder = @"Enter...";
    
    UIView *blankView = [[UIView alloc] init];
    blankView.backgroundColor = UIColor.whiteColor;
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [sendButton setBackgroundColor:UIColor.blueColor];
    [sendButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionEqualSpacing;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 10;
    [stackView addArrangedSubview:appIDLabel];
    [stackView addArrangedSubview:appIDTextField];
    [stackView addArrangedSubview:userIDLabel];
    [stackView addArrangedSubview:userIDTextField];
    [stackView addArrangedSubview:securityTokenLabel];
    [stackView addArrangedSubview:securityTokenTextField];
    [stackView addArrangedSubview:blankView];
    [stackView addArrangedSubview:sendButton];
    [self.view addSubview:stackView];
    
    // setup constraints
    [appIDLabel.heightAnchor constraintEqualToConstant:40].active = true;
    [appIDLabel.widthAnchor constraintEqualToAnchor:stackView.widthAnchor multiplier:0.7].active = true;
    
    [appIDTextField.heightAnchor constraintEqualToConstant:40].active = true;
    [appIDTextField.widthAnchor constraintEqualToAnchor:stackView.widthAnchor multiplier:0.7].active = true;
    
    [userIDLabel.heightAnchor constraintEqualToConstant:40].active = true;
    [userIDLabel.widthAnchor constraintEqualToAnchor:stackView.widthAnchor multiplier:0.7].active = true;
    
    [userIDTextField.heightAnchor constraintEqualToConstant:40].active = true;
    [userIDTextField.widthAnchor constraintEqualToAnchor:stackView.widthAnchor multiplier:0.7].active = true;
    
    [securityTokenLabel.heightAnchor constraintEqualToConstant:40].active = true;
    [securityTokenLabel.widthAnchor constraintEqualToAnchor:stackView.widthAnchor multiplier:0.7].active = true;
    
    [securityTokenTextField.heightAnchor constraintEqualToConstant:40].active = true;
    [securityTokenTextField.widthAnchor constraintEqualToAnchor:stackView.widthAnchor multiplier:0.7].active = true;
    
    [blankView.heightAnchor constraintEqualToConstant:20].active = true;
    
    [sendButton.heightAnchor constraintEqualToConstant:40].active = true;
    [sendButton.widthAnchor constraintEqualToAnchor:stackView.widthAnchor multiplier:0.5].active = true;
    
    stackView.translatesAutoresizingMaskIntoConstraints = false;
    [stackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
    [stackView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = true;
    [stackView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = true;
}

@end
