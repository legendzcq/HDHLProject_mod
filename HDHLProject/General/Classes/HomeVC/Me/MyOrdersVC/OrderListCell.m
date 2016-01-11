//
//  OrderListCell.m
//  HDHLProject
//
//  Created by liu on 15/8/3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "OrderListCell.h"
#import "OrderModel.h"

#define  OrderCell_StateLabel_Top 25.0f

static NSArray *stateArray;
@implementation OrderListCell
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self.contentView setBackgroundColor:UIColorFromRGB_BGColor];
        UIView *selectedBackgroundView = [[UIView alloc] init];
        [selectedBackgroundView setBackgroundColor:UIColorFromRGB(233, 233, 233)];
        self.selectedBackgroundView = selectedBackgroundView;
        self.CodeLabel.textColor =ColorForHexKey(AppColor_OrderBottom_Selected);
        self.stateLabel.textColor =ColorForHexKey(AppColor_OrderBottom_Selected);
    }
    
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.width = SCREEN_WIDTH;
    self.messageContentView.layer.borderColor = UIColorFromRGB(220,220,220).CGColor;
    [self.payBtn setBackgroundImage:[UIImage imageNamed:@"list_pay.png"] forState:UIControlStateNormal];
    [self.payBtn setBackgroundImage:[UIImage imageNamed:@"list_pay_click.png"] forState:UIControlStateHighlighted];
    [self disableSelectedBackgroundView];
}

- (void)configerWithDataSource:(id)objectData
{
    if(![objectData isKindOfClass:[OrderModel class]]){
        return ;
    }
    OrderModel *orderModel = objectData;
    self.orderModel = orderModel ;
    self.storeNameLabel.text =orderModel.store_name;
    self.CodeLabel.text = orderModel.expense_sn;
    self.priceLabel.text =[orderModel.order_type intValue] == SeatOrderType?@"订座": [NSString stringWithFormat:@"总价:￥%@", orderModel.order_amount];
    self.dateLabel.text =[self getDateFarmterWithModel:orderModel];
    self.stateLabel.text = [orderModel orderStatusString];
    [self layoutCellSubviewsWithModel:orderModel];
}
- (NSString *)getDateFarmterWithModel:(OrderModel *)orderModel
{
    return [orderModel.order_type intValue]==DishOrderType? [orderModel orderTimeOfForamt]:[orderModel orderTimeOfForamtAndAppendWeekday
];
}

- (void)layoutCellSubviewsWithModel:(OrderModel *)orderModel
{
    if([orderModel.order_type intValue] == SeatOrderType)//订座类型的布局
    {
        self.payBtn.hidden = YES ;
        self.CodeLabel.hidden = YES ;
        self.stateLabel.centerY = self.messageContentView.centerY;
    }else
    {
        self.payBtn.hidden = NO ;
        self.CodeLabel.hidden = NO ;
        self.stateLabel.top = OrderCell_StateLabel_Top;
        BOOL showPayButton = [orderModel isAgainPay];
        if(showPayButton)
        {
            self.payBtn.hidden = NO ;
            self.CodeLabel.hidden = YES ;
        }else{
            self.payBtn.hidden = YES ;
            self.CodeLabel.hidden = NO ;
        }
    }
    //判断状态是否居中
    if([self  failureWithString:self.stateLabel.text])//订座类型的布局
    {
        self.stateLabel.textColor =[self.stateLabel.text isEqualToString:@"已结账"]?ColorForHexKey(AppColor_OrderBottom_Selected): [UIColor lightGrayColor];
        self.stateLabel.centerY = self.messageContentView.centerY;
        self.CodeLabel.hidden = YES;
    }else{
        if([orderModel.order_type intValue] == SeatOrderType)
        {
            self.stateLabel.centerY = self.messageContentView.centerY;
        }else{
            self.stateLabel.textColor = ColorForHexKey(AppColor_OrderBottom_Selected);
            self.stateLabel.top = OrderCell_StateLabel_Top;
        }
    }
}

//区分这四种状态
- (BOOL)failureWithString:(NSString *)stateString
{
    if(!stateArray.count){
        stateArray = [[NSArray alloc]initWithObjects:@"已到店",@"已取消",@"已过期",@"已结账", nil];
    }
    return  [stateArray containsObject:stateString];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)payBtnClick:(UIButton *)sender
{
    if(self.payDelegate && [self.payDelegate respondsToSelector:@selector(startToPayWithModel:)])
    {
        [self.payDelegate startToPayWithModel:self.orderModel];
    }
}

@end
