//
//  ActivityItemView.h
//  Carte
//
//  Created by ligh on 14-9-15.
//
//

#import "XibView.h"
#import "ActivityModel.h"

@protocol ActivityItemViewDelegate;


/**
    点菜和外卖可以参加的活动
 **/
@interface ActivityItemView : XibView

//选择此活动 或者 取消选择此活动时 调用此delegate
@property (assign,nonatomic) id<ActivityItemViewDelegate> delegate;

@property (assign,nonatomic) BOOL enable;
//是否选中
@property (assign,nonatomic) BOOL selected;

//活动信息
@property (retain,nonatomic) ActivityModel *activityModel;



@end


@protocol ActivityItemViewDelegate <NSObject>

//选则某一个活动
-(void) didSelectedActivityItemView:(ActivityItemView *) itemView;


@end
