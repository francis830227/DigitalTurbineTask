//
//  NetworkManager.m
//  Kai-Ping-Tseng_DigitalTurbine_Task
//
//  Created by Kai-Ping Tseng on 2022/11/8.
//

#import "NetworkManager.h"
#import "SHA1Helper.h"
#import "DeviceInfoHelper.h"
#import "AdvertisingInfoHelper.h"
#import "Offer.h"

@implementation NetworkManager

+ (instancetype)shared {
    static NetworkManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NetworkManager alloc] init];
    });
    return sharedInstance;
}

- (void)getOfferswithAppID:(NSInteger)appID uid:(NSString*)uid andToken:(NSString*)token :(void(^)(NSArray*, BOOL))completion {
    
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
    
    NSString *deviceID = [DeviceInfoHelper getDeviceID];
    NSURLQueryItem *deviceIDItem = [[NSURLQueryItem alloc] initWithName:@"device_id" value:deviceID];
    
    long currentDate = (long)[[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] integerValue];
    NSString *timestamp = [NSString stringWithFormat:@"%lu", currentDate];
    NSURLQueryItem *timestampItem = [[NSURLQueryItem alloc] initWithName:@"timestamp" value:timestamp];
    
    NSURLQueryItem *offerTypesItem = [[NSURLQueryItem alloc] initWithName:@"offer_types" value:@"112"];
    
    NSString *systemVersion = [DeviceInfoHelper getSystemVersion];
    NSURLQueryItem *osVersionItem = [[NSURLQueryItem alloc] initWithName:@"os_version" value:systemVersion];
    
    NSURLQueryItem *phoneVersionItem = [NSURLQueryItem new];
    UIUserInterfaceIdiom idiom = [DeviceInfoHelper getUserInterfaceIdiom];
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
    
    NSString *idfa = [AdvertisingInfoHelper getUUID];
    NSURLQueryItem *appleIDFAItem = [[NSURLQueryItem alloc] initWithName:@"apple_idfa" value:idfa];
    
    Boolean idfaEnabled = [AdvertisingInfoHelper isIDFAEnabled];
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
    NSString *hashKey = [SHA1Helper getHash:concatenatedString];
    
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

        NSString *encodedResponseBodyWithApiKey = [SHA1Helper getHash:responseBodyWithApiKey];
        
        BOOL isSidIdentical = [signature isEqualToString:encodedResponseBodyWithApiKey];
                
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (statusCode == 200) {
                
                if (![[results objectForKey:@"offers"] isEqual:@""]) {
                    
                    NSMutableArray *jsonOffers = [results objectForKey:@"offers"];
                    
                    NSMutableArray *offers = [NSMutableArray new];
                    
                    for (NSDictionary *offerDict in jsonOffers) {
                        NSString *title = [offerDict objectForKey:@"title"];
                        NSDictionary *thumbnails = [offerDict objectForKey:@"thumbnail"];
                        NSString *thumbnail = [thumbnails objectForKey:@"lowres"];
                        
                        Offer *offer = [[Offer alloc] initWithTitle:title andImageURL:[NSURL URLWithString:thumbnail]];
                        
                        [offers addObject:offer];
                    }
                    
                    completion(offers, isSidIdentical);
                                        
                }
                
                
            } else {
                
                completion(nil, isSidIdentical);
                
            }
        });
           
    }];
    
    [dataTask resume];
}

@end
