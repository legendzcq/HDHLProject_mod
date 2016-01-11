//
//  ZWPageControlView.m
//  bannerView
//
//  Created by ligh on 15-5-6.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "ZWPageControlView.h"

@interface ZWPageControlView () {
    float dotImageWidth;
    float dotImageHeight;
}
@end

@implementation ZWPageControlView

- (id)initWithPageNum:(NSInteger)pageNum pageImageName:(NSString *)pageImageName checkedPageImageName:(NSString *)checkedPageImageName pageSpace:(CGFloat)pageSpace {
    
    UIImage *dotImage = [UIImage imageNamed:pageImageName];
    
    dotImageWidth = dotImage.size.width;
    dotImageHeight = dotImage.size.height;
    
    float pageViewWidth =  (pageNum * dotImageWidth) + ((pageNum - 1) * pageSpace);
    
    self = [super initWithFrame:CGRectMake(0, 0, pageViewWidth, dotImageHeight)];
    _pageNum = pageNum;
    
    for (int i = 0; i < _pageNum; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:dotImage forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:checkedPageImageName] forState:UIControlStateSelected];
        [button setFrame:CGRectMake((dotImageWidth + pageSpace) * i, 0, dotImageWidth, dotImageHeight)];
        button.tag = i + 1;
        [self addSubview:button];
        
        //默认从第一个开始
        if (i == 0) {
            button.selected = YES;
        }
    }
    
    return self;
    
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    for (int i = 0; i< _pageNum; i ++)
    {
        UIButton *button  = (UIButton *)[self viewWithTag:i + 1];
        button.selected = i == currentPage;
    }
}

@end
