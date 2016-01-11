//
//  UIButton+ITTAdditions.m
//  iTotemFrame
//
//  Created by jack 廉洁 on 3/15/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "UIButton+ITTAdditions.h"

@implementation UIButton (ITTAdditions)

+ (UIButton *)buttonWithFrame:(CGRect)frame
                        title:(NSString *)title
                    titleFont:(UIFont *)titleFont
                   titleColor:(UIColor *)titleColor
          titleHighlightColor:(UIColor *)titleHighlightColor
          titleSelectedColor:(UIColor *)titleSelectedColor
           titleDisabledColor:(UIColor *)titleDisabledColor
                  imageNormal:(UIImage *)imageNormal
             imageHighlighted:(UIImage *)imageHighlighted
                imageSelected:(UIImage *)imageSelected
                imageDisabled:(UIImage *)imageDisabled
        imageBackgroundNormal:(UIImage *)imageBackgroundNormal
   imageBackgroundHighlighted:(UIImage *)imageBackgroundHighlighted
      imageBackgroundSelected:(UIImage *)imagBackgroundeSelected
      imageBackgroundDisabled:(UIImage *)imagBackgroundeDisabled
                       target:(id)target
                       action:(SEL)selector 
                          tag:(NSInteger)tag {
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = frame;
	if( title != nil && title.length > 0) {
		[button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = titleFont;

		[button setTitleColor:titleColor forState:UIControlStateNormal];
		[button setTitleColor:titleHighlightColor forState:UIControlStateHighlighted];
        [button setTitleColor:titleHighlightColor forState:UIControlStateSelected];
        [button setTitleColor:titleHighlightColor forState:UIControlStateDisabled];
	}
    
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	button.tag = tag;
    
	if(imageNormal) {
		[button setImage:imageNormal forState:UIControlStateNormal];
	}
	if(imageHighlighted) {
		[button setImage:imageHighlighted forState:UIControlStateHighlighted];
	}
    if(imageSelected) {
        [button setImage:imageSelected forState:UIControlStateSelected];
    }
    if(imageDisabled) {
        [button setImage:imageDisabled forState:UIControlStateDisabled];
    }
    
    if(imageBackgroundNormal) {
        [button setBackgroundImage:imageBackgroundNormal forState:UIControlStateNormal];
    }
    if(imageBackgroundHighlighted) {
        [button setBackgroundImage:imageBackgroundHighlighted forState:UIControlStateHighlighted];
    }
    if(imagBackgroundeSelected) {
        [button setBackgroundImage:imagBackgroundeSelected forState:UIControlStateSelected];
    }
    if(imagBackgroundeDisabled) {
        [button setBackgroundImage:imagBackgroundeDisabled forState:UIControlStateDisabled];
    }
	
	return button;
}

//图片样式按钮
+ (UIButton *)buttonWithFrame:(CGRect)frame
                  imageNormal:(NSString *)imageNormal
             imageHighlighted:(NSString *)imageHighlighted
                       target:(id)target
                       action:(SEL)selector {
    return [self buttonWithFrame:frame title:nil titleFont:nil titleColor:nil titleHighlightColor:nil titleSelectedColor:nil titleDisabledColor:nil imageNormal:[UIImage imageNamed:imageNormal] imageHighlighted:[UIImage imageNamed:imageHighlighted] imageSelected:nil imageDisabled:nil imageBackgroundNormal:nil imageBackgroundHighlighted:nil imageBackgroundSelected:nil imageBackgroundDisabled:nil target:target action:selector tag:0];
}

//标题按钮
+ (UIButton *)buttonWithFrame:(CGRect)frame
                        title:(NSString *)title
                    titleFont:(UIFont *)titleFont
                   titleColor:(UIColor *)titleColor
        imageBackgroundNormal:(NSString *)imageBackgroundNormal
   imageBackgroundHighlighted:(NSString *)imageBackgroundHighlighted
                       target:(id)target
                       action:(SEL)selector {
    return [self buttonWithFrame:frame title:title titleFont:titleFont titleColor:titleColor titleHighlightColor:nil titleSelectedColor:nil titleDisabledColor:nil imageNormal:nil imageHighlighted:nil imageSelected:nil imageDisabled:nil imageBackgroundNormal:[UIImage imageNamed:imageBackgroundNormal] imageBackgroundHighlighted:[UIImage imageNamed:imageBackgroundHighlighted] imageBackgroundSelected:nil imageBackgroundDisabled:nil target:target action:selector tag:0];
}

+ (UIButton *)buttonWithTitle:(NSString *)title
                    titleFont:(UIFont *)titleFont
                   titleColor:(UIColor *)titleColor
        imageBackgroundNormal:(NSString *)imageBackgroundNormal
   imageBackgroundHighlighted:(NSString *)imageBackgroundHighlighted
                       target:(id)target
                       action:(SEL)selector {
    return [self buttonWithFrame:CGRectZero title:title titleFont:titleFont titleColor:titleColor imageBackgroundNormal:imageBackgroundNormal imageBackgroundHighlighted:imageBackgroundHighlighted target:target action:selector];
}

//常用按钮（背景图：normal highlighted）
+ (UIButton *)buttonWithTitle:(NSString *)title
                    titleFont:(UIFont *)titleFont
                   titleColor:(UIColor *)titleColor
           titleDisabledColor:(UIColor *)titleDisabledColor
        imageBackgroundNormal:(NSString *)imageBackgroundNormal
   imageBackgroundHighlighted:(NSString *)imageBackgroundHighlighted
      imageBackgroundDisabled:(NSString *)imagBackgroundeDisabled
                       target:(id)target
                       action:(SEL)selector {
    return [self buttonWithFrame:CGRectZero title:title titleFont:titleFont titleColor:titleColor titleHighlightColor:nil titleSelectedColor:nil titleDisabledColor:titleDisabledColor imageNormal:nil imageHighlighted:nil imageSelected:nil imageDisabled:nil imageBackgroundNormal:[UIImage imageNamed:imageBackgroundNormal] imageBackgroundHighlighted:[UIImage imageNamed:imageBackgroundHighlighted] imageBackgroundSelected:[UIImage imageNamed:imagBackgroundeDisabled] imageBackgroundDisabled:nil target:target action:selector tag:0];
}

#pragma mark -
#pragma mark - CustomButton

+ (UIButton *)buttonWithTitle:(NSString *)title
                       target:(id)target
                       action:(SEL)selector {
    return [UIButton buttonWithTitle:title titleFont:[UIFont systemFontOfSize:16.0f] titleColor:[UIColor whiteColor] titleDisabledColor:[UIColor lightGrayColor] imageBackgroundNormal:@"public_button11_normal" imageBackgroundHighlighted:@"public_button11_click" imageBackgroundDisabled:@"public_button12" target:target action:selector];
}

@end
