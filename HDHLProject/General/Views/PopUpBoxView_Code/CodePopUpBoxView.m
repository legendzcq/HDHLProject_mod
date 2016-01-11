//
//  CodePopUpBoxView.m
//  Carte
//
//  Created by ligh on 14-12-10.
//
//

#import "CodePopUpBoxView.h"
#import "ExpenseCodeModel.h"
@interface CodePopUpBoxView ()
{
    //黑色透明背景view
    IBOutlet UIButton *_backgroundView;
    //显示view
    IBOutlet UIView *_showCodesView;
    UIScrollView    *_showCodesScrollView;
    IBOutlet UIImageView *_bgImageView;
    
    IBOutlet UILabel *_codeTitleLabel;

    
}
@end
@implementation CodePopUpBoxView

- (void)dealloc
{
    RELEASE_SAFELY(_backgroundView);
    RELEASE_SAFELY(_showCodesView);
    RELEASE_SAFELY(_showCodesScrollView);
    RELEASE_SAFELY(_bgImageView);
    RELEASE_SAFELY(_codeTitleLabel);
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _codeTitleLabel.textColor = ColorForHexKey(AppColor_Popup_Box_Text1);

    //拉伸图片
    _bgImageView.image = [[UIImage imageNamed:@"public_dialog"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0) resizingMode:UIImageResizingModeTile];
    
    _showCodesScrollView = [[UIScrollView alloc] init];
    [_showCodesView addSubview:_showCodesScrollView];
//    _showCodesScrollView.showsHorizontalScrollIndicator = NO; //水平滚动提示条
//    _showCodesScrollView.showsVerticalScrollIndicator   = NO; //竖直滚动提示条

}

- (void)createUIWithArray:(NSArray *)array
{
    _showCodesView.width = kPopUpBoxWidth_Code;
    _showCodesScrollView.top = kCodeScrollTop;
    _showCodesScrollView.width = _showCodesView.width;
    
    NSInteger _count = array.count;
    
    for (int i = 0; i < _count; i ++) {
        
        UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, i*kCodeCellHeight, _showCodesScrollView.width, kCodeCellHeight)];
        codeLabel.backgroundColor = [UIColor clearColor];
        codeLabel.textAlignment = NSTextAlignmentCenter;
        if (_count == 1) { //一个的时候特殊
            _showCodesScrollView.top = kCodeScrollTop - 10;
        }
        //
        //内容，颜色，字体的更改设置
        //
        
        codeLabel.font = [UIFont systemFontOfSize:kCodeFont];
        codeLabel.textColor = ColorForHexKey(AppColor_Popup_Box_Text2);
        ExpenseCodeModel *codeModel = array[i];
        codeLabel.text = codeModel.expense_sn;
        [_showCodesScrollView addSubview:codeLabel];
        
        //虚线
        if (_count > 1) {
            //top
            if (i == 0) {
                UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(kCodeLineLeft, 0, _showCodesView.width-2*kCodeLineLeft, 1)];
                topLine.image = [UIImage imageNamed:@"public_dashed1"];
                [codeLabel addSubview:topLine];
            }
            //bottom
            UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(kCodeLineLeft, 44, _showCodesView.width-2*kCodeLineLeft, 1)];
            bottomLine.image = [UIImage imageNamed:@"public_dashed1"];
            [codeLabel addSubview:bottomLine];
        }
    }
    
    NSInteger _countCurrent = (_count > kScrollCount) ? kScrollCount : _count;
    _showCodesScrollView.height = _countCurrent * kCodeCellHeight;
    _showCodesView.height = _showCodesScrollView.top + _showCodesScrollView.height + kCodeScrollBottom;
    
    [_showCodesScrollView setContentSize:CGSizeMake(0, _count * kCodeCellHeight)];
    
}


- (void)showInView:(UIView *)inView withArray:(NSArray *)array
{
    self.frame = [[UIScreen mainScreen] bounds];
    self.center = [UIApplication sharedApplication].keyWindow.center;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    _backgroundView.alpha = 0;
    _showCodesView.alpha = 0;
    
    //添加数据显示
    [self createUIWithArray:array];
    _showCodesView.center = _backgroundView.center; //self.center 也行
//    [inView addSubview:self];
    
    [UIView beginAnimations:@"ShowAnimation" context:nil];
    _backgroundView.alpha = 0.6;
    _showCodesView.alpha = 1.0;
    [UIView commitAnimations];
    //特殊抖动动画
    [_showCodesView.layer addAnimation:[self scaleAnimation:YES] forKey:nil];

}

//点击背景 关闭
- (IBAction)touchBackgroundView:(id)sender
{
    [self dismiss:YES];
}

-(void) dismiss:(BOOL)isRemove
{
    [UIView animateWithDuration:0.3 animations:^{
        
        _showCodesView.alpha = 0;
        _backgroundView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        if (isRemove)
        {
            [self removeFromSuperview];
        }
        
    }];
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

@end
