//
//  OrderListCell.h
//  HDHLProject
//
//  Created by liu on 15/8/3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BetterTableCell.h"
#import "OrderModel.h"


@protocol PayBtnDelegate <NSObject>

- (void)startToPayWithModel:(OrderModel *)orderModel;

@end

@interface OrderListCell : BetterTableCell

// 店铺名称
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
// 名称
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
// 日期
@property (weak, nonatomic) IBOutlet UIView *messageContentView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
// 状态
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
// 验证码
@property (weak, nonatomic) IBOutlet UILabel *CodeLabel;
// 店铺信息model
@property (nonatomic,strong) OrderModel *orderModel;
// 代理
@property (nonatomic,assign) id<PayBtnDelegate>payDelegate;
// 是否能继续支付
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@end
