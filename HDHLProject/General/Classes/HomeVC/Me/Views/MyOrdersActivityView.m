//
//  MyOrdersActivityView.m
//  Carte
//
//  Created by liu on 15-5-6.
//

#import "MyOrdersActivityView.h"
#import "FrameLineView.h"
#import "ActivityModel.h"   
#import "ActivityView.h"

#define MyAtivityView_BottomEdages 10  //下间距
#define MyAtivityView_ActivityEdages 42 // 活动+间距
#define MyAtivityView_LineFrame CGRectMake(10, 45, SCREEN_WIDTH -20, 0.5)
#define  MyAtivityView_TopEdages 0.5
@implementation MyOrdersActivityView
{
    IBOutlet UILabel * _titleLabel ;
}

+(void)showInView:(UIView *)fatherView WithActivityArray:(NSArray  *)activityArray;
{
    MyOrdersActivityView *activityView=[MyOrdersActivityView viewFromXIB];
    [activityView adjustFrameWithArray:activityArray];
    activityView.top = MyAtivityView_TopEdages;
    fatherView.height = activityView.height+ MyAtivityView_TopEdages+MyAtivityView_TopEdages;
    activityView.width  =SCREEN_WIDTH ;
    [activityView creatActiviViewWithArray:activityArray];
    [fatherView addSubview:activityView];
    
}

- (void)awakeFromNib
{
  _titleLabel.textColor = ColorForHexKey(AppColor_Content_Text2);
}

- (void)adjustFrameWithArray:(NSArray *)acitivityArray
{
    self.height = acitivityArray.count * MyAtivityView_ActivityEdages +MyAtivityView_BottomEdages;
}

- (void)creatActiviViewWithArray:(NSArray *)activityArray
{
    [activityArray enumerateObjectsUsingBlock:^(ActivityModel * model, NSUInteger idx, BOOL *stop) {
        ActivityView *activityView = [ActivityView viewFromXIB];
        activityView.titleLabel.text =model.activity_title;
        activityView.frame = CGRectMake(15, MyAtivityView_BottomEdages+(idx)*MyAtivityView_ActivityEdages, SCREEN_WIDTH-30, 34);
        [self addSubview:activityView];
    }];
}
@end
