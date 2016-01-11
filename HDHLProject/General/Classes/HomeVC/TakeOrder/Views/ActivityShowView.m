//
//  ActivityShowView.m
//  HDHLProject
//
//  Created by Mac on 15/8/1.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ActivityShowView.h"
#import "ActivityModel.h"

#define kActivityViewHeight 45
#define kActivityLabelFont  18.0

@interface ActivityShowView () {
    IBOutlet UIView *_backgroundView;
    IBOutlet UIView *_contentView;
    
    IBOutlet UIView *_activityView1;
    IBOutlet UIView *_activityView2;

    IBOutlet UIImageView *_iconImageView1;
    IBOutlet UIImageView *_iconImageView2;

    IBOutlet UILabel *_iconLabel1;
    IBOutlet UILabel *_iconLabel2;
}
@end

@implementation ActivityShowView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self loadColor];
}

- (void)loadColor {
    _iconLabel1.textColor = [UIColor whiteColor];
    _iconLabel2.textColor = [UIColor whiteColor];
}

- (void)showWithActivity:(ActivityModel *)activityModel {
    
    [self setActivityViewsWithActivity:activityModel];
    
    self.frame = CGRectMake(0, 0, [KAPP_WINDOW width], [KAPP_WINDOW height]);
    _backgroundView.alpha = 0.5;
    
    [KAPP_WINDOW addSubview:self];
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.2;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [self.layer addAnimation:animation forKey:nil];
    
    [UIView beginAnimations:@"ShowAnimation" context:nil];
    _backgroundView.alpha = 0.7;
    [UIView commitAnimations];
}

- (void)setActivityViewsWithActivity:(ActivityModel *)activityModel {
    
    //折扣
    if ([NSString isBlankString:activityModel.discount_id]) {
        _activityView1.hidden = YES;
    } else {
        _activityView1.hidden = NO;
        if (_activityView1.hidden) {
            _activityView1.height = 0;
        }
        _iconLabel1.text = activityModel.discount_title;
    }
   
    
    //优惠
    if ([NSString isBlankString:activityModel.sales_id]) {
        _activityView2.hidden = YES;
    } else {
        _activityView2.hidden = NO;
        _activityView2.top = _activityView1.bottom;
        if (_activityView2.hidden) {
            _activityView2.height = 0;
        }
        _iconLabel2.text = activityModel.sales_title;
    }
}

- (IBAction)selfDismiss:(id)sender {
    [self removeFromSuperview];
}

@end
