//
//  ActivityTipView.m
//  Carte
//
//  Created by ligh on 15-4-2.
//
//

#import "ActivityTipView.h"
//#import "RechargeVC.h"

@interface ActivityTipView ()


@end

@implementation ActivityTipView

- (void)dealloc
{
    RELEASE_SAFELY(_activityTitleLabel);
    RELEASE_SAFELY(_activityBGImageV);
    RELEASE_SAFELY(_activityIconImageV);
    RELEASE_SAFELY(_activityCancelBtn);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //颜色
    _activityTitleLabel.textColor  = ColorForHexKey(AppColor_Select_Box_Text4);
}

-(void)setActivityTipViewHightWithString:(NSString *)str
{
    if ([str isEqualToString:ActivityTipViewPromptText]) {
        self.activityTitleLabel.textColor = [UIColor whiteColor];
        self.activityBGImageV.image = nil;
        self.activityBGImageV.backgroundColor = ColorForHexKey(AppColor_Jump_Function_Text7);
        [self.activityIconImageV setImage:[UIImage imageNamed:@"activity2_icon.png"]];
        [self.activityCancelBtn setImage:[UIImage imageNamed:@"activity_shutdown2.png"]forState:UIControlStateNormal];
    }else{
        self.activityTitleLabel.textColor = ColorForHexKey(AppColor_Select_Box_Text4);
        self.activityBGImageV.backgroundColor = [UIColor clearColor];
        [self.activityBGImageV setImage:[UIImage imageNamed:@"activity.png"]];
        [self.activityIconImageV setImage:[UIImage imageNamed:@"activity_icon.png"]];
        [self.activityCancelBtn setImage:[UIImage imageNamed:@"activity_shutdown.png"] forState:UIControlStateNormal];
    }
    CGSize titleSize = [str sizeWithFont:[UIFont systemFontOfSize:13] boundingRectWithSize:CGSizeMake(_activityTitleLabel.frame.size.width , MAXFLOAT)];
    self.frame = CGRectMake(0, 0, self.frame.size.width, titleSize.height +14);
    self.activityTitleLabel.text = str;
    self.activityTitleLabel.height = titleSize.height+14;
    self.activityBGImageV.height = titleSize.height+14;

}

- (IBAction)gotoActivityView:(id)sender
{
    if (([_delegate respondsToSelector:@selector(gotoActivityAction)])&&(![_activityTitleLabel.text isEqualToString:ActivityTipViewPromptText])) {
        [_delegate gotoActivityAction];
    }
}

- (IBAction)cancelView:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cancenActivityTipView)]) {
        [_delegate cancenActivityTipView];
    }
//    [self removeFromSuperview];
//    self = nil;
    self.hidden = YES;
}

@end
