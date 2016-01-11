//
//  SetPersonBirthRequest.m
//  Carte
//
//  Created by zln on 15/1/21.
//
//

#import "SetPersonBirthRequest.h"

@implementation SetPersonBirthRequest



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
