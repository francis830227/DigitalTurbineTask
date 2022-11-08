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
#import <CommonCrypto/CommonDigest.h>
#import "Offer.h"

@interface MainViewController ()

@end

@implementation MainViewController

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

- (NSString*) returnHashWithSHA1:(NSString*)inputText {
    const char *cstr = [inputText cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:inputText.length];

    uint8_t digest[CC_SHA1_DIGEST_LENGTH];

    NSUInteger dataLength = data.length;
    int dataLengthInt = (int)dataLength;
    
    CC_SHA1(data.bytes, dataLengthInt, digest);

    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

- (void)fetchData:(NSInteger)appID :(NSString*)uid :(NSString*)token {
    NSURLComponents *components = [NSURLComponents new];
    [components setScheme:@"http"];
    [components setHost:@"api.fyber.com"];
    [components setPath:@"/feed/v1/offers.json"];
    
    NSString *apiKey = @"82085b8b7b31b3e80beefdc0430e2315f67cd3e1";
            
//    NSString *appIDString = [@(appID) stringValue];
//    NSURLQueryItem *appIDItem = [[NSURLQueryItem alloc] initWithName:@"appid" value:appIDString];
    NSURLQueryItem *appIDItem = [[NSURLQueryItem alloc] initWithName:@"appid" value:@"1246"];

    
//    NSURLQueryItem *userIDItem = [[NSURLQueryItem alloc] initWithName:@"uid" value:uid];
    NSURLQueryItem *userIDItem = [[NSURLQueryItem alloc] initWithName:@"uid" value:@"superman"];
    
    NSString *testIPString = @"109.235.143.113";
    NSURLQueryItem *ipItem = [[NSURLQueryItem alloc] initWithName:@"ip" value:testIPString];
    
//    NSString *language = [[NSLocale preferredLanguages] firstObject];
    NSString *testLocale = @"DE";
    NSURLQueryItem *localeItem = [[NSURLQueryItem alloc] initWithName:@"locale" value:testLocale];
    
    NSString *deviceID = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? @"tablet" : @"phone";
    NSURLQueryItem *deviceIDItem = [[NSURLQueryItem alloc] initWithName:@"device_id" value:deviceID];
    
    long currentDate = (long)[[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] integerValue];
    NSString *timestamp = [NSString stringWithFormat:@"%lu", currentDate];
    NSURLQueryItem *timestampItem = [[NSURLQueryItem alloc] initWithName:@"timestamp" value:timestamp];
    
    NSURLQueryItem *offerTypesItem = [[NSURLQueryItem alloc] initWithName:@"offer_types" value:@"112"];
    
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSURLQueryItem *osVersionItem = [[NSURLQueryItem alloc] initWithName:@"os_version" value:systemVersion];
    
    NSURLQueryItem *phoneVersionItem = [NSURLQueryItem new];
    UIUserInterfaceIdiom idiom = [[UIDevice currentDevice] userInterfaceIdiom];
    NSString *phoneVersion = [NSString new];
    NSString *replacedSystemVersion = [systemVersion stringByReplacingOccurrencesOfString:@"." withString:@","];
    switch (idiom) {
        case UIUserInterfaceIdiomPhone:
            phoneVersion = [NSString stringWithFormat:@"%@%@", @"iPhone", replacedSystemVersion];
            break;
        case UIUserInterfaceIdiomPad:
            phoneVersion = [NSString stringWithFormat:@"%@%@", @"iPad", replacedSystemVersion];
            break;
        default:
            phoneVersion = @"blank";
            break;
    }
    phoneVersionItem = [[NSURLQueryItem alloc] initWithName:@"phone_version" value:phoneVersion];
    
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSURLQueryItem *appleIDFAItem = [[NSURLQueryItem alloc] initWithName:@"apple_idfa" value:idfa];
    
    Boolean idfaEnabled = ATTrackingManager.trackingAuthorizationStatus == ATTrackingManagerAuthorizationStatusAuthorized;
    NSString *value = (idfaEnabled) ? @"true" : @"false";
    NSURLQueryItem *appleIDFATrackingEnabledItem = [[NSURLQueryItem alloc] initWithName:@"apple_ifda_tracking_enabled" value:value];
    
    NSArray *queryItems = [NSArray arrayWithObjects:
                           appIDItem,
                           userIDItem,
                           ipItem,
                           localeItem,
                           deviceIDItem,
                           timestampItem,
                           offerTypesItem,
                           osVersionItem,
                           phoneVersionItem,
                           appleIDFAItem,
                           appleIDFATrackingEnabledItem, nil];
    
    // Generate hash key
    NSArray *sortedQueryItems = [queryItems sortedArrayUsingComparator:^NSComparisonResult(NSURLQueryItem* a, NSURLQueryItem* b) {
        return [a.name compare:b.name];
    }];
    NSMutableArray *queryStrings = [NSMutableArray new];
    for (NSURLQueryItem *item in sortedQueryItems) {
        NSString *str = [NSString stringWithFormat:@"%@=%@", item.name, item.value];
        [queryStrings addObject:str];
    }
    [queryStrings addObject:apiKey];
    NSString *concatenatedString = [queryStrings componentsJoinedByString:@"&"];
    NSString *hashKey = [self returnHashWithSHA1:concatenatedString];
    
    NSURLQueryItem *hashkeyItem = [[NSURLQueryItem alloc] initWithName:@"hashkey" value:hashKey];
    
    NSMutableArray *modQueryItems = [NSMutableArray arrayWithArray:queryItems];
    [modQueryItems addObject:hashkeyItem];
    [components setQueryItems:modQueryItems];
    
    
    NSURLSessionConfiguration *defaultSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultSessionConfiguration];
    
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:components.URL];
    
    [urlRequest setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
        NSUInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
        
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        
        //checking the signature
        NSDictionary *headers = ((NSHTTPURLResponse *)response).allHeaderFields;
        NSString *signature = [headers objectForKey:@"X-Sponsorpay-Response-Signature"];
        NSString *dataString = [NSString stringWithUTF8String:[data bytes]];

        NSString *responseBodyWithApiKey = [NSString stringWithFormat:@"%@%@", dataString, apiKey];

        NSString *encodedResponseBodyWithApiKey = [self returnHashWithSHA1:responseBodyWithApiKey];
                
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (statusCode == 200) {
                
                if (![[results objectForKey:@"offers"] isEqual:@""]) {
                    
                    NSMutableArray *jsonOffers = [results objectForKey:@"offers"];
                    
                    NSMutableArray *offers = [NSMutableArray new];
                    
                    for (NSDictionary *offerDict in jsonOffers) {
                        NSString *title = [offerDict objectForKey:@"title"];
                        NSDictionary *thumbnails = [offerDict objectForKey:@"thumbnail"];
                        NSString *thumbnail = [thumbnails objectForKey:@"hires"];
                        
                        Offer *offer = [[Offer alloc] initWithTitle:title andImageURL:[NSURL URLWithString:thumbnail]];
                        
                        [offers addObject:offer];
                    }
                                        
                }
                
                
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Something's wrong..."
                                                                               message:@""
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Ok"
                                                                      style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                }];
                
                [alert addAction:firstAction];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
        });
           
    }];
    
    [dataTask resume];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self checkTrackingAuthorization:ATTrackingManager.trackingAuthorizationStatus];
}

- (void)send:(UIButton*)sender {
    NSLog(@"sendButtonClicked");
    [self fetchData:self.appID :self.userID :self.securityToken];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
    [super touchesBegan:touches withEvent:event];
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
    securityTokenLabel.text = @"securityToken";
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
