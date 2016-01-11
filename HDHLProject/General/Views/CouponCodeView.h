//
//  CouponCodeView.h
//  Carte
//
//  Created by ligh on 14-9-9.
//
//

#import "XibView.h"
#import "ExpenseCodeModel.h"

@interface CouponCodeView : XibView


@property (retain, nonatomic) IBOutlet UILabel *couponCodeLabel;//团购码
@property (retain, nonatomic) IBOutlet UILabel *statusLabel;//状态


-(void) setExpenseCodeModel:(ExpenseCodeModel *) expenseCodeModel;


@end
