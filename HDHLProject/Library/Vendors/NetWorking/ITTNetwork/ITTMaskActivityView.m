//
//  ITTMaskActivityView.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 3/28/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTMaskActivityView.h"

@interface ITTMaskActivityView()
{
    IBOutlet UIImageView *_imageView;
}
@end

@implementation ITTMaskActivityView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _imageView.animationImages = @[UIImageForName(@"public_loading1"),UIImageForName(@"public_loading2"),UIImageForName(@"public_loading3"),UIImageForName(@"public_loading4")];
    [_imageView setAnimationDuration:1];
    
    _bgMaskView.layer.masksToBounds = YES;
    _bgMaskView.layer.cornerRadius = 5;
}

- (void)showInView:(UIView*)parentView
{
    self.frame = parentView.bounds;
    [_imageView startAnimating];
    self.alpha = 0;
    [parentView addSubview:self];
    [UIView animateWithDuration:0.3 
                     animations:^{
                         self.alpha = 1;
                     } 
                     completion:^(BOOL finished) {
                         //
                     }];
}

- (void)hide
{
        [_imageView startAnimating];
    [UIView animateWithDuration:0.3 
                     animations:^{
                         self.alpha = 0;
                     } 
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}
- (void)dealloc {
    [_bgMaskView release];
    [_imageView release];
    [super dealloc];
}
@end
