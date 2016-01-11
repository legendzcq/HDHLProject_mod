//
//  SegmentTitleView.h
//  HDHLProject
//
//  Created by hdcai on 15/7/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SEGMENTTITLEBUTTON_WIDTH  70
typedef enum
{
    SegmentTitleIndexFirst    = 0,
    SegmentTitleIndexSecond   = 1,
} SegmentTitleIndex;



@protocol SegmentTitleViewDelegate <NSObject>

-(void)segmentTitleViewDidSelectedButtonWithSegmentTitleIndex:(SegmentTitleIndex)segmentTitleIndex;

@end

@interface SegmentTitleView : UIView
@property (nonatomic, assign)SegmentTitleIndex segmentTitleIndex;
@property (nonatomic, assign)id<SegmentTitleViewDelegate>delegate;
-(id)initWithTitleArray:(NSArray *)array;

-(void)setSelectSegmentTitleWithIndex:(SegmentTitleIndex)segmentTitleIndex;

@end
