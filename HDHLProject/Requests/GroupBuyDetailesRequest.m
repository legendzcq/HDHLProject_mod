//
//  GroupBuyDetailesRequest.m
//  Carte
//
//  Created by liu on 15-4-17.
//
//

#import "GroupBuyDetailesRequest.h"


@implementation GroupBuyDetailesRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=memberSet&"];
    
}


@end
