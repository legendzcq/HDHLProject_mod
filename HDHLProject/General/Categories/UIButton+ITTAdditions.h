//
//  UIButton+ITTAdditions.h
//  iTotemFrame
//
//  Created by jack 廉洁 on 3/15/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ITTAdditions)

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
                          tag:(NSInteger)tag;

//图片样式按钮
+ (UIButton *)buttonWithFrame:(CGRect)frame
                  imageNormal:(NSString *)imageNormal
             imageHighlighted:(NSString *)imageHighlighted
                       target:(id)target
                       action:(SEL)selector;

//标题按钮（背景图：normal highlighted）
+ (UIButton *)buttonWithFrame:(CGRect)frame
                        title:(NSString *)title
                    titleFont:(UIFont *)titleFont
                   titleColor:(UIColor *)titleColor
        imageBackgroundNormal:(NSString *)imageBackgroundNormal
   imageBackgroundHighlighted:(NSString *)imageBackgroundHighlighted
                       target:(id)target
                       action:(SEL)selector;
+ (UIButton *)buttonWithTitle:(NSString *)title
                    titleFont:(UIFont *)titleFont
                   titleColor:(UIColor *)titleColor
        imageBackgroundNormal:(NSString *)imageBackgroundNormal
   imageBackgroundHighlighted:(NSString *)imageBackgroundHighlighted
                       target:(id)target
                       action:(SEL)selector;

//常用按钮（背景图：normal highlighted） 
+ (UIButton *)buttonWithTitle:(NSString *)title
                    titleFont:(UIFont *)titleFont
                   titleColor:(UIColor *)titleColor
           titleDisabledColor:(UIColor *)titleDisabledColor
        imageBackgroundNormal:(NSString *)imageBackgroundNormal
   imageBackgroundHighlighted:(NSString *)imageBackgroundHighlighted
      imageBackgroundDisabled:(NSString *)imagBackgroundeDisabled
                       target:(id)target
                       action:(SEL)selector;


#pragma mark -
#pragma mark - CustomButton
//项目底部视图常用的
+ (UIButton *)buttonWithTitle:(NSString *)title
                       target:(id)target
                       action:(SEL)selector;

@end
