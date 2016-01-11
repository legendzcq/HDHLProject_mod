//
//  OrderTakeSureRequest.m
//  Carte
//
//  Created by ligh on 15-4-8.
//
//

#import "OrderTakeSureRequest.h"

@implementation OrderTakeSureRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=addOrder&"];
}

@end
