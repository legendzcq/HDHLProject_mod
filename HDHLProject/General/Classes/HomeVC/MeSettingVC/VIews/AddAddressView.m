//
//  AddAddressView.m
//  Carte
//
//  Created by zln on 15/1/8.
//
//

#import "AddAddressView.h"

@implementation AddAddressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [_addAddressButton setTitleColor:ColorForHexKey(AppColor_Defaule_Hollow_Button_Text2) forState:UIControlStateNormal];
    
}

- (void)dealloc {
    RELEASE_SAFELY(_addAddressButton);
}
@end
