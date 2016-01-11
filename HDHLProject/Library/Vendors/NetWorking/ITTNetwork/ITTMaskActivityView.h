//
//  ITTMaskActivityView.h
//  iTotemFramework
//
//  Created by jack 廉洁 on 3/28/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "XibView.h"

@interface ITTMaskActivityView : XibView

@property (retain, nonatomic) IBOutlet UIView *bgMaskView;

- (void)showInView:(UIView*)parentView;
- (void)hide;
@end
