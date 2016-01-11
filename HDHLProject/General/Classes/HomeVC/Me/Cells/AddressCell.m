//
//  AddressCell.m
//  Carte
//
//  Created by ligh on 14-4-9.
//
//

#import "AddressCell.h"

#import "TakeoutAddressModel.h"

@interface AddressCell()
{

    //选中状态Button
    IBOutlet UIButton   *_checkButton;
    
    IBOutlet UILabel    *_userNameLabel;//用户名
    
    IBOutlet UILabel    *_phoneLabel;//手机
    
    IBOutlet UILabel    *_addressLabel;//地址
    
    IBOutlet UIButton  *_defaultAddressButton;//是否为默认地址

}
@end

@implementation AddressCell


- (void)dealloc
{
    RELEASE_SAFELY(_checkButton);
    RELEASE_SAFELY(_userNameLabel);
    RELEASE_SAFELY(_phoneLabel);
    RELEASE_SAFELY(_addressLabel);
    RELEASE_SAFELY(_defaultAddressButton);
    
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self loadColorConfig];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    [self disableSelectedBackgroundView];
}


-(void) loadColorConfig
{
    _userNameLabel.textColor = ColorForHexKey(AppColor_Content_Text3);
    _phoneLabel.textColor = ColorForHexKey(AppColor_Content_Text3);
    _addressLabel.textColor = ColorForHexKey(AppColor_Content_Text3);
}

-(void)setCellData:(id)cellData
{
    [super setCellData:cellData];
    
    TakeoutAddressModel *addressModel = cellData;
    _userNameLabel.text = addressModel.username;
    _phoneLabel.text = addressModel.mobile;
    _addressLabel.text = addressModel.address;
    _defaultAddressButton.enabled = !addressModel.default_address.intValue;
}

-(void)setChecked:(BOOL)check
{
    _checkButton.enabled = !check;
}

-(BOOL)isChecked
{
    return _checkButton.selected;
}

#pragma mark ViewActions

//选中
- (IBAction)checkboxAction:(id)sender
{
    [self setChecked:!_checkButton.enabled];
    if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(addressCell:checkStatusChanged:)])
    {
       [_actionDelegate addressCell:self checkStatusChanged:_checkButton.enabled];
    }
}

//编辑事件
- (IBAction)editAction:(id)sender
{
    if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(addressCellEditAction:)])
    {
        [self pullbackSwipeContentViewAnimationd:YES completion:^{
            
            [_actionDelegate addressCellEditAction:self];
            
        }];
        
    }
}


//删除事件
- (IBAction)delAction:(id)sender
{
    if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(addressCellDelAction:)])
    {
        
        [self pullbackSwipeContentViewAnimationd:YES completion:^{
            
            [_actionDelegate addressCellDelAction:self];
            
        }];
    }

}


@end
