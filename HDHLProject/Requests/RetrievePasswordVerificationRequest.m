//
//  RetrievePasswordVerificationRequest.m
//  Carte
//
//  Created by user on 14-4-30.
//
//

#import "RetrievePasswordVerificationRequest.h"

@implementation RetrievePasswordVerificationRequest

-(NSString*)getRequestUrl{
    
    return [NSString stringWithFormat:@"api.php?apiUrl=validate&"];
}

-(ITTRequestMethod)getRequestMethod{
    return ITTRequestMethodPost;
}

-(void)processResult{
    [super processResult];
}

@end
