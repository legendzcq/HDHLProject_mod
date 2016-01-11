//
//  GoodsModel.m
//  Carte
//
//  Created by ligh on 14-5-5.
//
//

#import "GoodsModel.h"

@implementation GoodsModel


- (void)dealloc
{
    
    RELEASE_SAFELY(_cate_id);
    RELEASE_SAFELY(_issend);
    RELEASE_SAFELY(_goods_id);
    RELEASE_SAFELY(_goods_name);
    RELEASE_SAFELY(_goods_title);
    RELEASE_SAFELY(_image_big);
    RELEASE_SAFELY(_image_small);
    RELEASE_SAFELY(_market_price);
    RELEASE_SAFELY(_goods_price);
    RELEASE_SAFELY(_goods_number);
    RELEASE_SAFELY(_goodsidarr);
    RELEASE_SAFELY(_change_number);
}

- (id)initWithDictionary:(NSDictionary *)dict;
{
    self = [super initWithDictionary:dict];
    if (self) {
        
        self.cate_id     = [dict stringForKey:@"cate_id"];
        self.issend        = [dict stringForKey:@"issend"];
        self.goods_id      = [dict stringForKey:@"goods_id"];
        self.goods_name   = [dict stringForKey:@"goods_name"];
        self.goods_title = [dict stringForKey:@"goods_title"];
        self.goods_py       = [dict stringForKey:@"goods_py"];
        self.goods_szm      = [dict stringForKey:@"goods_szm"];
        self.image_big      = [dict stringForKey:@"image_big"];
        self.image_small      = [dict stringForKey:@"image_small"];
        self.market_price      = [dict stringForKey:@"market_price"];
        self.goods_price      = [dict stringForKey:@"goods_price"];
        self.goodsidarr      = [dict stringForKey:@"goodsidarr"];
        self.goods_units      = [dict stringForKey:@"goods_units"];
        self.is_gift      = [dict stringForKey:@"is_gift"];
        self.is_sale      = [dict stringForKey:@"is_sale"];
        self.max_num      = [dict stringForKey:@"max_num"];
        self.change_number      = [dict stringForKey:@"change_number"];
        self.goods_desc      = [dict stringForKey:@"goods_desc"];
        self.goods_activity      = [dict stringForKey:@"goods_activity"];

        self.goods_number = [dict stringForKey:@"goods_number"];
        self.count = [dict integerForKey:@"count"];
        self.selectedNumber = self.count;
        
        self.productType = GoodsProductType;//默认是菜品

    }
    return self;
}

-(NSString *)goods_number
{
    if (_goods_number == nil || _goods_number.intValue == 0) {
        return [NSString stringWithFormat:@"%d", (int)_count];
    }
    return _goods_number;
}


-(BOOL)isEqual:(id)object
{
    GoodsModel *goodsModel = object;
    
    if (goodsModel == self)
    {
        return YES;
    }
    
    if (goodsModel.productType == BoxProductType || goodsModel.productType == SendGoodsServiceProductType)
    {
        if (self.productType == goodsModel.productType)
        {
            return YES;
        }
    }
    return goodsModel == self || [goodsModel.goods_id isEqualToString:self.goods_id];
}

@end
