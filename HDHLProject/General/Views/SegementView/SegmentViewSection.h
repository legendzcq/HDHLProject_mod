//
//  SegmentViewSection.h
//  Carte
//
//  Created by ligh on 14-11-19.
//
//

#import "XibView.h"

//选择器类型
typedef enum
{
    SegmentSelectType1 = 0, //可用 & 已过期
    SegmentSelectType2,     //就餐环境 & 菜品
}SegmentSelectType;

@protocol SegmentSectionDelegate <NSObject>
- (void)segmentViewSectionSelectedWithIndex:(NSInteger)index;
@end

@interface SegmentViewSection : XibView

@property (nonatomic, assign) id <SegmentSectionDelegate> delegate;
- (void)setButtonTitle:(SegmentSelectType)segmentSelectType;

- (void)setButton1NormalAndButton2Selected;
- (void)setButton2NormalAndButton1Selected;

@end