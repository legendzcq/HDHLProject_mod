//
//  ConfigHelper.m
//  Carte
//
//  Created by ligh on 14-7-1.
//
//

#import "ConfigHelper.h"
#define KAppleIDKey @"AppleID"

@implementation ConfigHelper

+ (id)objectForInfoDictionaryKey:(NSString *)key
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:key];
}


+ (NSString *)appScheme
{
    NSArray *schemes = [self objectForInfoDictionaryKey:@"CFBundleURLTypes"];
    for (NSDictionary *dic in schemes)
    {
        if ([dic[@"CFBundleURLName"] isEqualToString:@"appSchemes"])
        {
            return dic[@"CFBundleURLSchemes"][0];
        }
    }
    
    return @"HDHLSchemes";
}

+ (NSString *)appleID
{
    return [self objectForInfoDictionaryKey:KAppleIDKey];
}



@end
