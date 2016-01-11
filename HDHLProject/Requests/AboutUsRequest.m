//
//  AboutUsRequest.m
//  Carte
//
//  Created by user on 14-5-7.
//
//

#import "AboutUsRequest.h"

@implementation AboutUsRequest

-(NSString *)getRequestUrl{
    return [NSString stringWithFormat:@"api.php?apiUrl=about&"];
}

-(ITTRequestMethod)getRequestMethod{
    return ITTRequestMethodPost;
}

-(void)processResult{
    [super processResult];
}

@end
