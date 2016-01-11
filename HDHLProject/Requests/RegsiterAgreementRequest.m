//
//  RegsiterAgreementRequest.m
//  Carte
//
//  Created by ligh on 14-6-10.
//
//

#import "RegsiterAgreementRequest.h"

@implementation RegsiterAgreementRequest

- (NSString *)getRequestUrl
{
    
    return [NSString stringWithFormat:@"api.php?apiUrl=protocol&"];
    
}
@end