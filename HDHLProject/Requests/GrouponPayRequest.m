//
//  GrouponPayRequest.m
//  Carte
//
//  Created by ligh on 14-5-12.
//
//

#import "GrouponPayRequest.h"

@implementation GrouponPayRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=addOrder&"];
}


@end
