//
//  FavourtStoreRequest.m
//  HDHLProject
//
//  Created by hdcai on 15/8/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "FavourtStoreRequest.h"

@implementation FavourtStoreRequest
- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=favourt&"];
}
@end
