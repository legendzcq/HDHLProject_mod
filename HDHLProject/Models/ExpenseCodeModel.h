//
//  ExpenseCodeModel.h
//  Carte
//
//  Created by ligh on 14-9-10.
//
//

#import "BaseModelObject.h"

//消费码model(暂时用在团购卷消费码中)
@interface ExpenseCodeModel : BaseModelObject

 @property (retain,nonatomic) NSString *expense_sn;//消费码序列号
 @property (retain,nonatomic) NSString *expense_sn_status; //消费码状态 （0，1）

-(NSString *) expenseSNStatusString;

@end
