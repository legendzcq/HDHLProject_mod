//
//  SetAddressVC.h
//  HDHLProject
//
//  Created by liu on 15/8/5.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BetterVC.h"

typedef void(^AdrressBlock)(NSString *adress,NSString *city);

@interface SetAddressVC : BetterVC

@property(nonatomic,copy)AdrressBlock adressBlock;
@end
