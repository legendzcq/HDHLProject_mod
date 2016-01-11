//
//  OrderDropDownView.m
//  Carte
//
//  Created by ligh on 14-12-30.
//
//

#import "OrderDropDownView.h"

@interface OrderDropDownView ()
{
    IBOutlet UIView *_bgView;
    
    UIButton *_bgButton;

    CGFloat selfHeght;
    IBOutlet UIImageView *_showImage;
    IBOutlet UILabel *_imageSHowLabel;
    
}
@end

@implementation OrderDropDownView

- (void)dealloc
{
    RELEASE_SAFELY(_bgView);
    RELEASE_SAFELY(_imageSHowLabel);
    RELEASE_SAFELY(_showImage);
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _bgButton.frame = CGRectMake(0, 0, _bgView.width, _bgView.height);
    _bgButton.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:_bgButton];
    [_bgButton addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    
    selfHeght = self.height;
    self.height = 0;
}

- (void)orderDropDownViewShowInView:(UIView *)view withShow:(BOOL)show withBottomHeight:(CGFloat)bottomHeight
{
    //有图无图模式判定
    [self setImageAndLabelWith:show];
    
    [UIView beginAnimations:@"ShowAnimation" context:nil];
    
    self.height = selfHeght;
    self.width = view.width;

    _bgView.alpha = 0.6;
    _bgView.top = self.bottom;
    _bgView.width = view.width;
    _bgView.height = view.height-self.bottom-bottomHeight;
    _bgButton.height = _bgView.height;
    [view addSubview:_bgView];

    [UIView commitAnimations];
}

- (void)orderDropDownViewHidden
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.height = 0;
        self.alpha = 0;
        
        //
        _bgButton.height = 0;
        _bgView.height = _bgButton.height;
        _bgView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        
    }];
}

//联系电话
- (IBAction)selectedButtonAction0:(id)sender
{
//    [self orderDropDownViewHidden];
    if ([_delegate respondsToSelector:@selector(dropDownViewCellClicked:)]) {
        [_delegate dropDownViewCellClicked:0];
    }
}

- (IBAction)selectedButtonAction1:(id)sender
{
//    [self orderDropDownViewHidden];
    if ([_delegate respondsToSelector:@selector(dropDownViewCellClicked:)]) {
        [_delegate dropDownViewCellClicked:1];
    }
}
- (IBAction)selectedButtonAction2:(id)sender
{
    [self orderDropDownViewHidden];
    if ([_delegate respondsToSelector:@selector(dropDownViewCellClicked:)]) {
        [_delegate dropDownViewCellClicked:2];
    }
}

- (void)dismissSelf
{
    [self orderDropDownViewHidden];
    if ([_delegate respondsToSelector:@selector(dropDownViewDismiss)]) {
        [_delegate dropDownViewDismiss];
    }
}

- (void)setImageAndLabelWith:(BOOL)show
{
    if (show) {
        _showImage.image = [UIImage imageNamed:@"public_icon8"];
        _imageSHowLabel.text = @"无图模式";
    } else {
        _showImage.image = [UIImage imageNamed:@"public_icon9"];
        _imageSHowLabel.text = @"有图模式";
    }
}

@end
