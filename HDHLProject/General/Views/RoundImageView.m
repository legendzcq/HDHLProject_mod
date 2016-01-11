//
//  RoundImageView.m
//  Travelbag
//
//  Created by ligh on 13-12-1.
//  Copyright (c) 2013年 partner. All rights reserved.
//

#import "RoundImageView.h"

@implementation RoundImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     
        [self configRoundImageView];
    }
    return self;
}

-(void)awakeFromNib
{
    
    [super awakeFromNib];

    [self configRoundImageView];
    
}

-(void) configRoundImageView
{
    
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.layer.masksToBounds = YES;
    [self.layer setCornerRadius:2];
    
//    self.layer.borderColor = UIColorFromRGB(220, 220, 220).CGColor;
//    self.layer.borderWidth = 1;
//    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
//    
//    self.contentMode = UIViewContentModeScaleAspectFill;
//    self.layer.masksToBounds = YES;
//    [self.layer setCornerRadius: MIN(self.width,self.height)/2.0];
}

@end
