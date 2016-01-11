//
//  SearchView.m
//  Carte
//
//  Created by ligh on 14-12-11.
//
//

#import "SearchView.h"

@interface SearchView () <UITextFieldDelegate>
{
    IBOutlet UIView      *_changeViewBG;
    IBOutlet UIView      *_changeView;
    
    UIButton *bgButton; //强加的一个可点击透明层
    
//    IBOutlet UIButton    *_searchButton;
    
    CGFloat _changeViewWidth;
    CGFloat _searchFieldWidth;
    
}
@end

@implementation SearchView

- (void)dealloc
{
    RELEASE_SAFELY(_changeView);
    RELEASE_SAFELY(_searchTextField);
    RELEASE_SAFELY(_searchButton);
    RELEASE_SAFELY(_changeViewBG);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //颜色，显示、palcehoder
    _searchTextField.textColor  = ColorForHexKey(AppColor_Input_Box_Prompt_Checked);
    [_searchTextField setValue:ColorForHexKey(AppColor_Input_Box_Prompt_Default) forKeyPath:@"_placeholderLabel.textColor"];
    [_searchButton setTitleColor:ColorForHexKey(AppColor_Jump_Function_Text5) forState:UIControlStateNormal];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchFieldTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    _searchTextField.delegate = self;

    _changeViewWidth  = SCREEN_WIDTH - MARGIN_M*2  ; //拿到初始变化View宽度
    _searchFieldWidth = SCREEN_WIDTH - MARGIN_M*2-35; //拿到初始变化Field宽度
    _changeView.width =SCREEN_WIDTH - MARGIN_M*2 ;    //透明层隐藏
    [self searchBGViewHidden];
}

- (NSString *)searchText
{
    return _searchTextField.text;
}

- (void)hiddenSearchView
{
    [self searchBGViewHidden];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self searchBGViewShow];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchBGViewHidden];
    if ([_delegate respondsToSelector:@selector(searchResultAction:)]) {
        [_delegate searchResultAction:textField.text];
    }
    return YES;
}

- (IBAction)searchButtonAction:(id)sender
{
    [self searchBGViewHidden];
    if ([_delegate respondsToSelector:@selector(searchResultAction:)]) {
        [_delegate searchResultAction:_searchTextField.text];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self searchBGViewHidden];
}

#pragma mark - NSNotification

- (void)searchFieldTextChanged:(NSNotification *)notification
{
    if (_showSearchType == ShowSearchTextNO) {
        
        if (_searchTextField.text.length) {
            //[self searchBGViewHidden];
            //重写上一行代码hidden方法
            
//            [bgButton removeFromSuperview];
//            bgButton = nil;
            bgButton.hidden = YES;

            //透明层隐藏
            _changeViewBG.alpha = 0;
            _changeViewBG.hidden = YES;
            //搜索按钮隐藏
            _searchButton.hidden = YES;
            
        } else {
            [self searchBGViewShow];
        }
        
        if ([_delegate respondsToSelector:@selector(textFieldTextChangedWithText:)]) {
            [_delegate textFieldTextChangedWithText:_searchTextField.text];
        }
    }
}

//透明层设定

- (void)searchBGViewHidden
{
//    [bgButton removeFromSuperview];
//    bgButton = nil;
    bgButton.hidden = YES;
    
    //透明层隐藏
    _changeViewBG.alpha = 0;
    _changeViewBG.hidden = YES;
    
    [_searchTextField resignFirstResponder];
    if (_showSearchType == ShowSearchTextYES) {
        _changeView.width  = _changeViewWidth;
        _searchTextField.width = _searchFieldWidth;
    }
    
    //搜索按钮隐藏
    _searchButton.hidden = YES;
    
    if ([_delegate respondsToSelector:@selector(clickedBGViewAction:)]) {
        [_delegate clickedBGViewAction:_searchTextField.text];
    }
}

- (void)searchBGViewShow
{
    //搜索按钮显示
    if (_showSearchType == ShowSearchTextYES) {
        _searchButton.hidden = NO;
        _changeView.width  = _changeViewWidth  + MARGIN_M - _searchButton.width;
        _searchTextField.width = _searchFieldWidth + MARGIN_M - _searchButton.width;
    }
    
    //透明层显示（高度为父视图的高度）
    _changeViewBG.hidden = NO;
    _changeViewBG.alpha = 0.6;
    UIView *_searchSuperView = (UIView *)self.superview;
    _changeViewBG.height = _searchSuperView.height;
    
    if (!bgButton) {
        bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    bgButton.frame = CGRectMake(0, self.bottom, _changeViewBG.width, _changeViewBG.height);
    bgButton.backgroundColor = [UIColor clearColor];
    bgButton.alpha = _changeViewBG.alpha;
    [bgButton addTarget:self action:@selector(searchBGViewHidden) forControlEvents:UIControlEventTouchUpInside];
    [_searchSuperView addSubview:bgButton];
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
