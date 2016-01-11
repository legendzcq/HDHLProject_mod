//
//  TakeOrderPayRequest.m
//  Carte
//
//  Created by ligh on 14-5-7.
//
//

#import "TakeOrderPayRequest.h"

@implementation TakeOrderPayRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=doPay&"];
}

@end
