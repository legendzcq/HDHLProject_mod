//
//  OtherStoreInfoCell.m
//  Carte
//
//  Created by user on 14-4-14.
//
//

#import "OtherStoreInfoCell.h"
#import "StoreModel.h"

@interface OtherStoreInfoCell()<UIActionSheetDelegate>
{

    IBOutlet UILabel        *_storeNameLabel;
    
    
    IBOutlet UILabel        *_addressLabel;
 
    
}
@end


@implementation OtherStoreInfoCell

- (void)dealloc
{
    RELEASE_SAFELY(_storeNameLabel);
    RELEASE_SAFELY(_addressLabel);
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    [self disableSelectedBackgroundView];
    
    _storeNameLabel.textColor = ColorForHexKey(AppColor_First_Level_Title1);
    _addressLabel.textColor  = ColorForHexKey(AppColor_Content_Text1);
}


-(void)setCellData:(id)cellData
{
     StoreModel *storeModel = (StoreModel *)cellData;
    if (![NSString isBlankString:storeModel.brand_name]) {
        _storeNameLabel.text = [NSString stringWithFormat:@"%@(%@)",storeModel.brand_name,storeModel.store_name];
    }else{
        _storeNameLabel.text = storeModel.store_name;
    }
    
    _addressLabel.text = storeModel.address;
    
}

/**
 *  联系商家
 *
 *  @param sender <#sender description#>
 */
- (IBAction)callPhone:(id)sender
{

    StoreModel *storeModel = (StoreModel *)self.cellData;
 
   NSArray *mobileArray = [PhoneNumberHelper parseText:storeModel.phone];

    
    if (mobileArray && mobileArray.count>1)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
        for (NSString *mobile in mobileArray)
        {
            [actionSheet addButtonWithTitle:mobile];
        }
        
        
        [actionSheet addButtonWithTitle:@"取消"];
        
        [actionSheet showInView:KAPP_WINDOW];
        
    }else
    {
        if (!mobileArray.count) {
            return;
        }
        [PhoneNumberHelper callPhoneWithText:mobileArray[0]];
    }

}

#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *mobile = [actionSheet buttonTitleAtIndex:buttonIndex];
    [PhoneNumberHelper callPhoneWithText:mobile];
}

@end
