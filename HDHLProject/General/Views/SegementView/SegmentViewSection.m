//
//  SegmentViewSection.m
//  Carte
//
//  Created by ligh on 14-11-19.
//
//

#import "SegmentViewSection.h"

@interface SegmentViewSection ()
{
    IBOutlet UIButton *_button1;
    IBOutlet UIButton *_button2;
}
@end

@implementation SegmentViewSection

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [_button1 setTitleColor:ColorForHexKey(AppColor_Select_Box_Text2) forState:UIControlStateNormal];
    [_button1 setTitleColor:ColorForHexKey(AppColor_Select_Box_Text3) forState:UIControlStateSelected];
    [_button2 setTitleColor:ColorForHexKey(AppColor_Select_Box_Text2) forState:UIControlStateNormal];
    [_button2 setTitleColor:ColorForHexKey(AppColor_Select_Box_Text3) forState:UIControlStateSelected];
    
    //默认（暂时）
    _button1.selected = YES;
    _button1.userInteractionEnabled = NO;
    _button2.userInteractionEnabled = YES;
}

- (void)setButtonTitle:(SegmentSelectType)segmentSelectType
{
    switch (segmentSelectType) {
        case SegmentSelectType1:
            [_button1 setTitle:@"可用" forState:UIControlStateNormal];
            [_button2 setTitle:@"已过期" forState:UIControlStateNormal];
            break;
            
        case SegmentSelectType2:
            [_button1 setTitle:@"就餐环境" forState:UIControlStateNormal];
            [_button2 setTitle:@"菜品" forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

- (void)setValueOfType
{
    NSInteger indexTag = _button1.selected ? 0 : 1;
    if ([_delegate respondsToSelector:@selector(segmentViewSectionSelectedWithIndex:)]) {
        [_delegate segmentViewSectionSelectedWithIndex:indexTag];
    }
}

- (IBAction)button1Action:(id)sender
{
    if (_button2.selected)
    {
        _button2.selected = NO;
        _button1.selected  = YES;
        _button1.userInteractionEnabled = NO;
        _button2.userInteractionEnabled = YES;
    }
    [self setValueOfType];
}

- (IBAction)button2Action:(id)sender
{
    if (_button1.selected)
    {
        _button1.selected  = NO;
        _button2.selected = YES;
        _button1.userInteractionEnabled = YES;
        _button2.userInteractionEnabled = NO;
    }
    [self setValueOfType];
}

- (void)setButton1NormalAndButton2Selected
{
    _button1.selected = NO;
    _button2.selected = YES;
}

- (void)setButton2NormalAndButton1Selected
{
    _button1.selected = YES;
    _button2.selected = NO;
}

- (void)dealloc
{
    RELEASE_SAFELY(_button1);
    RELEASE_SAFELY(_button2);
}

@end
