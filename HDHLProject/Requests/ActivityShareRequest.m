//
//  ActivityShareRequest.m
//  Carte
//
//  Created by ligh on 15-5-6.
//
//

#import "ActivityShareRequest.h"

@implementation ActivityShareRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=shareSuccess&"];
}

@end
