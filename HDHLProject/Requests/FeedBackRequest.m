//
//  FeedBackRequest.m
//  Carte
//
//  Created by user on 14-5-7.
//
//

#import "FeedBackRequest.h"

@implementation FeedBackRequest

-(NSString*)getRequestUrl{
    return [NSString stringWithFormat:@"api.php?&apiUrl=feedback&"];
}

-(ITTRequestMethod)getRequestMethod{
    return ITTRequestMethodPost;
}

-(void)processResult{
    [super processResult];
}

@end
