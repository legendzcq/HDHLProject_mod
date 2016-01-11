//
//  OrderSendTypeView.m
//  Carte
//
//  Created by ligh on 14-7-24.
//
//

#import "SendTypeView.h"

@interface SendTypeView()
{
    //送餐
    IBOutlet UIButton *_sendTypeButton;
    //自提
    IBOutlet UIButton *_selfTypeButton;
    
    UIControl         *_touchControl;
}
@end

@implementation SendTypeView

- (void)dealloc
{
    RELEASE_SAFELY(_sendTypeButton);
    RELEASE_SAFELY(_selfTypeButton);
    RELEASE_SAFELY(_touchControl);
    RELEASE_SAFELY(_block);
}


//送餐和自提选中事件
- (IBAction)orderTypeButtonAction:(UIButton *)sender
{
    _sendTypeButton.selected = sender == _sendTypeButton;
    _selfTypeButton.selected = sender == _selfTypeButton;
    
    if(_delegate)
    {
        [_delegate selectedSendType:sender.tag];
    }
    
    [self dismiss];
}

-(void)selectSendType:(SendType)sendType
{
    _sendTypeButton.selected = _sendTypeButton.tag == sendType;
    _selfTypeButton.selected = _selfTypeButton.tag == sendType;
}


-(void)showInView:(UIView *)inView atPoint:(CGPoint)point
{
    
    _touchControl = [[UIControl alloc] initWithFrame:inView.frame];
    [_touchControl addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [inView addSubview:_touchControl];
    
    [self removeFromSuperview];
    self.frame = CGRectMake(point.x,point.y, 88, 0);
    [inView addSubview:self];
    

    
    
    [UIView beginAnimations:@"ShowAnimation" context:nil];
    
        self.height = 85;
    
    [UIView commitAnimations];
}

-(void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.height = 0;
        
    } completion:^(BOOL finished) {
        if (_block)
        {
            _block();
        }
        [_touchControl removeFromSuperview];
        [self removeFromSuperview];
     
    }];
}

@end
