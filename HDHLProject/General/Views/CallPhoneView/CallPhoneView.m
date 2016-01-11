//
//  CallPhoneView.m
//  Carte
//
//  Created by ligh on 14-12-30.
//
//

#import "CallPhoneView.h"

#define kPhoneCellHeight 45

@interface CallPhoneView ()
{
    IBOutlet UIView *_viewTop;
    IBOutlet UIView *_viewMiddle;
    IBOutlet UIView *_viewBottom;
    
    IBOutlet UILabel *_callLabel;    //拨打电话
    IBOutlet UILabel *_callNumLabel; //电话号码
    IBOutlet UILabel *_cancelLabel;  //取消
    
    IBOutlet UIButton *_bgButton;
    
    //黑色透明背景view
//    IBOutlet UIView     *_backgroundView;
    //底部view
    IBOutlet UIView     *_actionView;

    NSMutableArray *_phoneArray;
}
@end

@implementation CallPhoneView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    _callLabel.textColor    = ColorForHexKey(AppColor_Defaule_Hollow_Button_Text3);
    _cancelLabel.textColor  = ColorForHexKey(AppColor_Disable_Click_Button_Text1);
    _callNumLabel.textColor = ColorForHexKey(AppColor_Defaule_Hollow_Button_Text2);
    
    _viewTop.layer.cornerRadius = 3;
    _viewTop.layer.borderColor =   UIColorFromRGB(220,220,220).CGColor;
    _viewTop.layer.borderWidth = 0.5;
    _viewTop.layer.masksToBounds = YES;
    
    _viewMiddle.layer.cornerRadius = 3;
    _viewMiddle.layer.borderColor =   UIColorFromRGB(220,220,220).CGColor;
    _viewMiddle.layer.borderWidth = 0.5;
    _viewMiddle.layer.masksToBounds = YES;
    
    _viewBottom.layer.cornerRadius = 3;
    _viewBottom.layer.borderColor =   UIColorFromRGB(220,220,220).CGColor;
    _viewBottom.layer.borderWidth = 0.5;
    _viewBottom.layer.masksToBounds = YES;
}

- (void)showInView:(UIView *)inView phoneNumArray:(NSArray *)numberArray
{
    //布局
    _viewMiddle.hidden = YES;
    _bgButton.alpha = 0;
    self.height = inView.height;
    _actionView.top = self.height;
    _actionView.width = self.width = inView.width;
    [inView addSubview:self];

    [self setUIWith:numberArray];
    
    [UIView beginAnimations:@"ShowAnimation" context:nil];
    
    _actionView.top = self.height - _actionView.height;
    _bgButton.alpha = 0.4;
    
    [UIView commitAnimations];
}

- (void)setUIWith:(NSArray *)numArray
{
    if (_phoneArray.count) {
        [_phoneArray removeAllObjects];
    }
    _phoneArray = [[NSMutableArray alloc] initWithArray:numArray];
    
    //父视图
    _actionView.height = kPhoneCellHeight + (kPhoneCellHeight+1)*numArray.count + 15 + kPhoneCellHeight + 18;
    
    //拨打电话文字
    _viewTop.top = 0;
    CGFloat hei = _viewTop.bottom;
    
    //电话号码
    for (int i = 0; i < numArray.count; i ++) {
        UIView *phoneView = [[UIView alloc] init];
        phoneView.frame = CGRectMake(10, (_viewTop.height+1)+i*(kPhoneCellHeight+1), _actionView.width-10*2, kPhoneCellHeight);
        phoneView.backgroundColor = [UIColor whiteColor];
        phoneView.layer.cornerRadius = 3;
        phoneView.layer.borderColor =   UIColorFromRGB(220,220,220).CGColor;
        phoneView.layer.borderWidth = 0.5;
        phoneView.layer.masksToBounds = YES;
        [_actionView addSubview:phoneView];
        
        //电话
        UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, phoneView.width, phoneView.height)];
        phoneLabel.font = [UIFont systemFontOfSize:17.0];
        phoneLabel.textAlignment = NSTextAlignmentCenter;
        phoneLabel.textColor = ColorForHexKey(AppColor_Defaule_Hollow_Button_Text2);
        phoneLabel.text = numArray[i];
        [phoneView addSubview:phoneLabel];
        
        UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        phoneButton.frame = CGRectMake(0, 0, phoneView.width, phoneView.height);
        phoneButton.tag = i;
        [phoneButton addTarget:self action:@selector(phoneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [phoneView addSubview:phoneButton];
        
        hei += phoneView.height + 1;
    }
    
    //取消文字
    _viewBottom.top = hei + 15;
}

- (void)phoneButtonAction:(UIButton *)button
{
    [PhoneNumberHelper callPhoneWithText:_phoneArray[button.tag]];
}

- (void)showInView:(UIView *)inView phoneNum:(NSString *)number
{
    //电话号码
    _callNumLabel.text = number;
    
    _bgButton.alpha = 0;
    self.height = inView.height;
    _actionView.top = self.height;
    _actionView.width = self.width = inView.width;

    [inView addSubview:self];
    
    [UIView beginAnimations:@"ShowAnimation" context:nil];

    _actionView.top = self.height - _actionView.height;
    _bgButton.alpha = 0.4;
    
    [UIView commitAnimations];
}

- (void)dismiss:(BOOL)remove
{
    [UIView animateWithDuration:0.3 animations:^{
        
        _bgButton.alpha = 0;
        _actionView.top = self.height;
        
    } completion:^(BOOL finished) {
        if (remove) [self removeFromSuperview];
    }];
}

- (void)setCallNum:(NSString *)number
{
    _callNumLabel.text = number;
}

- (IBAction)callButtonAction:(id)sender
{
    [PhoneNumberHelper callPhoneWithText:_callNumLabel.text];
}

- (IBAction)cancelAction:(id)sender
{
    [self dismiss:YES];
}

- (IBAction)backgroundCancelAction
{
    [self dismiss:YES];
}

- (void)dealloc {
    RELEASE_SAFELY(_callLabel);
    RELEASE_SAFELY(_callNumLabel);
    RELEASE_SAFELY(_cancelLabel);
    RELEASE_SAFELY(_actionView);
    RELEASE_SAFELY(_bgButton);
    RELEASE_SAFELY(_phoneArray);
    RELEASE_SAFELY(_viewTop);
    RELEASE_SAFELY(_viewBottom);
}
@end
