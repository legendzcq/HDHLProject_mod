//
//  NotLoginView.m
//  HDHLProject
//
//  Created by liu on 15/8/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "NotLoginView.h"

@implementation NotLoginView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (void)showInView:(UIView *)view WithText:(NSString *)messageString WithBoolTableBarView:(BOOL)tableBarView  WithBlock:(void(^)())clickBlock
{
    NotLoginView *notLogView = [NotLoginView viewFromXIB];
    notLogView.width = view.width;
    notLogView.height = view.height;
    notLogView.block = clickBlock;
    notLogView.tableBarView = tableBarView;
    notLogView.messageLabel.text = messageString;
    [notLogView adjsutSubViewsWithFatherView:view];
    [view addSubview:notLogView];
    [view bringSubviewToFront:notLogView];
}
+ (void)dismissFromSuperView:(UIView *)contentView
{
    for (UIView *subView in contentView.subviews) {
        if([subView isKindOfClass:[NotLoginView class]]){
            [subView removeFromSuperview];
        }
    }
}
- (void)adjsutSubViewsWithFatherView:(UIView *)fatherView
{
    self.contentView.backgroundColor = [[UIColor clearColor]colorWithAlphaComponent:0];
    self.contentView.top = (fatherView.height - self.contentView.height-(self.tableBarView?TAB_BAR_HEIGHT:0))/2;
}


+ (void)notLoginViewDissmisFromSuperView:(UIView *)superView
{
    for (UIView *view in superView.subviews) {
        if([view isKindOfClass:[NotLoginView class]]){
            [view removeFromSuperview];
            break;
        }
    }
}

- (IBAction)logInBtnClick:(UIButton *)sender {
     if(self.block){
        self.block();
    }
}

@end
