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
    [self setupViews];
}

- (void)send:(UIButton*)sender {
    NSLog(@"sendButtonClicked");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
    [super touchesBegan:touches withEvent:event];
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//
//}

- (void)textFieldDidChange:(UITextField *)textField {
    NSString *str = textField.text;
    
    switch (textField.tag) {
        case appIDTFType:
            self.appID = str.integerValue;
            break;
        case userIDTFType:
            self.userID = str;
            break;
        case securityTokenTFType:
            self.securityToken = str;
    }
    
    NSLog(@"%ld", (long)self.appID);
}

- (void)setupViews {
    // setup viewcontroller
    self.view.backgroundColor = UIColor.whiteColor;
    
    // setup views
    UIStackView *stackView = [[UIStackView alloc] init];
    
    UILabel *appIDLabel = [[UILabel alloc] init];
    appIDLabel.backgroundColor = UIColor.clearColor;
    appIDLabel.text = @"Application ID";
    appIDLabel.textAlignment = NSTextAlignmentLeft;
    
    self.appIDTextField = [[UITextField alloc] init];
    self.appIDTextField.backgroundColor = UIColor.lightGrayColor;
    self.appIDTextField.placeholder = @"Enter...";
    self.appIDTextField.tag = 0;
    self.appIDTextField.delegate = self;
    self.appIDTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.appIDTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UILabel *userIDLabel = [[UILabel alloc] init];
    userIDLabel.backgroundColor = UIColor.clearColor;
    userIDLabel.text = @"User ID";
    userIDLabel.textAlignment = NSTextAlignmentLeft;
    
    self.userIDTextField = [[UITextField alloc] init];
    self.userIDTextField.backgroundColor = UIColor.lightGrayColor;
    self.userIDTextField.placeholder = @"Enter...";
    self.userIDTextField.tag = 1;
    self.userIDTextField.delegate = self;
    [self.userIDTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UILabel *securityTokenLabel = [[UILabel alloc] init];
    securityTokenLabel.backgroundColor = UIColor.clearColor;
    securityTokenLabel.text = @"securityTokenLabel";
    securityTokenLabel.textAlignment = NSTextAlignmentLeft;
    
    self.securityTokenTextField = [[UITextField alloc] init];
    self.securityTokenTextField.backgroundColor = UIColor.lightGrayColor;
    self.securityTokenTextField.placeholder = @"Enter...";
    self.securityTokenTextField.tag = 2;
    self.securityTokenTextField.delegate = self;
    [self.securityTokenTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *blankView = [[UIView alloc] init];
    blankView.backgroundColor = UIColor.whiteColor;
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [sendButton setBackgroundColor:UIColor.blueColor];
    [sendButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
    
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionEqualSpacing;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 10;
    [stackView addArrangedSubview:appIDLabel];
    [stackView addArrangedSubview:self.appIDTextField];
    [stackView addArrangedSubview:userIDLabel];
    [stackView addArrangedSubview:self.userIDTextField];
    [stackView addArrangedSubview:securityTokenLabel];
    [stackView addArrangedSubview:self.securityTokenTextField];
    [stackView addArrangedSubview:blankView];
    [stackView addArrangedSubview:sendButton];
    [self.view addSubview:stackView];
    
    // setup constraints
    [appIDLabel.heightAnchor constraintEqualToConstant:40].active = true;
    [appIDLabel.widthAnchor constraintEqualToAnchor:stackView.widthAnchor multiplier:0.7].active = true;
    
    [self.appIDTextField.heightAnchor constraintEqualToConstant:40].active = true;
    [self.appIDTextField.widthAnchor constraintEqualToAnchor:stackView.widthAnchor multiplier:0.7].active = true;
    
    [userIDLabel.heightAnchor constraintEqualToConstant:40].active = true;
    [userIDLabel.widthAnchor constraintEqualToAnchor:stackView.widthAnchor multiplier:0.7].active = true;
    
    [self.userIDTextField.heightAnchor constraintEqualToConstant:40].active = true;
    [self.userIDTextField.widthAnchor constraintEqualToAnchor:stackView.widthAnchor multiplier:0.7].active = true;
    
    [securityTokenLabel.heightAnchor constraintEqualToConstant:40].active = true;
    [securityTokenLabel.widthAnchor constraintEqualToAnchor:stackView.widthAnchor multiplier:0.7].active = true;
    
    [self.securityTokenTextField.heightAnchor constraintEqualToConstant:40].active = true;
    [self.securityTokenTextField.widthAnchor constraintEqualToAnchor:stackView.widthAnchor multiplier:0.7].active = true;
    
    [blankView.heightAnchor constraintEqualToConstant:20].active = true;
    
    [sendButton.heightAnchor constraintEqualToConstant:40].active = true;
    [sendButton.widthAnchor constraintEqualToAnchor:stackView.widthAnchor multiplier:0.5].active = true;
    
    stackView.translatesAutoresizingMaskIntoConstraints = false;
    [stackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
    [stackView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = true;
    [stackView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = true;
}

@end
