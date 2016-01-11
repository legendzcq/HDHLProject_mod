//
//  SeatDetailVC.m
//  HDHLProject
//
//  Created by liu on 15/8/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SeatDetailVC.h"
#import "SeatOrderDetailsRequest.h"
#import "CancelOrderRequest.h"
#import "SeatOrderModel.h"


@interface SeatDetailVC ()

@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *tableTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *markTextView;
@property (weak, nonatomic) IBOutlet FrameViewWB *markView;
@property (weak, nonatomic) IBOutlet UIButton *optionBtn;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (nonatomic,strong) OrderModel *orderModel;
@property (nonatomic,strong) SeatOrderModel *seatOrderModel;
@end

#define SeatDetail_BottomEdage 55.0f
@implementation SeatDetailVC

- (id)initWithOrderModel:(OrderModel *)orderModel
{
    if(self = [super init]){
        self.orderModel = orderModel;
    }
    return self ;
}

- (void)configViewController
{
    if (!self.orderModel.order_id)
    {
        [BDKNotifyHUD showCryingHUDWithText:@"无效订单"];
        [self actionClickNavigationBarLeftButton];
        return;
    }
    [super configViewController];
     self.navigationBarView.navigationBarTitleLabel.text = @"订单详情";
    self.navigationBarView.leftBarButton.hidden = NO ;
    self.contentView.hidden = YES;
    self.contentView.frame = CGRectMake(0, self.navigationBarView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT -self.navigationBarView.height);
    [self.optionBtn setBackgroundImage:[UIImage imageNamed:@"list_button.png"] forState:UIControlStateNormal];
    [self.optionBtn setBackgroundImage:[UIImage imageNamed:@"list_button_click"] forState:UIControlStateHighlighted];
    self.storeNameLabel.font =FONT_STORE_NAME;
    [self sendRequestOfOrderDetails];
}

- (void)refreshUI
{
    self.storeNameLabel.text = self.seatOrderModel.store_name;
    self.stateLabel.text =[self.seatOrderModel orderStatusString];
    self.peopleCountLabel.text = [NSString stringWithFormat:@"%@人",self.seatOrderModel.order_man];
    self.timeLabel.text = [self.seatOrderModel orderTimeOfForamtAndAppendWeekday];
    self.peopleNameLabel.text = self.seatOrderModel.user_name;
    self.markTextView.text = self.seatOrderModel.content;
    self.phoneLabel.text = self.seatOrderModel.user_mobile;
    self.markView.hidden = [self.seatOrderModel.content length]!=0?NO:YES;
    self.tableTypeLabel.text = self.seatOrderModel.seat_name ;
    self.optionBtn.hidden = [self.seatOrderModel isCancelOrder]?NO:YES;
    UIScrollView *scrollView = (UIScrollView *)self.contentView;
    [scrollView setContentSize:CGSizeMake(scrollView.width, self.markView.bottom+SeatDetail_BottomEdage)];//超出屏幕将滑动
}
//获取订单详情信息
-(void) sendRequestOfOrderDetails
{
    [SeatOrderDetailsRequest requestWithParameters:@{@"user_id":[AccountHelper uid] , @"order_id" : self.orderModel.order_id,@"order_type":self.orderModel.order_type} withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request)
     {
         if (request.isSuccess)
         {
             SeatOrderModel *seatModel = request.resultDic[KRequestResultDataKey];
            self.seatOrderModel= seatModel ;
            self.contentView.hidden = NO ;
            [self refreshUI];
         }else
         {
             if (request.resultDic)
             {
                 [self showServerErrorPromptView];
             }else
             {
                 [self showNetErrorPromptView];
             }
         }
     } onRequestFailed:^(ITTBaseDataRequest *request)
     {
         [self showNetErrorPromptView];
     }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)optionBtnClcik:(UIButton *)sender {
    [[MessageAlertView viewFromXIB] showAlertViewInView:self.view msg:@"您确定要撤销您预订的座位？" cancelTitle:@"取消" confirmTitle:@"确定" onCanleBlock:nil onConfirmBlock:^{
        
        [self sendRequestOfCanceOrder];
    }];

}
-(void) sendRequestOfCanceOrder
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.seatOrderModel.order_id forKey:@"order_id"];
    [params setObject:[AccountHelper uid] forKey:@"user_id"];
    
    [CancelOrderRequest requestWithParameters:params withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request)
     {
         if (request.isSuccess)
         {
             [self postNotificaitonName:KOrderListRefreshNotification];
             [BDKNotifyHUD showSmileyHUDWithText:@"已撤销" completion:^{
                 [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshOrdersListNotification object:nil ];
                 [self sendRequestOfOrderDetails];
             }];
         }else
         {
             NSString *msg = request.resultDic[@"msg"];
             [BDKNotifyHUD showCryingHUDWithText:[NSString isBlankString:msg] ? @"撤单失败" : msg];
         }
         
     } onRequestFailed:^(ITTBaseDataRequest *request)
     {
         [BDKNotifyHUD showCryingHUDWithText:@"撤单失败"];
     }];
}

//取消订单

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
