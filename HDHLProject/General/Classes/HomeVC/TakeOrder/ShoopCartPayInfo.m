//
//  ShoopCartHelper.m
//  Carte
//
//  Created by ligh on 14-5-7.
//
//

#import "ShoopCartPayInfo.h"
#import "ActivityModel.h"
#import "VoucherModel.h"


@implementation ShoopCartPayInfo

-(void)dealloc
{
    RELEASE_SAFELY(_couponsString);
    RELEASE_SAFELY(_payInfoString);
    RELEASE_SAFELY(_productArray);
    RELEASE_SAFELY(_storeModel);
    RELEASE_SAFELY(_voucherModelArray);
    RELEASE_SAFELY(_activitysModelArray);
}

- (Product *) generateProductInfo
{
    Product *product = [[Product alloc] init];
    product.price = [self payPrice];
    
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
    for (GoodsModel *goodsModel in _productArray)
    {
        [productIntro appendString:goodsModel.goods_name];
        [productIntro appendString:@"-"];
    }
    
    [productIntro deleteCharactersInRange:NSMakeRange(productIntro.length - 1,1)] ;
    [productIntro appendString:@"]"];
    product.body = productIntro;

    return product;
}

- (NSString *)productPayString
{
    NSString *pricePay = @"";
    for (GoodsModel *goodsModel in self.productArray) {
        if (goodsModel.productType == GoodsProductType) {
            if (goodsModel.selectedNumber) {
                pricePay = [NSString stringWithFormat:@"%.2f",goodsModel.selectedNumber*goodsModel.goods_price.floatValue+pricePay.floatValue];
            }
        }
    }
    if (pricePay.floatValue <= 0) {
        pricePay = @"0.00";
    }
    return pricePay;
}

-(NSString *)payInfoString
{
    
    //[self calculatePayInfo];
    
//     int goodsCount = _product_count;
    float shopPrice = _service_shopprice == 0 ?  _shop_price : [self payPrice];
    float dicountPrice = _discount_price;
    
    
//    NSString *goodsTotalCountString  =[NSString stringWithFormat:@"%d",goodsCount]; ////菜品总数
    NSString *totalPriceString  = [NSString stringWithFormat:@"%.0f",shopPrice]; //总价
    NSString *discountString    = [NSString stringWithFormat:@"%.0f",dicountPrice]; //折扣
    
    
    //计算是否显示小数点
//    if ((shopPrice - (int)shopPrice) > 0.0)
//    {
        totalPriceString  = [NSString stringWithFormat:@"%.2f",shopPrice]; //总价
//    }
    //计算实付显示小数点
    if ((dicountPrice - (int)dicountPrice) > 0.0)
    {
        discountString  = [NSString stringWithFormat:@"%.2f",dicountPrice]; //总价
    }
    
//    NSString *text =  [NSString stringWithFormat:@"<font size=18 color=%@>%@</font>",[ColorForHexKey(AppColor_Amount1) hexStringFromColor],totalPriceString];
    
    return totalPriceString;
}


-(NSString *)goodsJSONString
{
    //用户购买的菜品
    NSMutableString *goodsParms = [NSMutableString stringWithString:@"{"];
    for (GoodsModel *goodsModel in _productArray)
    {
        //如果是赠品或者非菜品 则不加入json串
        if (goodsModel.is_gift.intValue ==1 ||  goodsModel.productType == SendGoodsServiceProductType || goodsModel.productType == BoxProductType || goodsModel.productType == ServiceMoneyProductType)
        {
            continue;
        }
        
        [goodsParms appendString:[NSString stringWithFormat:@"\"%@\":%d,",goodsModel.goods_id, (int)goodsModel.selectedNumber]];
    }
    [goodsParms deleteCharactersInRange:NSMakeRange(goodsParms.length-1,1)];
    [goodsParms appendString:@"}"];

    return goodsParms;
}


-(NSString *)voucherJSONString
{
    //用户选中的代金卷
    NSArray *voucherModelArray = self.voucherModelArray;
    
    if (voucherModelArray.count > 0)
    {
        NSMutableString *voucherParams = [NSMutableString string];
        
        for (VoucherModel *voucherModel in voucherModelArray)
        {
            [voucherParams appendFormat:@"%@,",voucherModel.ID];
        }
        
        [voucherParams deleteCharactersInRange:NSMakeRange(voucherParams.length-1,1)];
    
        return voucherParams;
    }
    
    return @"";

}

- (NSString *)activitysJSONString
{
    NSArray *activitysModelArray = self.activitysModelArray;
    if (activitysModelArray.count > 0) {
        
        NSMutableString *activitysParams = [NSMutableString string];
        
        for (ActivityModel *activityModel in activitysModelArray) {
            [activitysParams appendFormat:@"%@,",activityModel.activity_id];
        }
        [activitysParams deleteCharactersInRange:NSMakeRange(activitysParams.length-1,1)];
        
        return activitysParams;
    }
    return @"";
}

- (float)payPrice
{  
    float shopPrice  = self.service_shopprice; //  + [self sendMoney] + [self box_money];
   
//    //减免代金劵
//    for (VoucherModel *voucherModel in _voucherModelArray)
//    {
//        if ([voucherModel.coupon_type isEqual:@"1"]) {
//            shopPrice -= MIN(shopPrice, voucherModel.coupon_value.floatValue);
//
//        }else if ([voucherModel.coupon_type isEqual:@"2"]){
//            float str2 = voucherModel.coupon_value.floatValue/100;
//            shopPrice = shopPrice * str2;
//        }
//    }
    
    shopPrice -= _couponsTotalPay;
    
    //服务费
    shopPrice += _service_money;
    
    return shopPrice;
}

+ (NSArray *)filterGoodsCategoryArray:(NSArray *) goodsCategoryArray {
    NSMutableArray *allGoodsCategoryArray = [NSMutableArray array];
    for (GoodsCategoryModel *goodsCategory in  goodsCategoryArray) {
        
        NSMutableArray *allGoodsArray = [NSMutableArray array];
        for (GoodsModel *goodsModel in goodsCategory.goods) {
            if (goodsModel.count > 0) {
                goodsModel.selectedNumber = goodsModel.count;
            }
            [allGoodsArray addObject:goodsModel];
        }
        
        goodsCategory.goods = (NSArray *)allGoodsArray;
        [allGoodsCategoryArray addObject:goodsCategory];
    }
    return allGoodsCategoryArray;
}

+ (NSMutableArray *)filterSelectedArrayFromGoodsCategoryArray2:(NSArray *)array2 {
    NSMutableArray *selectedGoodsArray = [NSMutableArray array];
    for (GoodsCategoryModel *goodsCategory in array2) {
        NSArray *goodsArray = goodsCategory.goods;
        for (GoodsModel *goodsModel in goodsArray) {
            if (goodsModel.count > 0) {
                [selectedGoodsArray addObject:goodsModel];
            }
        }
    }
    return selectedGoodsArray;
}

+ (NSMutableArray *)filterSelectedWithGoodsCategoryArray:(NSArray *)goodsCategoryArray
{
    
    NSMutableArray *selectedGoodsArray = [NSMutableArray array];
    
    for (GoodsCategoryModel *goodsCategory in  goodsCategoryArray)
    {
        NSArray *goodsArray = goodsCategory.goods;
        for (GoodsModel *goodsModel in goodsArray)
        {
            if (goodsModel.selectedNumber > 0)
            {
                [selectedGoodsArray addObject:goodsModel];
            }
        }
    }
    return selectedGoodsArray;
}

+ (NSMutableArray *)clearFilterSelectedWithGoodsCategoryArray:(NSArray *) goodsCategoryArray {
    NSMutableArray *clearSelGoodsArray = [NSMutableArray array];
    for (GoodsCategoryModel *goodsCategory in  goodsCategoryArray) {
        NSMutableArray *goodsArray = [NSMutableArray arrayWithArray:goodsCategory.goods];
        for (int s = 0; s < goodsArray.count; s ++) {
            GoodsModel *goodsModel = (GoodsModel *)goodsArray[s];
            if (goodsModel.selectedNumber > 0) {
                goodsModel.selectedNumber = 0;
                [goodsArray replaceObjectAtIndex:s withObject:goodsModel];
            }
        }
        goodsCategory.goods = (NSArray  *)goodsArray;
        [clearSelGoodsArray addObject:goodsCategory];
    }
    return clearSelGoodsArray;
}

+(ShoopCartPayInfo *)shoopCartPayInfoWithGoodsCategoryArray:(NSArray *)goodsCategoryArray
{
    return [self shoopCartPayInfoWithGoodsArray:[self filterSelectedWithGoodsCategoryArray:goodsCategoryArray]];
}


+(ShoopCartPayInfo *)shoopCartPayInfoWithGoodsArray:(NSArray *)goodsArray
{
    ShoopCartPayInfo *payInfo = [[ShoopCartPayInfo alloc] init];
    payInfo.sendType = SendOrder;
    payInfo.productArray = [NSMutableArray arrayWithArray:goodsArray];
    return payInfo;
}


-(void)setProductArray:(NSMutableArray *)productArray
{
    if (productArray != _productArray) {
        RELEASE_SAFELY(_productArray);
        _productArray = productArray;
    }
    
    [self calculatePayInfo];
}


-(void)calculatePayInfo
{
    int goodsCount = 0;
    //实付金额
    float shopPrice = 0;
    //市场价格
    float marketPrice = 0;
    //菜品金额
    float goodsAmount = 0;
    
    for (GoodsModel *goodsModel in self.productArray)
    {
        if (goodsModel.productType == GoodsProductType)
        {
            goodsCount += goodsModel.selectedNumber;
            
            goodsAmount += [goodsModel.goods_price floatValue] * goodsModel.selectedNumber;
        }
        
        if (goodsModel.selectedNumber > 0)
        {
            shopPrice += [goodsModel.goods_price floatValue] * goodsModel.selectedNumber;
            marketPrice += [goodsModel.market_price floatValue] * goodsModel.selectedNumber;
        }
    }
    
    
    shopPrice += [self service_money];//服务费不参与打折
    
    shopPrice += [self sendMoney];
    shopPrice += [self box_money];
    
    
    //折扣价
    float dicountPrice = marketPrice - shopPrice;
    self.shop_price = shopPrice;
    self.original_shopprice = shopPrice;
    self.discount_price = dicountPrice;
    self.product_count = goodsCount;
    self.market_price = marketPrice;
    self.goodsAmount = goodsAmount;
 
    
}


-(int)product_count
{
//    return _productArray.count;
    int goodsCount = 0;
    for (GoodsModel *goodsModel in self.productArray) {
        if (goodsModel.productType == GoodsProductType) {
            goodsCount += goodsModel.selectedNumber;
        }
    }
    return goodsCount;
}

-(float)sendMoney
{
    //如果是送餐
    if (_takeOrderType == TakeOrderOutType && _sendType == SendOrder && _sendRuelsModel)
    {
        return _sendRuelsModel.send_price.floatValue;
    }
    
    return 0;
}

-(float)box_money
{
    if (_takeOrderType == TakeOrderOutType && _sendRuelsModel)
    {
        return _sendRuelsModel.box_price.floatValue;
    }
    
    return 0;
}



////计算活动减免 暂时不用
//-(void) calculateActivityReduceAmount
//{
//
//    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"order_by" ascending:YES];
//    NSArray *activityVouchorModelArray =  [_acitityArray sortedArrayUsingDescriptors:@[sortDescriptor]];
//    
//    float shopPrice = self.original_shopprice; //取出原价
//    
//    float activityReduceAmount  = 0;
//    
//    
//    for (id acitityOrVoucherModel in activityVouchorModelArray)
//    {
//        //如果是活动
//        if ([acitityOrVoucherModel isKindOfClass:[ActivityModel class]])
//        {
//            ActivityModel *activityModel = acitityOrVoucherModel;
//
//            if (![NSString isBlankString:activityModel.discount])//如果享受打折
//            {
//                //打折
//                float discountAmount = shopPrice * activityModel.discount.floatValue;
//                activityReduceAmount+= discountAmount;
//                shopPrice -= discountAmount;
//                
//            }else
//            {
//                //减免
//                activityReduceAmount+= MIN(shopPrice, activityModel.action_value.floatValue);
//                shopPrice -= MIN(shopPrice, activityModel.action_value.floatValue);
//            }
//    
//        }else
//        {
//            //代金卷减免
//             VoucherModel *voucherModel = acitityOrVoucherModel;
//             shopPrice -= MIN(shopPrice, voucherModel.coupon_value.floatValue);
//        }
//        
//        if(shopPrice <=0)
//            break;
//    }
//    
//    
//    shopPrice += _service_money;//服务费不参与打折
//    
//    _shop_price = shopPrice;
//    _activityReduceAmount =  activityReduceAmount;
//    
//}


@end

