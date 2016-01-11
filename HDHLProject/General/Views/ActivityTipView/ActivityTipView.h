//
//  ActivityTipView.h
//  Carte
//
//  Created by ligh on 15-4-2.
//
//

#import "XibView.h"

@protocol ActivityTipViewDelegate <NSObject>
- (void)cancenActivityTipView; //关闭活动提示
- (void)gotoActivityAction;    //跳转到活动页
@end

@interface ActivityTipView : XibView
@property (nonatomic, assign) id <ActivityTipViewDelegate> delegate;
@property (retain, nonatomic) IBOutlet UILabel *activityTitleLabel;
@property (retain, nonatomic) IBOutlet UIImageView *activityBGImageV;
@property (retain, nonatomic) IBOutlet UIImageView *activityIconImageV;
@property (retain, nonatomic) IBOutlet UIButton *activityCancelBtn;
-(void)setActivityTipViewHightWithString:(NSString *)str;
@end
