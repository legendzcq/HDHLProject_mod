//
//  InvoiceCheckView.m
//  Carte
//
//  Created by ligh on 15-1-11.
//
//

#import "InvoiceCheckView.h"
#import "FrameLineView.h"

@interface InvoiceCheckView ()
{
    
    IBOutlet UIButton *_invoiceCheckNO;
    IBOutlet UIButton *_invoiceCheckYES;
    
    IBOutlet UITextField *_invoiceCheckTitleField;
    
    IBOutlet FrameLineView *_lineTop;
    IBOutlet FrameLineView *_lineBottom;
    
    
    IBOutlet UILabel *_invoiceNoTitleLabel;
    
    IBOutlet UILabel *_invoiceYesTitleLabel;
    
    IBOutlet UILabel *_invoiceTitleLabel;
}
@end

@implementation InvoiceCheckView

-(void)awakeFromNib
{
    [super awakeFromNib];
    _invoiceNoTitleLabel.textColor  = ColorForHexKey(AppColor_Select_Box_Text1);
    _invoiceYesTitleLabel.textColor = ColorForHexKey(AppColor_Select_Box_Text1);
    _invoiceTitleLabel.textColor    = ColorForHexKey(AppColor_Second_Level_Title1);
    _invoiceCheckTitleField.textColor = ColorForHexKey(AppColor_Input_Box_Prompt_Checked);
    [_invoiceCheckTitleField setValue:ColorForHexKey(AppColor_Input_Box_Prompt_Default) forKeyPath:@"_placeholderLabel.textColor"];
    
    _invoiceCheckNO.selected = YES;
    [self close];
}

- (NSString *)invoiceCheckValue
{
    return _invoiceCheckNO.selected ? @"0" : @"1";
}

- (BOOL)isHaveInvoice
{
    return self.invoiceCheckValue.intValue == InvoiceTag_HAVE;
}

- (NSString *)invoiceCheckTitle
{
    return _invoiceCheckTitleField.text;
}

- (IBAction)checkNOButtonAction:(id)sender
{
    if (_invoiceCheckYES.selected)
    {
        _invoiceCheckYES.selected = NO;
        _invoiceCheckNO.selected = YES;
    }
    [UIView beginAnimations:@"CloseAnimation" context:nil];
    self.height = 40;
    [UIView commitAnimations];
    
    [self delegateAction];
}

- (IBAction)checkYESButtonAction:(id)sender
{
    if (_invoiceCheckNO.selected)
    {
        _invoiceCheckYES.selected = YES;
        _invoiceCheckNO.selected = NO;
    }

    [UIView animateWithDuration:0.3 animations:^{
        self.height = 85;
    } completion:^(BOOL finished) {
        if (finished) {
            [self delegateAction];
        }
    }];
}

- (void)delegateAction
{
    if ([_delegate respondsToSelector:@selector(invoiceCheckValue:)]) {
        [_delegate invoiceCheckValue:[self invoiceCheckValue].intValue];
    }
}

//
- (void)hiddBottomLine
{
//    _lineTop.hidden = NO;
//    _lineBottom.hidden = YES;
}

- (void)showBottomLine
{
//    _lineTop.hidden = NO;
//    _lineBottom.hidden = NO;
}

//重写父类方法
- (void)close
{
//    self.opened = NO;
//    self.arrowButton.selected = NO;
//    
//    [UIView beginAnimations:@"CloseAnimation" context:nil];
//    
//    self.height = 40;
//    [self layoutSuperView];
//    
//    [UIView commitAnimations];
    [super close];
    self.height = 40;
}

- (void)dealloc {
    RELEASE_SAFELY(_invoiceCheckNO);
    RELEASE_SAFELY(_invoiceCheckYES);
    RELEASE_SAFELY(_lineTop);
    RELEASE_SAFELY(_lineBottom);
    RELEASE_SAFELY(_invoiceNoTitleLabel);
    RELEASE_SAFELY(_invoiceYesTitleLabel);
    RELEASE_SAFELY(_invoiceTitleLabel);
}

@end
