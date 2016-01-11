//
//  MyStoreBalanceModel.h
//  Carte
//
//  Created by liu on 15-4-14.
//
//

#import "BaseModelObject.h"

@interface MyStoreBalanceModel :BaseModelObject

@property (retain,nonatomic) NSString *storeName;         //商店名字
@property (retain,nonatomic) NSString *balabce;     //余额
@property (retain,nonatomic) NSString *image_url;     //图片地址


@end
