//
//  CouponCodeView.m
//  Carte
//
//  Created by ligh on 14-9-9.
//
//

#import "CouponCodeView.h"

@implementation CouponCodeView

- (void)dealloc
{
    RELEASE_SAFELY(_couponCodeLabel);
    RELEASE_SAFELY(_statusLabel);
}

-(void)setExpenseCodeModel:(ExpenseCodeModel *)expenseCodeModel
{
    _couponCodeLabel.text = expenseCodeModel.expense_sn;
    _statusLabel.text = expenseCodeModel.expenseSNStatusString;
    int status = [expenseCodeModel.expense_sn_status intValue];
    if (status == ExpenseUnUseStatus)//如果团购卷未使用
    {
        _couponCodeLabel.textColor =  ColorForHexKey(AppColor_Default_Promotion_Code);
        _statusLabel.textColor =  ColorForHexKey(AppColor_Order_Status_Text);
        
    }else
    {
        _couponCodeLabel.textColor =  ColorForHexKey(AppColor_Gray_Promotion_Code);
        _statusLabel.textColor =  ColorForHexKey(AppColor_Usage_State_Text);
    }
}

@end
