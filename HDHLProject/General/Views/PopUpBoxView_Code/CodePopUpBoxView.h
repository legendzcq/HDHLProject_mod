//
//  CodePopUpBoxView.h
//  Carte
//
//  Created by ligh on 14-12-10.
//
//

/*
 *消费码、团购码（弹框）
 */

#import "XibView.h"

//默认宽高
#define kPopUpBoxWidth_Code  260
#define kPopUpBoxHeight_Code 160

#define kCodeScrollTop    50 //滚动视图的上距离
#define kCodeScrollBottom 10 //滚动视图的下距离
#define kCodeCellHeight   45 //单个code的显示高度

#define kScrollCount   6 //默认超过6个开始滚屏
#define kCodeLineLeft 15 //虚线左边距
#define kCodeFont 19.0 //默认字体大小

@interface CodePopUpBoxView : XibView

@property (nonatomic, retain) NSMutableArray *codesDataArray;

- (void)showInView:(UIView *)inView withArray:(NSArray *)array;

@end
