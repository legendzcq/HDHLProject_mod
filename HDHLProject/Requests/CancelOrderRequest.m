//
//  CancelOrderRequest.m
//  Carte
//
//  Created by ligh on 14-5-12.
//
//

#import "CancelOrderRequest.h"

@implementation CancelOrderRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=delOrder&"];
}

@end
