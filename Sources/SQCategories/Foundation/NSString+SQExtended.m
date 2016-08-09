//
//  NSString+SQExtended.m
//  VseMayki
//
//  Created by Sequenia on 17/05/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "NSString+SQExtended.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (SQExtended)

- (BOOL)sq_containsString:(NSString *)str {
    return [self rangeOfString: str].location != NSNotFound;
}

- (BOOL)sq_containsString:(NSString *)str options:(NSStringCompareOptions)options {
    return [self rangeOfString: str options:options].location != NSNotFound;
}

- (NSString*)sq_uppercaseFirstLetterString {
    NSString* resultString = self;
    if (self.length > 0) {
        resultString = [self stringByReplacingCharactersInRange: NSMakeRange(0,1)
                                                     withString: [[self substringToIndex:1] capitalizedString]];
    }
    return resultString;
}

+ (NSString*)sq_stringForCount: (NSInteger) count withWords: (NSArray*) words{
    if(words.count < 4 || !words)
        return nil;
    if (count == 0){
        return words[3];
    }
    NSString* resultString;
    NSInteger i,j;
    j = count % 100;
    if (j >= 11 && j <= 19) {
        resultString = words[2];
    }
    else {
        i = j % 10;
        switch (i)
        {
            case (1): resultString = words[0]; break;
            case (2):
            case (3):
            case (4): resultString = words[1]; break;
            default: resultString = words[2];
        }
    }
    return [NSString stringWithFormat: @"%ld %@", (long)count, resultString];
}

+ (NSString *)sq_encodeStringForURL:(NSString *)string{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (CFStringRef)string,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    kCFStringEncodingUTF8 ));
    return encodedString;
}

+(NSString *)sq_constructStringFromArray:(NSArray *)array withSpliter:(NSString *)splitter{
    NSMutableString *string = [[NSMutableString alloc] init];
    for(int i = 0; i < [array count]; i++){
        [string appendString:[array objectAtIndex:i]];
        if(i < [array count] - 1)
            [string appendString:splitter];
    }
    return string;
}

-(BOOL)sq_isEmail {
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}



- (BOOL)sq_isEmpty {
    return [self isEqualToString:@""];
}

- (NSString *)sq_sha1 {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG) data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

- (NSString *)sq_md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int)strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

/**
 * Коды ошибок смотреть тут)
 https://developer.apple.com/library/mac/documentation/Networking/Reference/CFNetworkErrors/index.html#//apple_ref/c/tdef/CFNetworkErrors
 */
+ (NSString *)sq_decodeNetworkError:(NSError *)error{
    if(error.code == kCFURLErrorTimedOut){
        return SQSlowConnectionDesc;
    }
    if(error.code == kCFURLErrorCannotFindHost ||
       error.code == kCFURLErrorCannotConnectToHost ||
       error.code == kCFURLErrorNetworkConnectionLost ||
       error.code == kCFURLErrorNotConnectedToInternet) {
        return SQNoConnectionDesc;
    }
    return SQServerErrorDesc;
    
}

@end
