//
//  ExpenseCodeModel.m
//  Carte
//
//  Created by ligh on 14-9-10.
//
//

#import "ExpenseCodeModel.h"

@implementation ExpenseCodeModel

-(void)dealloc
{
    RELEASE_SAFELY(_expense_sn);
    RELEASE_SAFELY(_expense_sn_status);
}


-(NSDictionary *)attributeMapDictionary
{
    return @{@"expense_sn":@"expense_sn",@"expense_sn_status":@"expense_sn_status"};
}


-(NSString *) expenseSNStatusString
{
    if ([self enableOfExpenseSN])
    {
        
        int statusCodeIntValue = [_expense_sn_status intValue];
        
        if (statusCodeIntValue == ExpenseUnUseStatus)
            return @"未使用";
        else  if (statusCodeIntValue == ExpenseUsedStatus)
            return @"已使用";
        else  if (statusCodeIntValue == ExpenseExpiredStatus)
            return @"已过期";
        else  if (statusCodeIntValue == ExpenseDisableStatus)
            return @"已作废";
    }
    return @"";
}

-(BOOL)enableOfExpenseSN
{
    if(!_expense_sn_status || [NSString isBlankString:_expense_sn_status])
    {
        return NO;
    }
    
    return ![NSString isBlankString:_expense_sn];
}

@end
