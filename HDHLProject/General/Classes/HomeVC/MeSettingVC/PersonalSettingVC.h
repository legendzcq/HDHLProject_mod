//
//  PersonalSettingVC.h
//  Carte
//
//  Created by zln on 14/12/15.
//
//

#import "BetterTableViewVC.h"
#import "TakeoutAddressModel.h"

@class PersonalSettingVC;

@protocol AddressListVCDelegate <NSObject>

//选中了某个地址
-(void) addressListVC:(PersonalSettingVC *) addressListVC didSelectedAddress:(TakeoutAddressModel *) addressModel;

@end

@interface PersonalSettingVC : BetterVC

@property (assign,nonatomic) id<AddressListVCDelegate> addressDelegate;



@end



