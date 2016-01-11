//
//  SeatOrderModel.m
//  Carte
//
//  Created by ligh on 14-4-29.
//
//

#import "OrderModel.h"

@implementation OrderModel

-(void)dealloc
{
    RELEASE_SAFELY(_order_id);
    RELEASE_SAFELY(_store_id);
    RELEASE_SAFELY(_store_name);
    RELEASE_SAFELY(_address);
    RELEASE_SAFELY(_image_big);
    RELEASE_SAFELY(_image_small);
    RELEASE_SAFELY(_order_time);
    RELEASE_SAFELY(_order_status);
    RELEASE_SAFELY(_order_amount);
    RELEASE_SAFELY(_order_man);
    RELEASE_SAFELY(_payment_name);
    RELEASE_SAFELY(_pay_time);
    RELEASE_SAFELY(_expense_sn);
    RELEASE_SAFELY(_expense_sn_status);
    RELEASE_SAFELY(_invoice);
    RELEASE_SAFELY(_invoice_title);
    RELEASE_SAFELY(_content);
    RELEASE_SAFELY(_pays);
    RELEASE_SAFELY(_storeModel);
    RELEASE_SAFELY(_service);
    RELEASE_SAFELY(_service_money);
    RELEASE_SAFELY(_phone);
    RELEASE_SAFELY(_user_mobile);
    RELEASE_SAFELY(_user_name);
}

/*
- (NSDictionary*)attributeMapDictionary
{
	return @{
             @"send_price" : @"send_price",
             @"box_price" : @"box_price",
             @"brand_id":@"brand_id",
             @"brand_name":@"brand_name",
             @"goods_count":@"goods_count",
             @"order_id": @"order_id",
             @"store_id": @"store_id",
             @"store_name": @"store_name",
             @"address" : @"address",
              @"image_big": @"image_big",
             @"image_small": @"image_small",
             @"order_time": @"order_time",
             @"order_status": @"order_status",
             @"order_amount":@"order_amount",
             @"order_man" : @"order_man",
             @"phone":@"phone",
             @"payment_name" : @"payment_name",
             @"pay_time" : @"pay_time",
             @"expense_sn" : @"expense_sn",
             @"expense_sn_status" : @"expense_sn_status",
              @"invoice" : @"invoice",
             @"invoice_title" : @"invoice_title",
             @"content" : @"content",
             @"coupon_amount" : @"coupon_amount",
             @"amount_dec" : @"amount_dec",
              @"addtime" : @"addtime",
             @"service" :@"service",
             @"service_money" : @"service_money",
             @"user_mobile":@"user_mobile",
             @"user_name":@"user_name",
             @"bind_pay":@"bind_pay"
             };
}
*/

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super initWithDictionary:dict];
    if (self) {
        
        NSArray *payJSONArray = [dict arrayForKey:@"pays"];
        self.pays = [PayModeModel reflectObjectsWithArrayOfDictionaries:payJSONArray];
        
        NSDictionary *storeDic = [dict dictionaryForKey:@"store"];
        self.storeModel = (StoreModel *)[StoreModel reflectObjectsWithJsonObject:storeDic];
        
    }
    return self;
}

- (Class)elementClassForArrayKey:(NSString *)key {
    if ([key isEqualToString:@"pays"]) {
        return [PayModeModel class];
    }
    if ([key isEqualToString:@"store"]) {
        return [StoreModel class];
    }
    return [super elementClassForArrayKey:key];
}


-(NSString *)expense_snOfFormat
{
    if ([NSString isBlankString:_expense_sn])
    {
        return @"";
    }
    
    NSMutableString *formatString = [NSMutableString string];
    
    for (int i = 0; i<_expense_sn.length ;  i+=4)
    {
        NSString *subString = [_expense_sn substringWithRange:NSMakeRange(i,MIN(4, _expense_sn.length - i))];
        [formatString appendString:subString];
        [formatString appendFormat:@"-"];
    }
    
    [formatString deleteCharactersInRange:NSMakeRange(formatString.length-1, 1)];
    
    return formatString;
}

-(Product *)convert2ProductInfo
{
    Product *product = [[Product alloc] init];
    product.orderId = _order_id;
    product.price = _order_amount.floatValue;
    
    if (_orderType == GrouponOrderType)
    {
        product.subject =  @"团购支付";
        
    } else if(_orderType == TakeOutOrderType)
    {
        product.subject =  @"外卖支付";
        
    } else if(_orderType == DishOrderType)
    {
        product.subject =  @"点菜支付";
        
    }else
    {
        product.subject =  [NSString isBlankString:_store_name] ? @"菜品支付" : _store_name;
    }
    
    product.body =   [NSString isBlankString:_store_name] ? product.subject : [NSString stringWithFormat:@"%@ 菜品支付",_store_name];
    
    return product;
}

-(NSDateComponents *) componentsWithOrderTime:(double) timestamp
{
    NSDate *date =[NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateComponents *result =  [date components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday];
    
    return result;
}

-(NSString *)orderTimeOfForamtAndAppendWeekday
{
    if([NSString isBlankString:_order_time]){
        return  @"";
    }
    NSDateComponents *result =  [self componentsWithOrderTime:[_order_time doubleValue]];
      NSInteger minute =  [result minute];
    
    
    NSString *minuteString = (minute==0) ? @"00" :( minute < 10 ? [NSString stringWithFormat:@"0%d",(int)minute] : [NSString stringWithFormat:@"%d",(int)minute]);
    
    NSString *weekDay = [NSDate weekdayStringWithPrefix:@"周" weekday:[result weekday]];
    
   return [NSString stringWithFormat:@"%d/%d/%d %@ %d:%@",(int)[result  year],(int)[result month],(int)[result day],weekDay,(int)[result hour],minuteString];
   
}

-(NSString *)orderTimeOfForamt
{
    return [[NSDate dateWithTimeIntervalSince1970:[_order_time doubleValue]] stringWithFormat:@"yyyy/MM/dd HH:mm"];
}

-(NSString *)outOrderTimeOfForamt
{
    return [[NSDate dateWithTimeIntervalSince1970:[_order_time doubleValue]] stringWithFormat:@"HH:mm"];
    
    //手动处理时间戳，解决时差8小时问题
//    NSInteger hh = [_order_time doubleValue]/3600;
//    NSInteger mm = ([_order_time doubleValue]-hh*3600)/60;
//    NSString *hhStr = hh<10 ? [NSString stringWithFormat:@"0%d",hh]:[NSString stringWithFormat:@"%d",hh];
//    NSString *mmStr = mm<10 ? [NSString stringWithFormat:@"0%d",mm]:[NSString stringWithFormat:@"%d",mm];
//    return [NSString stringWithFormat:@"%@:%@", hhStr, mmStr];
}

-(NSString *)payTimeOfForamt
{
    return [[NSDate dateWithTimeIntervalSince1970:[_pay_time doubleValue]] stringWithFormat:@"yyyy-MM-dd HH:mm"];
}


-(NSString *)addTimeOfForamt
{
   return [[NSDate dateWithTimeIntervalSince1970:[_addtime doubleValue]] stringWithFormat:@"yyyy-MM-dd HH:mm"];
}

-(BOOL)enableOfExpenseSN
{
    if(!_expense_sn_status || [NSString isBlankString:_expense_sn_status])
    {
        return NO;
    }

    return ![NSString isBlankString:_expense_sn];
}

-(NSString *)expenseSNString
{
    if ([self enableOfExpenseSN])
    {
    
    int statusCodeIntValue = [_expense_sn_status intValue];
        
    if (statusCodeIntValue == ExpenseUnUseStatus)
        
        return [self expense_snOfFormat];
        
    else  if (statusCodeIntValue == ExpenseUsedStatus)
            return @"已使用";
    else  if (statusCodeIntValue == ExpenseExpiredStatus)
            return @"已过期";
    else  if (statusCodeIntValue == ExpenseDisableStatus)
            return @"已作废";
    }
    return @"";
}

-(NSString *) expenseSNString2
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
//WaitPayUnValidationStatus = 0, //等待验证(未验)
//PayUnValidationStatus = 1 ,    //已支付(未验)/等待确认   付款中
//OrderFinshStatus = 2,          //商家确认              已付款/已结束
//StoreRefusedStatus =3 ,        //退款完成/商家拒绝
//OrderRefundFinshStatus =4,     //订单完成
//WaitPayValidationStatus = 5,   //等待付款(已验)/（退款完成） 已到店
//PayValidationStatus = 6 ,       //已支付(已验)
//OrderRefundingStatus =7,       //退款中
//OrderOverdueStatus  = 99,      //订单过期
//OrderCancleStatus =-1          //已取消

-(NSString *)orderStatusString
{
    if([self.pay_status intValue]==1){
        return  @"支付中";
    }
    int codeIntValue = [self.order_status intValue];
    if([self.order_type intValue]== DishOrderType)
    {
        switch (codeIntValue)
        {
            case WaitPayUnValidationStatus://0
                return @"未验证";
                break;
            case OrderRefundFinshStatus://4
                return @"已结账";
                break;
            case WaitPayValidationStatus://5
                return @"已验证"; // 可以点付款
                break;
            case PayValidationStatus://6
                return @"已结账";  //已经付款
                break;
             case OrderOverdueStatus://99
                return @"已过期";
                break;
             case OrderCancleStatus://-1
                return @"已取消";
                break;
            default:
                break;
        }
    }else {
        switch (codeIntValue)
        {
            case WaitPayUnValidationStatus://0
                return @"未确认";
                break;
            case PayUnValidationStatus://1
                return @"已取消";
                break;
            case OrderFinshStatus://2
                return @"已确认";       
                break;
            case StoreRefusedStatus://3
                return @"已取消";
                break;
            case OrderRefundFinshStatus://4
                return @"已取消";
                break;
            case WaitPayValidationStatus://5
                return @"已到店";
                break;
            default:
                break;
        }
    }
    return @"" ;
}


-(BOOL) isCancelOrder
{
    return NO;
}

-(BOOL)isAgainPay
{
    if([self.order_type intValue]== SeatOrderType){
        return NO ;
    }else{
        int codeIntValue = [self.order_status intValue];
        switch (codeIntValue)
        {
            case WaitPayUnValidationStatus://0
                return  NO;
                break;
            case PayUnValidationStatus://1
                return NO;
                break;
            case OrderRefundFinshStatus://4
                return NO;
                break;
            case WaitPayValidationStatus://5
                return YES; // 可以点付款
                break;
            case PayValidationStatus://6
                return NO;  //已经付款
                break;
            case OrderOverdueStatus://99
                return NO;
                break;
            case OrderCancleStatus://-1
                return NO;
                break;
            default:
                break;
        }

    }
    return NO ;
}


//
-(NSString *)goodsJSONString:(NSArray *)goodsArray
{
    //用户购买的菜品
    NSMutableString *goodsParms = [NSMutableString stringWithString:@"{"];
    for (GoodsModel *goodsModel in goodsArray)
    {
        //如果是赠品或者非菜品 则不加入json串
        if (goodsModel.is_gift.intValue ==1 ||  goodsModel.productType == SendGoodsServiceProductType || goodsModel.productType == BoxProductType || goodsModel.productType == ServiceMoneyProductType)
        {
            continue;
        }
        
        [goodsParms appendString:[NSString stringWithFormat:@"\"%@\":%d,",goodsModel.goods_id,(int)goodsModel.selectedNumber]];
    }
    [goodsParms deleteCharactersInRange:NSMakeRange(goodsParms.length-1,1)];
    [goodsParms appendString:@"}"];
    
    return goodsParms;
}

- (Product *)generateProductInfo:(NSArray *)goodsArray
{
    Product *product = [[Product alloc] init];
    
    if (_storeModel) {
        
        NSString *brandName = [NSString isBlankString:_storeModel.brand_name]? @"" : _storeModel.brand_name;
        NSString *storeName = [NSString isBlankString:_storeModel.store_name]? @"" : _storeModel.store_name;
        if (![NSString isBlankString:brandName] && ![NSString isBlankString:storeName]) {
            product.subject = [NSString stringWithFormat:@"%@-%@菜品支付",brandName,storeName];
        } else {
            product.subject = [NSString stringWithFormat:@"%@%@菜品支付",brandName,storeName];
        }
    } else {
        
        product.subject = @"菜品支付";
    }

    NSMutableString *productIntro = [NSMutableString stringWithFormat:@"订单菜品详情"];
    for (GoodsModel *goodsModel in goodsArray)
    {
        [productIntro appendString:goodsModel.goods_name];
        [productIntro appendString:@"-"];
    }
    
    [productIntro deleteCharactersInRange:NSMakeRange(productIntro.length - 1,1)] ;
    [productIntro appendString:@"]"];
    product.body = productIntro;
    
    return product;
}
 
- (int)ordersTotalWithArray:(NSArray *)ordersArray
{
    int totale = 0;
    for (GoodsModel *goodsModel in ordersArray) {
        totale +=[goodsModel.goods_number intValue];
    }
    return totale ;
}

@end
