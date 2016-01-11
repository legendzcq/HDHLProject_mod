//
//  FrameView.m
//  iSchool
//
//  Created by ligh on 13-9-26.
//
//

#import "FrameView.h"


@implementation FrameView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
//    self.layer.cornerRadius = 3;
//    self.layer.borderColor =   UIColorFromRGB(220,220,220).CGColor;
//    self.layer.borderWidth = 0.5;
    self.layer.masksToBounds = YES;//设为NO去试试

}

@end
