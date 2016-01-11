//
//  TakeorderNoticeView.m
//  Carte
//
//  Created by ligh on 14-5-5.
//
//

#import "TakeorderNoticeView.h"

@interface TakeorderNoticeView()
{
    
     UIControl              *_touchControl;
    IBOutlet UIButton       *_titleActionButton;
    IBOutlet UITextView     *_textView;
    IBOutlet UIView         *_alphaView;
    IBOutlet UIButton       *_arrowButton;
    
}
@end

@implementation TakeorderNoticeView

- (void)dealloc
{
    RELEASE_SAFELY(_alphaView);
    RELEASE_SAFELY(_textView);
    RELEASE_SAFELY(_arrowButton);
    RELEASE_SAFELY(_titleActionButton);
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    [self loadColorConfig];
}

-(void) loadColorConfig
{
    [_titleActionButton setTitleColor:ColorForHexKey(AppColor_Prompt_Text2) forState:UIControlStateNormal];
    _textView.textColor = ColorForHexKey(AppColor_Content_Text3);
}

-(void)setSendRulesModel:(SendRulesModel *)ruluesModel
{
    if (ruluesModel.min_price && ruluesModel.send_price && ruluesModel.stime )
    {
        if ([NSString isBlankString:ruluesModel.etime])//有结束时间
        {
            NSString *text = [NSString stringWithFormat:@"%@元起送，送餐费%@元\r\n\r\n外送服务时间: %@点 %@",ruluesModel.min_price,ruluesModel.send_price,ruluesModel.stime, [NSString isBlankString:ruluesModel.discount_rules]? @"" : [NSString stringWithFormat:@"\r\n\r\n%@",ruluesModel.discount_rules]];
            
            _textView.text =text;
       
        }else
        {
            NSString *text = [NSString stringWithFormat:@"%@元起送，送餐费%@元\r\n\r\n外送服务时间: %@点 ~ %@点 %@",ruluesModel.min_price,ruluesModel.send_price,ruluesModel.stime,ruluesModel.etime, [NSString isBlankString:ruluesModel.discount_rules]? @"" : [NSString stringWithFormat:@"\r\n\r\n%@",ruluesModel.discount_rules]];
            
            _textView.text =text;
        }
    

    }else
    {
        _textView.text = @"无";
    }
    
    
    _textView.height = _textView.contentSize.height + MARGIN_M;
 
}

- (IBAction)expandAction:(UIView *)sender
{
    [UIView beginAnimations:@"ExpandAnimation" context:nil];
   
    if (self.height > sender.height)
    {
        self.height = sender.height;
        _arrowButton.selected = NO;
       
        [_touchControl removeFromSuperview];
        _touchControl = nil;
    
    }else
    {
        self.height = sender.height + _textView.contentSize.height + MARGIN_M;
        _arrowButton.selected = YES;
        
        _touchControl = [[UIControl alloc] initWithFrame:[KAPP_WINDOW frame]];
        [[UIApplication sharedApplication].keyWindow addSubview:_touchControl];
        [_touchControl addTarget:self action:@selector(touchuControl:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [UIView commitAnimations];
}

- (IBAction)touchuControl:(id)sender
{
    [self expandAction:_titleActionButton];
}


@end
