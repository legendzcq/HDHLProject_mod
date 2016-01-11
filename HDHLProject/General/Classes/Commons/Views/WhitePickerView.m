
//
//  WhitePickerView.m
//  Carte
//
//  Created by ligh on 14-4-19.
//
//

#import "WhitePickerView.h"

@interface MyLayer : CALayer


@end

@implementation MyLayer

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    

}


@end


@interface WhitePickerView()
{

    MyLayer *_rootLayer;

}
@end

@implementation WhitePickerView

//如果是两列的就用下面这个

-(void)awakeFromNib
{
    [super awakeFromNib];
    
}



-(void) resetLayer:(CALayer *) layer
{
    
    [layer setBackgroundColor:[UIColor clearColor].CGColor];
    [layer setShadowColor:[UIColor clearColor].CGColor];


    NSArray *subLayerArray = [layer sublayers];
    
    for (CALayer *subLayer in subLayerArray)
    {

        [self resetLayer:subLayer];
    }
}

-(void) disableView:(UIView *) uiView
{
    
    uiView.backgroundColor = [UIColor clearColor];
    [uiView.layer setBackgroundColor:[UIColor clearColor].CGColor];
    [uiView.layer setShadowColor:[UIColor clearColor].CGColor];

    
    NSArray *arrayViews = [uiView subviews];
    for (UIView *subView in arrayViews)
    {
       // [subView removeFromSuperview];
        [self disableView:subView];
    }
}


- (void)drawRect:(CGRect)rect
{
//    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
//    img.image = [UIImage imageNamed:@"picker"];
//    [self addSubview:img];
//    [img release];
    
//    //4-选择区域的背景颜色; 0-大背景的颜色; 1-选择框左边的颜色; 2-? ;3-?; 5-滚动区域的颜色 回覆盖数据
//    //6-选择框的背景颜色 7-选择框左边的颜色 8-整个View的颜色 会覆盖所有的图片
//    UIView *v = [[self subviews] objectAtIndex:6];
//    [v setBackgroundColor:[UIColor clearColor]];
//    UIImageView *bgimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gray lump"]];
//    bgimg.frame = CGRectMake(-5, -3, 200, 55);
//    [v addSubview:bgimg];
//    [bgimg release];
//    
    [self setNeedsDisplay];
    
}



//-(void)drawRect:(CGRect)rect
//{
//    
//    CGFloat color[4] = {1,1,0,1};
//    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
//    CGColorRef layerBounderColor = CGColorCreate(rgb, color);
//    CGColorSpaceRelease(rgb);
//    CALayer *viewLayer = self.layer;
//    [viewLayer setBounds:CGRectMake(0, 0, 200, 200)];
//    [viewLayer setBackgroundColor:layerBounderColor];
//    [viewLayer setContentsRect:CGRectMake(0, 0, 100, 150)];
//    [viewLayer setBorderWidth:20];
//    [viewLayer setBorderColor:layerBounderColor];
//    CGColorRelease(layerBounderColor);
//    
//        [super drawRect:rect];
//}

//- (void)drawRect:(CGRect)rect {
//    
//    
//    //ios 6以下版本 需要设置UIPickerView为白色
//    if (IOS_VERSION_CODE < 7)
//    {
//
//        //改变最外层的背景
//        UIView *v0 = [[self subviews] objectAtIndex:0 ];
//        v0.backgroundColor = [UIColor whiteColor];
//        
//        int componetNumber = self.numberOfComponents;
////        
////        //    //去掉最大的框
////        UIView *v14 = [[self subviews] objectAtIndex:14];
////        v14.alpha = 0.0;
//
//        
//        int startIndex =  1;
//        
//        for (int i = 0 ; i < componetNumber ; i++)
//        {
//            
//            UIView *v1 = [[self subviews] objectAtIndex:startIndex ];
//            v1.alpha = 0.6;
//            UIView *v2 = [[self subviews] objectAtIndex:startIndex += 1 ];
//            v2.alpha = 0;
//            UIView *v3 = [[self subviews] objectAtIndex:startIndex  += 1];
//            v3.alpha = 0;
//            UIView *v4 = [[self subviews] objectAtIndex:startIndex += 1 ];
//            v4.backgroundColor = [UIColor redColor];
//            UIView *v5 = [[self subviews] objectAtIndex:startIndex += 1 ];
//            v5.alpha = 0.0;
//            UIView *v6 = [[self subviews] objectAtIndex:startIndex +- 1];
//            v6.alpha=0.6;
//        }
//    }
//
//    [self setNeedsDisplay];
//    
//}

@end
