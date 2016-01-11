//
//  TestMobileAndVerificationRequest.m
//  Carte
//
//  Created by user on 14-4-29.
//
//

#import "TestMobileAndVerificationRequest.h"

@implementation TestMobileAndVerificationRequest

-(NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=validate&"];
}


-(void)processResult{
    
    [super processResult];

    
}
@end
