//
//  SHA1Helper.m
//  Kai-Ping-Tseng_DigitalTurbine_Task
//
//  Created by Kai-Ping Tseng on 2022/11/8.
//

#import "SHA1Helper.h"
#import <CommonCrypto/CommonDigest.h>

@implementation SHA1Helper

+ (NSString*)getHash:(NSString*)inputText {
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

@end
