//
//  UIImage(ITTAdditions).h
//  
//
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage(ITTAdditions)

- (UIImage *)imageRotatedToCorrectOrientation;
- (UIImage *)imageCroppedWithRect:(CGRect)rect;
- (UIImage *)imageFitInSize: (CGSize) viewsize;
- (UIImage *)imageScaleToFillInSize: (CGSize) viewsize;

 //拉伸图片
+ (UIImage *)resizableWithImage:(UIImage *)image;
+ (UIImage *)resizableWithImage:(UIImage *)image edgeInsets:(UIEdgeInsets)edgeInsets;

@end
