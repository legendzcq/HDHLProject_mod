//
//  HDCNotifyHUD.h
//  HDHLProject
//
//  Created by hdcai on 15/8/4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDKNotifyHUDBGView.h"

#define kHDCBDKNotifyHUDDefaultMaxWidth 260.0f

#define kHDCBDKNotifyHUDDefaultWidth  165.0f

#define kHDCBDKNotifyHUDDefaultHeight 120.0f


@interface HDCNotifyHUD : UIView

@property (nonatomic) CGFloat destinationOpacity;
@property (nonatomic) CGFloat currentOpacity;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) CGFloat roundness;
@property (nonatomic) BOOL bordered;
@property (nonatomic) BOOL isAnimating;

@property (strong, nonatomic) UIColor *borderColor;
@property (strong, nonatomic) NSString *text;

+ (id)notifyHDCHUDWithImage:(UIImage *)image text:(NSString *)text;
+ (void)showHDCHUDInView:(UIView *)inView image:(UIImage *)image text:(NSString *)text;
+ (void)showHDCHUDInView:(UIView *)inView image:(UIImage *)image text:(NSString *)text completion:(void (^)(void))completion;

- (id)initWithImage:(UIImage *)image text:(NSString *)text;

- (void)presentWithDuration:(CGFloat)duration speed:(CGFloat)speed inView:(UIView *)view completion:(void (^)(void))completion;

@end

