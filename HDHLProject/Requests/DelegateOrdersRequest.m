//
//  DelegateOrdersRequest.m
//  Carte
//
//  Created by liu on 15-4-18.
//
//

#import "DelegateOrdersRequest.h"

@implementation DelegateOrdersRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=delOrder&"];
}


@end
