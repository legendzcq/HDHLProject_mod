//
//  ActityRequest.m
//  Carte
//
//  Created by ligh on 14-5-16.
//
//

#import "ActityRequest.h"

@implementation ActityRequest

- (NSString *)getRequestUrl {
    return [NSString stringWithFormat:@"api.php?apiUrl=activityDetail&"];
}

@end
