//
//  CitySelectionView.m
//  Carte
//
//  Created by ligh on 14-3-26.
//
//

#import "CitySelectionView.h"

@interface CitySelectionView()
{

    IBOutlet UILabel *_titleLabel;
}
@end

@implementation CitySelectionView

- (void)dealloc
{
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    _titleLabel.textColor = ColorForHexKey(AppColor_Spinner_Text2);
}

-(void)setCityTitle:(NSString *)cityTitle
{
    _titleLabel.text = cityTitle;
}

@end
