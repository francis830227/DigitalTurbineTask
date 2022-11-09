//
//  RemoteFeedLoader.m
//  Kai-Ping-Tseng_DigitalTurbine_Task
//
//  Created by Kai-Ping Tseng on 2022/11/8.
//

#import "RemoteFeedLoader.h"
#import "SHA1Helper.h"
#import "DeviceInfoHelper.h"
#import "AdvertisingInfoHelper.h"
#import "Offer.h"
#import "HTTPClient.h"

@interface RemoteFeedLoader ()

@property NSURL *url;

@property HTTPClient *client;

@end

@implementation RemoteFeedLoader

- (void)loadWithURL: (NSURL *)url :(NSString *)token :(void(^)(NSArray*, BOOL, NSError*))completion {
    
    [_client getFrom:url :^(NSData *data, NSHTTPURLResponse *response, NSError* error) {
        
        //  get the signature
        NSDictionary *headers = response.allHeaderFields;
        NSString *signature = [headers objectForKey:@"X-Sponsorpay-Response-Signature"];
        NSString *dataString = [NSString stringWithUTF8String:[data bytes]];
        
        NSString *responseBodyWithApiKey = [NSString stringWithFormat:@"%@%@", dataString, token];
        
        NSString *encodedResponseBodyWithApiKey = [SHA1Helper getHash:responseBodyWithApiKey];
        
        BOOL isSidIdentical = [signature isEqualToString:encodedResponseBodyWithApiKey];
        
        NSUInteger statusCode = response.statusCode;
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (statusCode == 200 && ![[results objectForKey:@"offers"] isEqual:@""]) {
                NSMutableArray *jsonOffers = [results objectForKey:@"offers"];
                
                NSMutableArray *offers = [NSMutableArray new];
                
                for (NSDictionary *offerDict in jsonOffers) {
                    NSString *title = [offerDict objectForKey:@"title"];
                    NSDictionary *thumbnails = [offerDict objectForKey:@"thumbnail"];
                    NSString *thumbnail = [thumbnails objectForKey:@"lowres"];
                    
                    Offer *offer = [[Offer alloc] initWithTitle:title andImageURL:[NSURL URLWithString:thumbnail]];
                    
                    [offers addObject:offer];
                }
                
                completion(offers, isSidIdentical, error);
                
            } else {
                
                completion(nil, isSidIdentical, error);
                
            }
        });
    }];
}

- (void)getOfferswithAppID:(NSInteger)appID uid:(NSString*)uid andToken:(NSString*)token :(void(^)(NSArray*, BOOL))completion {
    
    // combine base url with params
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:self.url.absoluteString];
    
    NSArray *queryItems = [self makeQueryItemsFromAppID:appID uid:uid andToken:token];
    [components setQueryItems:queryItems];
    
    [self loadWithURL:components.URL :token :^(NSArray *offers, BOOL isSidIdentical, NSError *error) {
        
        completion(offers, isSidIdentical);
        
    }];
}

- (NSArray*)makeQueryItemsFromAppID:(NSInteger) appID uid:(NSString*)uid andToken:(NSString*)token {
    // appID
    NSString *appIDString = [@(appID) stringValue];
    NSURLQueryItem *appIDItem = [[NSURLQueryItem alloc] initWithName:@"appid" value:appIDString];
    
    //  uid
    NSURLQueryItem *userIDItem = [[NSURLQueryItem alloc] initWithName:@"uid" value:uid];
    
    //  Using fixed IP address
    NSString *testIPString = @"109.235.143.113";
    NSURLQueryItem *ipItem = [[NSURLQueryItem alloc] initWithName:@"ip" value:testIPString];
    
    //  Using fixed locale
    //  NSString *language = [[NSLocale preferredLanguages] firstObject];
    NSString *testLocale = @"DE";
    NSURLQueryItem *localeItem = [[NSURLQueryItem alloc] initWithName:@"locale" value:testLocale];
    
    //  deviceID
    NSString *deviceID = [DeviceInfoHelper getDeviceID];
    NSURLQueryItem *deviceIDItem = [[NSURLQueryItem alloc] initWithName:@"device_id" value:deviceID];
    
    //  timestamp
    long currentDate = (long)[[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] integerValue];
    NSString *timestamp = [NSString stringWithFormat:@"%lu", currentDate];
    NSURLQueryItem *timestampItem = [[NSURLQueryItem alloc] initWithName:@"timestamp" value:timestamp];
    
    //  offer types
    NSURLQueryItem *offerTypesItem = [[NSURLQueryItem alloc] initWithName:@"offer_types" value:@"112"];
    
    //  system version
    NSString *systemVersion = [DeviceInfoHelper getSystemVersion];
    NSURLQueryItem *osVersionItem = [[NSURLQueryItem alloc] initWithName:@"os_version" value:systemVersion];
    
    //  phone version
    NSString *phoneVersion = [self getPhoneVersionWithSystemVersion:systemVersion];
    NSURLQueryItem *phoneVersionItem = [[NSURLQueryItem alloc] initWithName:@"phone_version" value:phoneVersion];
    
    //  idfa
    NSString *idfa = [AdvertisingInfoHelper getUUID];
    NSURLQueryItem *appleIDFAItem = [[NSURLQueryItem alloc] initWithName:@"apple_idfa" value:idfa];
    
    Boolean idfaEnabled = [AdvertisingInfoHelper isIDFAEnabled];
    NSString *value = (idfaEnabled) ? @"true" : @"false";
    NSURLQueryItem *appleIDFATrackingEnabledItem = [[NSURLQueryItem alloc] initWithName:@"apple_ifda_tracking_enabled" value:value];
    
    //  make query items
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
    
    //  generate hash key
    NSString *hashKey = [self generateHashKeyWithQueryItems:queryItems andToken:token];
    NSURLQueryItem *hashkeyItem = [[NSURLQueryItem alloc] initWithName:@"hashkey" value:hashKey];
    
    //  append hash to query items
    NSMutableArray *modQueryItems = [NSMutableArray arrayWithArray:queryItems];
    [modQueryItems addObject:hashkeyItem];
    
    return modQueryItems;
}

- (NSString*)getPhoneVersionWithSystemVersion: (NSString*) systemVersion {
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
    return phoneVersion;
}

- (NSString*)generateHashKeyWithQueryItems: (NSArray*) queryItems andToken: (NSString*) token {
    NSArray *sortedQueryItems = [queryItems sortedArrayUsingComparator:^NSComparisonResult(NSURLQueryItem* a, NSURLQueryItem* b) {
        return [a.name compare:b.name];
    }];
    NSMutableArray *queryStrings = [NSMutableArray new];
    for (NSURLQueryItem *item in sortedQueryItems) {
        NSString *str = [NSString stringWithFormat:@"%@=%@", item.name, item.value];
        [queryStrings addObject:str];
    }
    [queryStrings addObject:token];
    NSString *concatenatedString = [queryStrings componentsJoinedByString:@"&"];
    NSString *hashKey = [SHA1Helper getHash:concatenatedString];
    return hashKey;
}

// MARK: Initialization
- (instancetype) initWithUrl: (NSURL *)url andClient: (HTTPClient *)client {
    self = [super init];
    
    if (self) {
        self.url = url;
        self.client = client;
    }
    
    return self;
}

@end
