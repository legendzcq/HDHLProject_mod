//
//  ResetPasswoedRequest.m
//  Carte
//
//  Created by user on 14-4-29.
//
//

#import "ResetPasswoedRequest.h"

@implementation ResetPasswoedRequest

-(NSString*)getRequestUrl{
    
    return [NSString stringWithFormat:@"api.php?apiUrl=changePassword&"];
    
}

-(ITTRequestMethod)getRequestMethod{
    return ITTRequestMethodPost;
}

-(void)processResult{
    [super processResult];
}
@end
