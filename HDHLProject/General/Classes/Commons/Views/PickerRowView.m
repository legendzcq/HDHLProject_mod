//
//  TakeOrderPickerRowView.m
//  Carte
//
//  Created by ligh on 14-4-14.
//
//

#import "PickerRowView.h"

@interface PickerRowView()
{

    IBOutlet UILabel    *_titleLabel;
    
}
@end

@implementation PickerRowView

- (void)dealloc
{
    RELEASE_SAFELY(_titleLabel);
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    _titleLabel.textColor = ColorForHexKey(AppColor_Select_Box_Text4);
}

-(void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}

@end
