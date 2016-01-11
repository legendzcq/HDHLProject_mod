//
//  RechargeAddRequest.m
//  Carte
//
//  Created by ligh on 15-1-8.
//
//

#import "RechargeAddRequest.h"
#import "PayModeModel.h"

@implementation RechargeAddRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"/api.php?apiUrl=addTransfer&"];
}

- (void)processResult
{
    [super processResult];
    
}

@end
