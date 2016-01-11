//
//  FrameViewWB.m
//  Carte
//
//  Created by ligh on 14-12-31.
//
//

#import "FrameViewWB.h"

@implementation FrameViewWB

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
//    self.layer.cornerRadius = 3;
    self.layer.borderColor =   UIColorFromRGB(220,220,220).CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.masksToBounds = YES;//设为NO去试试
}

@end
