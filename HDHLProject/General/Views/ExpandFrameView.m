//
//  ExpandFrameView.m
//  Carte
//
//  Created by ligh on 14-4-12.
//
//

#define ArrowCloseImage  @"public_arrow_down"
#define ArrowOpenupImage @"public_arrow_up"

#import "ExpandFrameView.h"

@interface ExpandFrameView()
{

}
@end

@implementation ExpandFrameView

-(void)dealloc
{

}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [_arrowButton setImage:UIImageForName(ArrowCloseImage) forState:UIControlStateNormal];
    [_arrowButton setImage:UIImageForName(ArrowOpenupImage) forState:UIControlStateSelected];
    
    if (_headerTitleButton) {
        [_headerTitleButton setTitleColor:ColorForHexKey(AppColor_Second_Level_Title1) forState:UIControlStateNormal];
    }
    
    _opened = self.height > Default_Height;
}

-(void)switchShow{
 
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    if (_opened) {
        [self close];
    } else {
        [self openup];
    }
}


-(float) allSubViewHeight
{
    float totalSubViewHeight = 0;
    
    //首先计算出所有view的高度
    NSArray *subViews = [self subviews];
    
    for (UIView *view in subViews) {
        if (view.hidden) {
            continue;
        }
        totalSubViewHeight += view.height;
    }
    
    return totalSubViewHeight;
}


/**
 *  当展开和闭合 FrameView时 需要重新计算superView中所有subviews 的坐标
 */
-(void) layoutSuperView
{
    
    UIView *superView = self.superview;
    
    NSUInteger subviewCount = superView.subviews.count;
    
    
    //-1的原因是  UIScrollView 会默认加一张UIImageView 所以这个view需要忽略
    if ([superView isKindOfClass:[UIScrollView class]])
    {
        subviewCount -=1;
    }
    
    float preViewBottom = self.bottom;
    
    NSInteger viewIndex =  [superView.subviews indexOfObject:self] +1;
    
    for (int i = (int)viewIndex ; i < subviewCount ; i++)
    {
        UIView *nextView = superView.subviews[i];
        if (nextView.hidden)
        {
            continue;
        }   
        if (_layoutDelegate && [_layoutDelegate respondsToSelector:@selector(expandFrameView:topMarginOfView:)])
        {
            nextView.top = preViewBottom + [_layoutDelegate expandFrameView:self topMarginOfView:nextView];
        }else
        {
            nextView.top = preViewBottom ;
        }
        //迭代倒最后一个view 使用此view的 bottom 坐标作为contentsize
        preViewBottom = nextView.bottom ;
    }
    //如果父级view 为 scrollView 则需要调整scrollview的内容大小
    if ([superView isKindOfClass:[UIScrollView class]])
    {
        UIScrollView *scrollView = (UIScrollView *)superView;
        [scrollView setContentSize:CGSizeMake(0,preViewBottom)];
    }
}


-(void)openup:(BOOL)animation
{
    _opened = YES;
    
    float totalSubViewHeight = [self allSubViewHeight];
    _arrowButton.selected = YES;

    [UIView animateWithDuration:animation ? 0.3 : 0 animations:^{
    
        self.height = totalSubViewHeight;
        [self layoutSuperView];
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void) openup
{
    
    [self openup:YES];

}

-(void)close
{
    _opened = NO;
    _arrowButton.selected = NO;
    
    [UIView beginAnimations:@"CloseAnimation" context:nil];
    
    self.height = Default_Height;
    [self layoutSuperView];
    
    [UIView commitAnimations];
    
}


@end
