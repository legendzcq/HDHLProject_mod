//
//  RoundActionView.m
//  Carte
//
//  Created by zln on 14/12/19.
//
//

#import "RoundActionView.h"

@implementation RoundActionView


- (void)dealloc {
    RELEASE_SAFELY(_actionImageView);
    RELEASE_SAFELY(_actionLabel);
    RELEASE_SAFELY(_roundActionButton);
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    _actionLabel.textColor = ColorForHexKey(AppColor_Function_Default_Text);
}
@end
