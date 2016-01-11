//
//  BookSeatRequest.m
//  Carte
//
//  Created by ligh on 14-5-5.
//
//

#import "BookSeatRequest.h"

@implementation BookSeatRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=addOrder&"];
}


@end
