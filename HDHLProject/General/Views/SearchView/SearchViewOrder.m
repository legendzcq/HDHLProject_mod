//
//  SearchViewOrder.m
//  Carte
//
//  Created by ligh on 14-12-16.
//
//

#import "SearchViewOrder.h"

@interface SearchViewOrder () <UITextFieldDelegate>
{
    
    IBOutlet UITextField *_searchField;
    
    UIButton    *_bgButton; //可点击透明层
    
    IBOutlet UIButton    *_searchButton;
    
}
@end

@implementation SearchViewOrder

- (void)dealloc
{
    RELEASE_SAFELY(_searchField);
    RELEASE_SAFELY(_searchButton);
//    RELEASE_SAFELY(_bgButton);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    //颜色，显示、palcehoder
    _searchField.textColor  = ColorForHexKey(AppColor_Input_Box_Prompt_Checked);
    [_searchField setValue:ColorForHexKey(AppColor_Input_Box_Prompt_Default) forKeyPath:@"_placeholderLabel.textColor"];
    [_searchButton setTitleColor:ColorForHexKey(AppColor_Jump_Function_Text5) forState:UIControlStateNormal];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    _searchField.delegate = self;
}

- (void)showInView:(UIView *)inView
{
    self.width = inView.width;
    [inView addSubview:self];
    _bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _bgButton.frame = CGRectMake(0, self.bottom, inView.width, inView.height);
    _bgButton.backgroundColor = [UIColor blackColor];
    _bgButton.alpha = 0.6;
    [_bgButton addTarget:self action:@selector(hiddenSearchBGViewAction) forControlEvents:UIControlEventTouchUpInside];
    [inView addSubview:_bgButton];
    [_searchField becomeFirstResponder];
}

- (void)hiddenSearchBGViewAction
{
    [_searchField resignFirstResponder];
    [self searchBGViewHidden];
    self.alpha = 0;
//    self.hidden = YES;
    [self removeFromSuperview];
    
    if ([_delegate respondsToSelector:@selector(finishButtonClicked)]) {
        [_delegate finishButtonClicked];
    }
}

- (IBAction)finishButtonAction:(id)sender
{
    [_searchField resignFirstResponder];
    [self searchBGViewHidden];
    self.alpha = 0;
//    self.hidden = YES;
    [self removeFromSuperview];
    
    if ([_delegate respondsToSelector:@selector(finishButtonClicked)]) {
        [_delegate finishButtonClicked];
    }
}

//视图位置设定
- (void)changeSearchViewFrame:(UIView *)contentView
{
    self.top = contentView.top;
    _bgButton.top = self.bottom;
}

//透明层设定
- (void)searchBGViewHidden
{
    //透明层隐藏
    if (!_bgButton.hidden) {
        _bgButton.alpha = 0;
        _bgButton.height = 0;
        _bgButton.hidden = YES;
    }
}

- (void)searchBGViewShow
{
    //透明层显示（高度为父视图的高度）
    if ([_bgButton isHidden]) {
        _bgButton.alpha = 0.6;
        _bgButton.height = self.superview.height;
        _bgButton.hidden = NO;
    }
}

- (void)searchTextChanged:(NSNotification *)notification
{
    if (_searchField.text.length) {
        [self searchBGViewHidden];
    } else {
        [self searchBGViewShow];
    }
    
    if ([_delegate respondsToSelector:@selector(textFieldChangedWithText:)]) {
        [_delegate textFieldChangedWithText:_searchField.text];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_searchField resignFirstResponder];
    //    if (textField.text.length) {
    if ([_delegate respondsToSelector:@selector(textFieldChangedWithText:)]) {
        [_delegate textFieldChangedWithText:textField.text];
    }
    //    }
    return YES;
}

@end
