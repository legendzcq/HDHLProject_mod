//
//  ModifyNickNameRequest.m
//  Carte
//
//  Created by ligh on 14-4-29.
//
//

#import "ModifyNickNameRequest.h"

@implementation ModifyNickNameRequest


- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=memberSet&"];
    
}

- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}

-(void)processResult
{
    
    [super processResult];
    
}

@end
