//
//  AddressPopUpBoxView.h
//  Carte
//
//  Created by ligh on 14-12-15.
//
//

#import "XibView.h"
#import "TakeoutAddressModel.h"
#import "UserModel.h"

@protocol AddressPopUpBoxDelegate <NSObject>

- (void)addAddressWithName:(NSString *)name phone:(NSString *)phone address:(NSString *)address;
@end

@interface AddressPopUpBoxView : XibView

@property (nonatomic, assign) id <AddressPopUpBoxDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIButton *addAddressButton;
- (void)showInView:(UIView *)inView;
- (void)showInView:(UIView *)inView withTitle:(NSString *)title;
- (void)setAddressInfoWith:(TakeoutAddressModel *)model; //添加位置信息
- (void)setUserInfoWith:(UserModel *)userModel; //用户新建地址添加用户信息

@end
