//
//  MainViewController.m
//  Kai-Ping-Tseng_DigitalTurbine_Task
//
//  Created by Kai-Ping Tseng on 2022/11/3.
//

#import "MainViewController.h"

#import <AdSupport/ASIdentifierManager.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>

#import "Offer.h"
#import "ListViewController.h"

#import "SHA1Helper.h"
#import "URLProvider.h"

#import "RemoteFeedLoader.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self checkTrackingAuthorization:ATTrackingManager.trackingAuthorizationStatus];
}

- (void)send:(UIButton*)sender {
    __weak id weakSelf = self; // handled the retain cycle
    HTTPClient *client = [HTTPClient new];
    RemoteFeedLoader *feedLoader = [[RemoteFeedLoader alloc] initWithUrl: [URLProvider getOffersURL] andClient:client];
    [feedLoader getOfferswithAppID:self.appID uid:self.userID andToken:self.securityToken :^(NSArray *offers, BOOL isSidIdentical) {
        if (offers != nil) {
            ListViewController *listVC = [[ListViewController alloc] initWithOffers:offers
                                                                  andIsSidIdentical:isSidIdentical];
            listVC.modalPresentationStyle = UIModalPresentationAutomatic;
            [weakSelf presentViewController:listVC animated:true completion:nil];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Something's wrong..."
                                                                           message:@""
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Ok"
                                                                  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            }];
            
            [alert addAction:firstAction];
            
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }
        
    }];
    
}

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
}


// MARK: handle keyboard dismiss when hit outside textfields
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
    [super touchesBegan:touches withEvent:event];
}

// MARK: handling Apple Tracking
- (void)checkTrackingAuthorization:(ATTrackingManagerAuthorizationStatus) status {
    switch (status) {
        case ATTrackingManagerAuthorizationStatusAuthorized:
            break;
        case ATTrackingManagerAuthorizationStatusNotDetermined:
            [self requestTrackingAccess];
            break;
        case ATTrackingManagerAuthorizationStatusDenied:
        case ATTrackingManagerAuthorizationStatusRestricted:
            [self displayTrackingAccessAlert];
            break;
    }
}

- (void)requestTrackingAccess {
    [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
        [self checkTrackingAuthorization:status];
    }];
}

- (void)displayTrackingAccessAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tracking access is required" message:@"Please turn on access to tracking on the settings" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:settingsAction];
    [alert addAction:cancelAction];
    [alert setPreferredAction:settingsAction];
    
    UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    alertWindow.rootViewController = [[UIViewController alloc] init];
    alertWindow.windowLevel = UIWindowLevelAlert + 1;
    [alertWindow makeKeyAndVisible];
    [alertWindow.rootViewController presentViewController:alert animated:true completion:nil];
}

// MARK: handle views setup
- (void)setupViews {
    // setup viewcontroller
    self.view.backgroundColor = UIColor.whiteColor;
    
    // setup views
    UIStackView *stackView = [[UIStackView alloc] init];
    
    UILabel *appIDLabel = [[UILabel alloc] init];
    appIDLabel.backgroundColor = UIColor.clearColor;
    appIDLabel.text = @"Application ID";
    appIDLabel.textAlignment = NSTextAlignmentLeft;
    
    NSInteger defaultAppID = 1246;
    NSString *defaultAppIDString = [@(defaultAppID) stringValue];
    self.appIDTextField = [[UITextField alloc] init];
    self.appIDTextField.text = defaultAppIDString;
    _appID = defaultAppID;
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
    
    NSString *defaultUID = @"superman";
    self.userIDTextField = [[UITextField alloc] init];
    self.userIDTextField.text = defaultUID;
    _userID = defaultUID;
    self.userIDTextField.backgroundColor = UIColor.lightGrayColor;
    self.userIDTextField.placeholder = @"Enter...";
    self.userIDTextField.tag = 1;
    self.userIDTextField.delegate = self;
    [self.userIDTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UILabel *securityTokenLabel = [[UILabel alloc] init];
    securityTokenLabel.backgroundColor = UIColor.clearColor;
    securityTokenLabel.text = @"Security Token";
    securityTokenLabel.textAlignment = NSTextAlignmentLeft;
    
    NSString *token = @"82085b8b7b31b3e80beefdc0430e2315f67cd3e1";
    self.securityTokenTextField = [[UITextField alloc] init];
    self.securityTokenTextField.text = token;
    _securityToken = token;
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
