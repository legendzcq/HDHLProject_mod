//
//  EditAddressRequest.m
//  Carte
//
//  Created by ligh on 14-5-4.
//
//

#import "EditAddressRequest.h"

@implementation EditAddressRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=sendAddressSet&"];
    
}

@end
