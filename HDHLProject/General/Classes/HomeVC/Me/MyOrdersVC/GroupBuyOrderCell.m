//
//  GroupBuyOrderCell.m
//  Carte
//
//  Created by ligh on 14-4-10.
//
//

#import "GroupBuyOrderCell.h"
#import "CouponCodeView.h"
#import "GrouponOrderModel.h"

@interface GroupBuyOrderCell()
{

    //订单状态
    
    IBOutlet UILabel     *_orderStatusLabel;
   
    //商家名称
    IBOutlet UILabel     *_grouponNameLabel;

    //购买日期
    IBOutlet UILabel       *_buyDateLabel;
    
    IBOutlet UILabel        *_buyDateTitleLabel;

    
}
@end

@implementation GroupBuyOrderCell

- (void)dealloc
{
    RELEASE_SAFELY(_orderStatusLabel);
    RELEASE_SAFELY(_buyDateLabel);
    RELEASE_SAFELY(_buyDateTitleLabel);
    RELEASE_SAFELY(_grouponNameLabel);
   
    _delegate = nil;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self loadColorConfig];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    _TellFriendButton.hidden = YES ;
    [self disableSelectedBackgroundView];

}

-(void) loadColorConfig
{
    _grouponNameLabel.textColor = ColorForHexKey(AppColor_First_Level_Title1);
       _orderStatusLabel.textColor = ColorForHexKey(AppColor_Order_Status_Text);
    [_ShowGroupCodeButton setTitleColor:ColorForHexKey(AppColor_Default_Button_Text) forState:UIControlStateNormal];
    [_TellFriendButton setTitleColor:ColorForHexKey(AppColor_Default_Button_Text) forState:UIControlStateNormal];
    _buyDateTitleLabel.textColor = ColorForHexKey(AppColor_Content_Text2);
    _buyDateLabel.textColor = ColorForHexKey(AppColor_Content_Text2);
}
-(void)setCellData:(id)cellData
{
    [super setCellData:cellData];
    if(![cellData isKindOfClass: [GrouponOrderModel class]]){
        return;
    }
    GrouponOrderModel *orderModel = cellData;
    self.model = orderModel ;
    
    if(orderModel.order_status.intValue == GrouponOrderPayStatus)
    {
        [_ShowGroupCodeButton setTitle:@"查看消费码" forState:UIControlStateNormal];
        [_ShowGroupCodeButton setBackgroundImage:[UIImage imageNamed:@"order_button_Modify.png"] forState:UIControlStateNormal];
    }else{
        [_ShowGroupCodeButton setTitle:@"在线支付" forState:UIControlStateNormal];
        [_ShowGroupCodeButton setBackgroundImage:[UIImage imageNamed:@"order_button_pay.png"] forState:UIControlStateNormal];
    }
    _grouponNameLabel.text = orderModel.groupon_name;
    _buyDateLabel.text = [orderModel GroupBuyendTimeOfForamt];
   // _buyDateLabel.hidden = orderModel.order_status.intValue == GrouponOrderWaitPayStatus;
    _buyDateTitleLabel.hidden = _buyDateLabel.hidden;
    if(!orderModel.endtime.length){
        _buyDateTitleLabel.hidden  =YES;
        _buyDateLabel.hidden =YES ;
    }
    //只显示订单状态
    _orderStatusLabel.text = [orderModel orderStatusString];
}

- (IBAction)SharedFriendBtnClick:(UIButton *)sender{
    if(self.delegate &&[self.delegate respondsToSelector:@selector(operationWithModel:WithIndex:WithOperationState:)])
    {
        [self.delegate operationWithModel:self.model WithIndex:self.index WithOperationState:ShareFriendOperationState];
    }
}
- (IBAction)checkCodeBtnClick:(UIButton *)sender{
    if(self.delegate &&[self.delegate respondsToSelector:@selector(operationWithModel:WithIndex:WithOperationState:)])
    {
        if(self.model.order_status.intValue == GrouponOrderWaitPayStatus)
        {
        [self.delegate operationWithModel:self.model WithIndex:self.index WithOperationState:GroupBuyOperationState];
        }else {
            [self.delegate operationWithModel:self.model WithIndex:self.index WithOperationState:CheckCodeOperationState];
        }
    }
}


@end
