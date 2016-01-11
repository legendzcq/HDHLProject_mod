//
//  SettingDefaultAddressRequest.m
//  Carte
//
//  Created by ligh on 14-5-8.
//
//

#import "SettingDefaultAddressRequest.h"

@implementation SettingDefaultAddressRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=sendAddressDefault&"];
}

@end
