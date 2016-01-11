//
//  SegmentTitleView.m
//  HDHLProject
//
//  Created by hdcai on 15/7/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//
#define TITLEARRAY_COUNT           _titleArray.count

#import "SegmentTitleView.h"

@implementation SegmentTitleView
{
    NSArray *_titleArray;
    NSInteger _buttonSelectID;
    UIImageView *_LineImageView;
}

-(id)initWithTitleArray:(NSArray *)array
{
    CGRect frame = CGRectMake(0, 0, SEGMENTTITLEBUTTON_WIDTH*array.count, NAV_BAR_HEIGHT);

    self = [super init];
    if (self) {
        self.frame = frame;
        _titleArray = [NSArray arrayWithArray:array];
        [self configUI];
    }
    
    return self;
}

-(void)configUI
{
    _buttonSelectID = 100;
    if (_titleArray.count < 2) {
        return;
    }
    for (int i=0; i<_titleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SEGMENTTITLEBUTTON_WIDTH*i, 0,SEGMENTTITLEBUTTON_WIDTH, NAV_BAR_HEIGHT);
        button.tag = _buttonSelectID + i;
        if (i == 0) {
            button.selected = YES;
        }
        [button setTitle:[_titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:ColorForHexKey(AppColor_Money_Color_Text1) forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        [button addTarget:self action:@selector(segmentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    _LineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT-2, SEGMENTTITLEBUTTON_WIDTH, 2)];
    _LineImageView.backgroundColor = ColorForHexKey(AppColor_Money_Color_Text1);
    [self addSubview:_LineImageView];
}

-(void)segmentButtonClick:(UIButton *)sender
{
    //如果更换按钮
    if (sender.tag != _buttonSelectID) {
        //取之前的按钮
        UIButton *lastButton = (UIButton *)[self viewWithTag:_buttonSelectID];
        lastButton.selected = NO;
        //赋值按钮ID
        _buttonSelectID = sender.tag;
    }
    
    
    //按钮选中状态
    if (!sender.selected) {
        sender.selected = YES;
        [UIView animateWithDuration:0.25 animations:^{
            [_LineImageView setFrame:CGRectMake(sender.frame.origin.x, NAV_BAR_HEIGHT-2, SEGMENTTITLEBUTTON_WIDTH, 2)];
        } completion:^(BOOL finished) {
            if (finished) {
                //代理方法
                if ([_delegate respondsToSelector:@selector(segmentTitleViewDidSelectedButtonWithSegmentTitleIndex:)]) {
                    if (sender.tag - 100 == 0) {
                        [_delegate segmentTitleViewDidSelectedButtonWithSegmentTitleIndex:SegmentTitleIndexFirst];
                    }else if (sender.tag - 100 == 1){
                        [_delegate segmentTitleViewDidSelectedButtonWithSegmentTitleIndex:SegmentTitleIndexSecond];
                    }
                }
            }
        }];
        
    }
    //重复点击选中按钮
    else {
        
    }
}

-(void)setSelectSegmentTitleWithIndex:(SegmentTitleIndex)segmentTitleIndex
{
    //button的tag 从100开始
    if (segmentTitleIndex == SegmentTitleIndexFirst) {
        self.segmentTitleIndex = SegmentTitleIndexFirst;
        UIButton *lastButton = (UIButton *)[self viewWithTag:_buttonSelectID];
        lastButton.selected = NO;
        UIButton *newButton = (UIButton *)[self viewWithTag:100];
        newButton.selected = YES;
        _buttonSelectID = 100;
        [UIView animateWithDuration:0.25 animations:^{
            [_LineImageView setFrame:CGRectMake(newButton.frame.origin.x, NAV_BAR_HEIGHT-2, SEGMENTTITLEBUTTON_WIDTH, 2)];
        } completion:^(BOOL finished) {
        }];

    }else if (segmentTitleIndex == SegmentTitleIndexSecond){
        self.segmentTitleIndex = SegmentTitleIndexSecond;
        UIButton *lastButton = (UIButton *)[self viewWithTag:_buttonSelectID];
        lastButton.selected = NO;
        UIButton *newButton = (UIButton *)[self viewWithTag:101];
        newButton.selected = YES;
        _buttonSelectID = 101;
        [UIView animateWithDuration:0.25 animations:^{
            [_LineImageView setFrame:CGRectMake(newButton.frame.origin.x, NAV_BAR_HEIGHT-2, SEGMENTTITLEBUTTON_WIDTH, 2)];
        } completion:^(BOOL finished) {
        }];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
