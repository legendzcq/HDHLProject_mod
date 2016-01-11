//
//  ConfirmDeliveryRequest.m
//  Carte
//
//  Created by liu on 15-4-20.
//
//

#import "ConfirmDeliveryRequest.h"

@implementation ConfirmDeliveryRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=doneOrder&"];
}
@end
