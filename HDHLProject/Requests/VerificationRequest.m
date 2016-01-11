//
//  VerificationRequest.m
//  Carte
//
//  Created by user on 14-4-29.
//
//

#import "VerificationRequest.h"

@implementation VerificationRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=verify&"];
    
}

- (void)processResult
{

    [super processResult];
    
}

@end
