//
//  TakeOutOrderPayRequest.m
//  Carte
//
//  Created by ligh on 14-5-8.
//
//

#import "TakeOutOrderPayRequest.h"

@implementation TakeOutOrderPayRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=doPay&"];
}

@end
