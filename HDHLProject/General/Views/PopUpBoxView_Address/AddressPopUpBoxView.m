//
//  AddressPopUpBoxView.m
//  Carte
//
//  Created by ligh on 14-12-15.
//
//

#import "AddressPopUpBoxView.h"


@interface AddressPopUpBoxView () <UITextFieldDelegate>
{
    //黑色透明背景view
    IBOutlet UIButton *_backgroundView;
    //显示view
    IBOutlet UIView *_showAddressView;
    
    IBOutlet UITextField *_nameField;
    IBOutlet UITextField *_phoneField;
    IBOutlet UITextField *_addressField;
    
    IBOutlet UILabel  *_titleLabel; //标题（新增地址、编辑地址）
    
    BOOL textFieldCanChange;
    NSString *text;
}
@end

@implementation AddressPopUpBoxView

- (void)dealloc
{
    RELEASE_SAFELY(_backgroundView);
    RELEASE_SAFELY(_showAddressView);
    RELEASE_SAFELY(_nameField);
    RELEASE_SAFELY(_phoneField);
    RELEASE_SAFELY(_addressField);
    RELEASE_SAFELY(_addAddressButton);
    RELEASE_SAFELY(text);
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _nameField.delegate = self;
    _phoneField.delegate = self;
    _addressField.delegate = self;
    
    [_addAddressButton setTitleColor:ColorForHexKey(AppColor_Defaule_Hollow_Button_Text2) forState:UIControlStateNormal];
    
    textFieldCanChange = YES;
    text = [[NSString alloc] initWithString:_nameField.text];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fieldTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)setUserInfoWith:(UserModel *)userModel
{
    _nameField.text = userModel.username;
    _phoneField.text = userModel.mobile;
}

//添加位置信息
- (void)setAddressInfoWith:(TakeoutAddressModel *)model
{
    _nameField.text    = model.username;
    _phoneField.text   = model.mobile;
    _addressField.text = model.address;
}

- (void)showInView:(UIView *)inView withTitle:(NSString *)title
{
    _titleLabel.text = [NSString stringWithFormat:@"%@地址", title];
    [_addAddressButton setTitle:title forState:UIControlStateNormal];
    [self showInView:inView];
}

- (void)showInView:(UIView *)inView
{
    self.frame = [[UIScreen mainScreen] bounds];
    self.center = [UIApplication sharedApplication].keyWindow.center;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    _backgroundView.alpha = 0;
    _showAddressView.alpha = 0;
    
    //添加数据显示
//    [self createUIWithArray:array];
    _showAddressView.center = _backgroundView.center; //self.center 也行
//    [inView addSubview:self];
    
    [UIView beginAnimations:@"ShowAnimation" context:nil];
    _backgroundView.alpha = 0.6;
    _showAddressView.alpha = 1.0;
    [UIView commitAnimations];
    //特殊抖动动画
    [_showAddressView.layer addAnimation:[self scaleAnimation:YES] forKey:nil];
    
}


/***
 验证手机号码
 **/
-(BOOL) validateInputData
{
    if (_nameField.text.length == 0)
    {
        [BDKNotifyHUD showCryingHUDWithText:@"请输入您的姓名"];
        return NO;
    }
    
    if (_phoneField.text.length == 0)
    {
        [BDKNotifyHUD showCryingHUDWithText:@"请填写您的手机号"];
        return NO;
    }
    
    if (![PhoneNumberHelper validateMobile:_phoneField.text])
    {
        [BDKNotifyHUD showCryingHUDWithText:@"手机号格式不正确"];
        return NO;
    }
    
    if (_addressField.text.length == 0)
    {
        [BDKNotifyHUD showCryingHUDWithText:@"请填写送餐地址"];
        return NO;
    }
    
    return YES;
}


//点击背景 关闭
- (IBAction)touchBackgroundView:(id)sender
{
    [self dismiss:YES];
}

-(void) dismiss:(BOOL)isRemove
{
    [UIView animateWithDuration:0.3 animations:^{
        
        _showAddressView.alpha = 0;
        _backgroundView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        if (isRemove)
        {
            [self removeFromSuperview];
        }
        
    }];
}

- (void)addressViewTop
{
    [UIView beginAnimations:@"ShowAnimation" context:nil];
    _showAddressView.center = CGPointMake(_backgroundView.center.x, _backgroundView.center.y-80);
    [UIView commitAnimations];
}

- (void)addressViewCenter
{
    [UIView animateWithDuration:0.3 animations:^{
        
        [self endEditing:YES];
        _showAddressView.center = _backgroundView.center;
        
    } completion:^(BOOL finished) {
        
    }];
}

//点击添加按钮
- (IBAction)touchAddressButtonAction:(id)sender
{
//    [self endEditing];
    
    
    if (![self validateInputData])
    {
        return;
    }


    if ([_delegate respondsToSelector:@selector(addAddressWithName:phone:address:)]) {
        [_delegate addAddressWithName:_nameField.text phone:_phoneField.text address:_addressField.text];
    }
    
    [self addressViewCenter];
    
    if (![NSString isBlankString:_nameField.text] && ![NSString isBlankString:_phoneField.text] && ![NSString isBlankString:_addressField.text]) {
        
        [self dismiss:YES];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self addressViewTop];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self addressViewCenter];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _phoneField) {
        if (range.location >= 11)
            return NO;
    }else if (textField == _nameField){
        if (range.length == 1) {
            return YES;
        }else if ([string isEqualToString:@" "]){
            return NO;
        }
        return textFieldCanChange;
    }
    return YES;
}

#pragma mark - NSNotification

- (void)fieldTextChanged:(NSNotification *)notification
{
    if (_nameField.text.length >= 8) {
        _nameField.text = [_nameField.text substringWithRange:NSMakeRange(0,8)];
        textFieldCanChange = NO;
    } else {
        textFieldCanChange = YES;
    }
}

#pragma mark - Animation

- (CAKeyframeAnimation*)scaleAnimation:(BOOL)show
{
    CAKeyframeAnimation *scaleAnimation = nil;
    scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.delegate = show ? nil : self;
    scaleAnimation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    if (show){
        scaleAnimation.duration = 0.5;
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    }else{
        scaleAnimation.duration = 0.3;
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 0.8)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 0.6)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 0.5)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.2, 0.2, 0.2)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 0)]];
    }
    scaleAnimation.values = values;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation.removedOnCompletion = TRUE;
    return scaleAnimation;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
