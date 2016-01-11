//
//  GoodsCategoryModel.m
//  Carte
//
//  Created by ligh on 14-5-5.
//
//

#import "GoodsCategoryModel.h"

@implementation GoodsCategoryModel

- (void)dealloc
{
    RELEASE_SAFELY(_cate_id);
    RELEASE_SAFELY(_cate_name);
    RELEASE_SAFELY(_goods);
}

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super initWithDictionary:dict];
    if (self) {
        self.cate_id = [dict stringForKey:@"cate_id"];
        self.cate_name = [dict stringForKey:@"cate_name"];
        NSArray *goodsArray = [dict arrayForKey:@"goods"];
        self.goods = [GoodsModel reflectArrayWithInitWithDictionary:goodsArray];
        }
    return self;
}

- (Class)elementClassForArrayKey:(NSString *)key {
    if ([key isEqualToString:@"goods"]) {
        return [GoodsModel class];
    }
    return [super elementClassForArrayKey:key];
}

@end
