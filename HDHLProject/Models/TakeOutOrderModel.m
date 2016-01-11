//
//  TakeOutOrderModel.m
//  Carte
//
//  Created by ligh on 14-5-14.
//
//

#import "TakeOutOrderModel.h"

@implementation TakeOutOrderModel


- (void)dealloc
{
    RELEASE_SAFELY(_send_type);
    RELEASE_SAFELY(_send_address)
    RELEASE_SAFELY(_send_time_rel);
    RELEASE_SAFELY(self.share_content);
}


-(id)initWithDictionary:(NSDictionary *)dict
{
    if(self = [super initWithDictionary:dict])
    {
        NSDictionary *otherMoneyDic = dict[@"other_money"];
        if (otherMoneyDic)
        {
        
            self.box_price = otherMoneyDic[@"box_price"];
            self.send_price = otherMoneyDic[@"send_price"];
        }
        
    }
    return self;
}



-(NSString *)sendTypeString
{
    if (_send_type.intValue == SendOrder) {//送餐
        
        return @"送餐";
        
    }else if(_send_type.intValue == SelfServiceOrder)//自提
    {
        return @"自提";
    }
    
    return @"";
}

-(NSString *)orderStatusString
{
    //	送餐：0等待付款	1等待确认	2商家确认	3商家拒绝	4送餐完成 5退款成功
 //     0等待付款 1等待确认 2商家确认 3商家拒绝 4订单完成 7退款中 5退款完成
 //   99订单过期
    NSInteger orderStatusIntValue = self.order_status.integerValue;
    
    if (_send_type.intValue == SendOrder)
    {
    
        if (orderStatusIntValue == TakeOutSendOrderWaitPayStatus)
        {
            return @"等待付款";
            
        } else if (orderStatusIntValue == TakeOutSendOrderWaitConfirmStatus)
        {
            return @"等待确认";
            
        }  else if (orderStatusIntValue == TakeOutSendOrderStoreConfirmStatus)
        {
            return @"商家已确认";
            
        } else if (orderStatusIntValue == TakeOutSendOrderStoreRejectStatus)
        {
            return @"商家拒绝";
            
        }else if (orderStatusIntValue == TakeOutSendOrderSendCompletedStatus)
        {
            return @"送餐完成";
            
        }else if (orderStatusIntValue == TakeOutSendOrderRefundSuccesstatus)
        {
            return @"退款成功";
            
        }else if(orderStatusIntValue == TakeOutSendOrderTheRefund)
        {
            return @"退款中";
        }
        

    }else
    {
        //WaitPayUnValidationStatus = 0, //等待付款(未验)
        //PayUnValidationStatus = 1 ,    //已支付(未验)/等待确认
        //OrderFinshStatus = 2,          //商家确认
        //StoreRefusedStatus =3 ,        //退款完成/商家拒绝
        //OrderRefundFinshStatus =4,     //订单完成
        //WaitPayValidationStatus = 5,   //等待付款(已验)/（退款完成）
        //PayValidationStatus = 6 ,       //已支付(已验)
        //OrderRefundingStatus =7,       //退款中
        //OrderOverdueStatus  = 99      //订单过期
        
        //     0等待付款 1等待确认 2商家确认 3商家拒绝 4订单完成 7退款中 5退款完成
        //   99订单过期
        if (orderStatusIntValue == WaitPayUnValidationStatus)
        {
            return @"等待付款";
            
        } else if (orderStatusIntValue == PayUnValidationStatus)
        {
            if([self.is_cod intValue]==1)
                
            {
                return @"餐到付款";
            }
            return @"等待确认";
            
        }  else if (orderStatusIntValue == OrderFinshStatus)
        {
            return @"商家确认";
            
        } else if (orderStatusIntValue == StoreRefusedStatus)
        {
            return @"商家拒绝";
            
        }else if (orderStatusIntValue == OrderRefundFinshStatus)
        {
            return @"订单完成";
            
        }else if (orderStatusIntValue == WaitPayValidationStatus)
        {
            return @"退款完成";
            
        }else if(orderStatusIntValue == OrderRefundingStatus)
        {
            return @"退款中";
        }else if (orderStatusIntValue == OrderOverdueStatus)
        {
          return @"订单过期";
        }
    }
       return @"";
}



-(BOOL)enableOfExpenseSN
{
    
    if (_send_type.intValue != SelfServiceOrder)
    {
        return NO;
    }
    
    if(!self.expense_sn_status || [NSString isBlankString:self.expense_sn_status])
    {
        return NO;
    }

    //只有商家确认的状态下 才显示消费码
    NSInteger orderStatusIntValue = self.order_status.integerValue;
    
    return ((orderStatusIntValue == TakeOutSendOrderStoreConfirmStatus)  ||(orderStatusIntValue == TakeOutSelfServiceStoreConfirmStatus));
    
}

-(BOOL)isCancelOrder
{
    int orderStatusIntValue = self.order_status.intValue;
    
    return orderStatusIntValue == TakeOutSendOrderWaitConfirmStatus || 

                orderStatusIntValue == TakeOutSelfServiceWaitConfirmStatus ;

}

-(BOOL)isAgainPay
{
    int orderStatusIntValue = self.order_status.intValue;
    
    return orderStatusIntValue == TakeOutSendOrderWaitPayStatus || orderStatusIntValue == TakeOutSelfServiceOrderWaitPayStatus;
}

-(NSString *)sendTimeOfForamtAndAppendWeekday
{
    
    NSDateComponents *result =  [self componentsWithOrderTime:[_send_time_rel doubleValue]];
    NSInteger minute = [result second] > 0 ? [result minute] + 1 :  [result minute];
    
    NSString *minuteString = (minute==0) ? @"00" : [NSString stringWithFormat:@"%d", (int)minute];
    
    NSString *weekDay = [NSDate weekdayStringWithPrefix:@"周" weekday:[result weekday]];
    
    return [NSString stringWithFormat:@"%d月%d日 %d:%@ %@", (int)[result month], (int)[result day], (int)[result hour],minuteString,weekDay];
}

@end
