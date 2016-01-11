//
//  SubStoreListVC.h
//  HDHLProject
//
//  Created by hdcai on 15/7/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BetterTableViewVC.h"

#import "StoreListDelegate.h"

@class SubStoreListVC;

@protocol SubStoreListVCDelegate <NSObject>

-(void)storeList:(SubStoreListVC *)subStoreList selectStoreModel:(StoreModel *)model;

@end

/**
 *  分店列表 显示店铺分店
 */
@interface SubStoreListVC : BetterTableViewVC


@property (assign,nonatomic) id <SubStoreListVCDelegate>delegate;

-(id)initWithActionType:(StoreListActionType)actionType withBrandID:(NSString*)brandID withCityName:(NSString *)cityName;
-(StoreListActionType)storeActionType;

@end

