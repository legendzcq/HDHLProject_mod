//
//  OverageOrRechargeView.m
//  Carte
//
//  Created by ligh on 15-1-15.
//
//

#import "OverageOrRechargeView.h"
#import "FrameLineView.h"

@interface OverageOrRechargeView ()
{
    IBOutlet FrameLineView *_lineView;
}
@end

@implementation OverageOrRechargeView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [_rechargeButton setTitleColor:ColorForHexKey(AppColor_Jump_Function_Text4) forState:UIControlStateNormal];
}

- (void)setOverageValue:(NSString *)value
{
    _overageLabel.text = value;
    
    CGFloat morenWidth = _lineView.left - _overageLabel.left;
    _overageLabel.width = [value widthWithFont:_overageLabel.font boundingRectWithSize:CGSizeMake(morenWidth, _overageLabel.height)]+10;
    _rechargeButton.right = self.right;
    _lineView.right = _rechargeButton.left + 5;
}

- (void)dealloc
{
    RELEASE_SAFELY(_rechargeButton);
    RELEASE_SAFELY(_overageLabel);
    RELEASE_SAFELY(_lineView);
}

@end
