//
//  NotLoginView.h
//  HDHLProject
//
//  Created by liu on 15/8/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "XibView.h"


typedef void (^MyBlock)();
@interface NotLoginView : XibView

@property (nonatomic,copy)MyBlock block;
+ (void)showInView:(UIView *)view WithText:(NSString *)messageString WithBoolTableBarView:(BOOL)tableBarView  WithBlock:(void(^)())clickBlock;
+ (void)dismissFromSuperView:(UIView *)contentView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (nonatomic,assign) BOOL tableBarView;
@end
