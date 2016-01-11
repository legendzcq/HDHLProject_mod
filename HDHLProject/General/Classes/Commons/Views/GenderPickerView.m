//
//  GenderPickerView.m
//  Carte
//
//  Created by ligh on 14-6-5.
//
//

#import "GenderPickerView.h"

@interface GenderPickerView()
{
    //男
    IBOutlet UIButton   *maleButton;
    IBOutlet UILabel    *_maleTitleLabel;

    //女
    IBOutlet UIButton   *femaleButton;
    IBOutlet UILabel    *_femalTitleLabel;
    
}
@end

@implementation GenderPickerView


- (void)dealloc
{
    RELEASE_SAFELY(maleButton);
    RELEASE_SAFELY(femaleButton);
    RELEASE_SAFELY(_femalTitleLabel);
    RELEASE_SAFELY(_maleTitleLabel);
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    
    _femalTitleLabel.textColor = ColorForHexKey(AppColor_Select_Box_Text4);
    _maleTitleLabel.textColor = ColorForHexKey(AppColor_Select_Box_Text4);
    
    NSString *genderString = [NSString stringWithFormat:@"%@",[AccountHelper userInfo].gender];
    if (genderString.intValue != 1 && genderString.intValue != 2) {
        genderString = @"1";
    }
    if (genderString)
    {
        maleButton.selected = genderString.intValue == 1;
        femaleButton.selected = genderString.intValue == 2;
    }
}

-(NSString *)genderStringValueOfChecked
{
    return maleButton.selected ? @"1" : @"2";
}

- (IBAction)checkFemalButtonAction:(id)sender
{
    if (maleButton.selected)
    {
        maleButton.selected = NO;
        femaleButton.selected = YES;
    }
}

- (IBAction)checkMaleButtonAction:(id)sender
{
    if (femaleButton.selected)
    {
        maleButton.selected = YES;
        femaleButton.selected = NO;
    }
}


@end
