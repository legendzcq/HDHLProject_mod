//
//  SeatOrderModel.m
//  Carte
//
//  Created by ligh on 14-4-30.
//
//

#import "SeatOrderModel.h"

@implementation SeatOrderModel

- (void)dealloc
{
    RELEASE_SAFELY(_share_content);
}




-(BOOL)isCancelOrder
{
    return    [self.order_status length]&& ([self.order_status intValue]==WaitPayUnValidationStatus ||[self.order_status intValue]==OrderFinshStatus);
}


@end
