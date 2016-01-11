//
//  OverageOrRechargeView.h
//  Carte
//
//  Created by ligh on 15-1-15.
//
//

#import "XibView.h"

@interface OverageOrRechargeView : XibView

@property (retain, nonatomic) IBOutlet UIButton *rechargeButton;
@property (retain, nonatomic) IBOutlet UILabel *overageLabel;

- (void)setOverageValue:(NSString *)value;

@end
