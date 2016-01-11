//
//  NewAddressVC.h
//  Carte
//
//  Created by ligh on 14-4-4.
//
//

#import "BetterVC.h"
#import "TakeoutAddressModel.h"

@protocol EditAddressVCDelegate;


/**
 * 新建地址
 */
@interface EditAddressVC : BetterVC

//编辑地址
-(id) initWithAddressModel:(TakeoutAddressModel *) addressModel;

@property (assign,nonatomic) id<EditAddressVCDelegate> actionDelegate;


@end


@protocol EditAddressVCDelegate <NSObject>

-(void) editAddressVC:(EditAddressVC *) addressListVC addressModel:(TakeoutAddressModel *) addressModel;

@end