//
//  UploadDeviceTokenRequest.m
//  Carte
//
//  Created by liu on 15-2-3.
//
//

#import "UploadDeviceTokenRequest.h"

@implementation UploadDeviceTokenRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=setDeviceTokens&"];
    
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
