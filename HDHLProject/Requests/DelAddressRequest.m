//
//  DelAddressRequest.m
//  Carte
//
//  Created by ligh on 14-5-4.
//
//

#import "DelAddressRequest.h"

@implementation DelAddressRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=sendAddressDelete&"];
}

@end
