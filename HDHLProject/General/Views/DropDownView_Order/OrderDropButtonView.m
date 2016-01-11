//
//  OrderDropButtonView.m
//  Carte
//
//  Created by ligh on 14-12-30.
//
//

#import "OrderDropButtonView.h"

@interface OrderDropButtonView ()
{
    IBOutlet UIButton     *_selectButton;
    IBOutlet UIImageView  *_imageView;
    IBOutlet UILabel      *_titleLabel;
    BOOL _selected;
}
@end

@implementation OrderDropButtonView

- (void)dealloc
{
    RELEASE_SAFELY(_selectButton);
    RELEASE_SAFELY(_imageView);
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _selected = YES;
}

- (IBAction)selectedButtonAction:(id)sender
{
    BOOL currentSelected = _selected;
    
    if (currentSelected) {
        _imageView.image = [UIImage imageNamed:@"public_arrow_circle_up"];
        if ([_delegate respondsToSelector:@selector(dropButtonSelected)]) {
            [_delegate dropButtonSelected];
        }
    } else {
        _imageView.image = [UIImage imageNamed:@"public_arrow_circle_down"];
        if ([_delegate respondsToSelector:@selector(dropButtonNormal)]) {
            [_delegate dropButtonNormal];
        }
    }
    
    _selected = !currentSelected;
    
}

- (void)setImageChange:(BOOL)selected
{
    if (selected) {
        _imageView.image = [UIImage imageNamed:@"public_arrow_circle_up"];
    } else {
        _imageView.image = [UIImage imageNamed:@"public_arrow_circle_down"];
    }
    _selected = !selected;
}

- (void)setTitleText:(NSString *)text
{
    _titleLabel.text = text;
}

@end
