//
//  ExpandHeaderView.m
//  Carte
//
//  Created by ligh on 14-4-12.
//
//

#import "ComboxHeaderView.h"

@implementation ComboxHeaderView



- (void)dealloc
{
    RELEASE_SAFELY(_nameLabel);
    RELEASE_SAFELY(_titleLabel);
    RELEASE_SAFELY(_arrowButton);
    RELEASE_SAFELY(_actionButton);
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    _nameLabel.textColor = ColorForHexKey(AppColor_Second_Level_Title1);
    _titleLabel.textColor = ColorForHexKey(AppColor_Content_Text3);
}

@end
