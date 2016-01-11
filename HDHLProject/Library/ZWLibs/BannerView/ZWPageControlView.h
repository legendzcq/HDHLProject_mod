//
//  ZWPageControlView.h
//  bannerView
//
//  Created by ligh on 15-5-6.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZWPageControlView : UIView

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, retain) UIImage *firstImage;

- (id)initWithPageNum:(NSInteger)pageNum pageImageName:(NSString *)pageImageName checkedPageImageName:(NSString *)checkedPageImageName pageSpace:(CGFloat)pageSpace;

@end
