//
//  HDCNotifyHUD.m
//  HDHLProject
//
//  Created by hdcai on 15/8/4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//
#import "HDCNotifyHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "BDKNotifyHUDBGView.h"

#define kHDCBDKNotifyHUDDefaultRoundness    5.0f
#define kHDCBDKNotifyHUDDefaultOpacity      0.85f
#define kHDCBDKNotifyHUDDefaultPadding      21.0f //笑脸顶部距离（之前为10）
#define kHDCBDKNotifyHUDDefaultInnerPadding 6.0f
#define kHDCBDKNotifyHUDDefaultSpace        15.0f //笑脸与文字间隔

@implementation NSObject (PerformBlockAfterDelay)

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay {
    block = [block copy];
    [self performSelector:@selector(fireBlockAfterDelay:) withObject:block afterDelay:delay];
}

- (void)fireBlockAfterDelay:(void (^)(void))block {
    block();
}

@end

@interface HDCNotifyHUD ()


@property (strong, nonatomic) UIView *fullBgView;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *textLabel;

- (void)recalculateHeight;
- (void)adjustTextLabel:(UILabel *)label;
- (void)fadeAfter:(CGFloat)duration speed:(CGFloat)speed completion:(void (^)(void))completion;

@end

@implementation HDCNotifyHUD

#pragma mark - Lifecycle

+ (id)notifyHDCHUDWithImage:(UIImage *)image text:(NSString *)text {
    return [[self alloc] initWithImage:image text:text];
}

+ (void)showHDCHUDInView:(UIView *)inView image:(UIImage *)image text:(NSString *)text
{
    [self showHDCHUDInView:inView image:image text:text completion:nil];
}

+ (void)showHDCHUDInView:(UIView *)inView image:(UIImage *)image text:(NSString *)text completion:(void (^)(void))completion
{
    //设置背景
    BDKNotifyHUDBGView *_fullBgView = [[BDKNotifyHUDBGView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    _fullBgView.bounds = [UIApplication sharedApplication].keyWindow.bounds;
    [inView addSubview:_fullBgView];
    _fullBgView.backgroundColor = [UIColor clearColor];
    _fullBgView.center = [UIApplication sharedApplication].keyWindow.center;
    
    //设置全屏半透明背景
    UIView *bgView = [[UIView alloc] initWithFrame:_fullBgView.bounds];
    bgView.backgroundColor = [UIColor clearColor];
    bgView.center = _fullBgView.center;
    [_fullBgView addSubview:bgView];
    
    HDCNotifyHUD *hud = [HDCNotifyHUD notifyHDCHUDWithImage:image text:text];
    hud.center = _fullBgView.center;
    [_fullBgView addSubview:hud];
    [_fullBgView bringSubviewToFront:hud];
    
    [hud presentWithDuration:0.5f speed:0.5f inView:inView completion:^{
        
        if (completion)
        {
            completion();
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            _fullBgView.alpha = 0;
        } completion:^(BOOL finished) {
            [_fullBgView removeFromSuperview];
            [hud removeFromSuperview];
        }];
        
    }];
    
}


+ (CGRect)defaultFrameWithText:(NSString *)text
{
    CGSize size = [text sizeWithFont:[UIFont boldSystemFontOfSize:17] boundingRectWithSize:CGSizeMake(kHDCBDKNotifyHUDDefaultMaxWidth, MAXFLOAT)];
    return CGRectMake(0, 0, MAX(size.width, kHDCBDKNotifyHUDDefaultWidth), MAX(size.height, kHDCBDKNotifyHUDDefaultHeight));
}

- (id)initWithImage:(UIImage *)image text:(NSString *)text {
    
    if ((self = [self initWithFrame:[self.class defaultFrameWithText:text]]))
    {
        self.image = image;
        self.text = text;
        self.roundness = kHDCBDKNotifyHUDDefaultRoundness;
        self.borderColor = [UIColor clearColor];
        self.destinationOpacity = kHDCBDKNotifyHUDDefaultOpacity;
        self.currentOpacity = 0.0f;
        [self addSubview:self.backgroundView];
        [self addSubview:self.imageView];
        [self addSubview:self.textLabel];
        [self recalculateHeight];
    }
    return self;
}

- (void)presentWithDuration:(CGFloat)duration speed:(CGFloat)speed inView:(UIView *)view completion:(void (^)(void))completion {
    self.isAnimating = YES;
    [UIView animateWithDuration:speed animations:^{
        [self setCurrentOpacity:self.destinationOpacity];
    } completion:^(BOOL finished)
     {
         //        if (finished)
         [self fadeAfter:duration speed:speed completion:completion];
     }];
}

- (void)fadeAfter:(CGFloat)duration speed:(CGFloat)speed completion:(void (^)(void))completion {
    [self performBlock:^{
        [UIView animateWithDuration:speed animations:^{
            [self setCurrentOpacity:0.0];
        } completion:^(BOOL finished) {
            //if (finished) {
            self.isAnimating = NO;
            if (completion != nil) completion();
            //  }
        }];
    } afterDelay:duration];
}

#pragma mark - Setters

- (void)setRoundness:(CGFloat)roundness {
    if (_backgroundView != nil) self.backgroundView.layer.cornerRadius = roundness;
    _roundness = roundness;
}

- (void)setBorderColor:(UIColor *)borderColor {
    if (_backgroundView != nil) self.backgroundView.layer.borderColor = [borderColor CGColor];
    _borderColor = borderColor;
}

- (void)setText:(NSString *)text {
    if (_textLabel != nil) {
        self.textLabel.text = text;
        [self adjustTextLabel:self.textLabel];
    }
    _text = text;
}

- (void)setImage:(UIImage *)image {
    if (_imageView != nil) self.imageView.image = image;
    _image = image;
}

- (void)setCurrentOpacity:(CGFloat)currentOpacity {
    self.imageView.alpha =  1.0f;
    self.textLabel.alpha =  1.0f;
    self.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    _currentOpacity = currentOpacity;
}

#pragma mark - Getters

- (UIView *)backgroundView {
    
    if (_backgroundView != nil) return _backgroundView;
    
    _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    _backgroundView.layer.cornerRadius = self.roundness;
    _backgroundView.layer.borderWidth = 1.0f;
    _backgroundView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0f];
    _backgroundView.layer.borderColor = [self.borderColor CGColor];
    
    return _backgroundView;
}

- (UIImageView *)imageView {
    if (_imageView != nil) return _imageView;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.contentMode = UIViewContentModeCenter;
    if (self.image != nil) {
        _imageView.image = self.image;
        CGRect frame = _imageView.frame;
        frame.size = self.image.size;
        frame.origin = CGPointMake((self.backgroundView.frame.size.width - frame.size.width) / 2, kHDCBDKNotifyHUDDefaultPadding);
        _imageView.frame = frame;
        _imageView.alpha = 0.0f;
    }
    
    return _imageView;
}

- (UILabel *)textLabel {
    if (_textLabel != nil) return _textLabel;
    
    CGRect frame = CGRectMake(0, floorf(CGRectGetMaxY(self.imageView.frame) + kHDCBDKNotifyHUDDefaultInnerPadding),
                              floorf(self.backgroundView.frame.size.width),
                              floorf(self.backgroundView.frame.size.height / 2.0f));
    _textLabel = [[UILabel alloc] initWithFrame:frame];
    _textLabel.font = [UIFont systemFontOfSize:14];
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.alpha = 0.0f;
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.numberOfLines = 0;
    if (self.text != nil) _textLabel.text = self.text;
    [self adjustTextLabel:_textLabel];
    [self recalculateHeight];
    
    return _textLabel;
}

#pragma mark - UIView

- (void)layoutSubviews {
    [self recalculateHeight];
}

- (void)adjustTextLabel:(UILabel *)label {
    CGRect frame = _textLabel.frame;
    frame.size.width = self.backgroundView.frame.size.width;
    _textLabel.frame = frame;
    [label sizeToFit];
    frame = _textLabel.frame;
    frame.origin.x = floorf((self.backgroundView.frame.size.width - _textLabel.frame.size.width) / 2);
    frame.origin.y = floorf(self.imageView.frame.origin.y + self.imageView.frame.size.height + kHDCBDKNotifyHUDDefaultSpace);
    _textLabel.frame = frame;
}

- (void)recalculateHeight {
    CGRect frame = self.backgroundView.frame;
    frame.size.height = CGRectGetMaxY(self.textLabel.frame) + kHDCBDKNotifyHUDDefaultPadding;
    self.backgroundView.frame = frame; //自动适应高度
}

@end
